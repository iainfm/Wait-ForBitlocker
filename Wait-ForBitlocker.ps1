# Script to wait until drive encryption is complete
# or a set time has elapsed (whichever comes first)
# For ESP of laptop builds
#
# Iain McLaren (DXC EUC) - iain.mclaren2@dxc.com
# 24 June 2021
#
# Seems most reliable to run via Endpoint Manager when converted
# to an exe with Win-PS2EXE - https://github.com/MScholtes/TechNet-Gallery/tree/master/PS2EXE-GUI

param (
	[int]$Minutes = 30,                          # Minutes to wait for encryption
	[string]$DetectionText = "FullyEncrypted",   # String to look for in the Get-BitLockerVolume output
	[int]$ReturnCode = 1707                      # Error code to return if encryption doesn't complete in $Minutes
)

# Check to see if the drive is already encrypted, and exit if so
$enc = Get-BitLockerVolume -MountPoint ${env:SystemDrive}

if ($enc.VolumeStatus -eq $DetectionText) { # Exit if encryption already complete
	# Return success
	Write-Host "Success"
	exit 0
}

# Otherwise...

# Script to be created and called as a scheduled task to notify the user a reboot is required
$file = "${env:PROGRAMDATA}\Tell-UserReboot.ps1"

# Set up the scheduled task that displays a pop-up message to the user to register later if required
$user = (Get-CimInstance -Namespace "root\cimv2" -ClassName Win32_ComputerSystem).Username
$A = New-ScheduledTaskAction -Execute "powershell.exe" -Argument "-ex bypass -noninteractive -windowstyle hidden -file $file"
$T = New-ScheduledTaskTrigger -At "1/11/2050 3:00:00 AM" -Once
$P = New-ScheduledTaskPrincipal $user
$S = New-ScheduledTaskSettingsSet -AllowStartIfOnBatteries
$D = New-ScheduledTask -Action $A -Principal $P -Trigger $T -Settings $S

# Begin the wait for encryption to complete
$start_time = Get-Date

if ($enc.VolumeStatus -ne $DetectionText) {
	do {
		sleep 30
		$enc = Get-BitLockerVolume -MountPoint ${env:SystemDrive}
		$now = Get-Date
		$duration = New-TimeSpan -Start $start_time -End $now
		
		if ($duration.Minutes -ge $Minutes) {
			# Abort if time limit is reached
			# After discussion it was decided to not feedback anything to the user if timeout has expired.
			# But add here if this ever changes (amend $task message and call Register-ScheduledTask and Start-ScheduledTask)
			# For now, exit with success
            Write-Host "Exiting"
			Exit $ReturnCode
		}
	
	} while ($enc.VolumeStatus -ne $DetectionText)
}

# On encryption completion:

# Create the Scheduled task script that displays a message to the user. Beware the back-ticked quotes for the text.
$task = "
`$title = 'Device setup complete'
`$message = `"Welcome to your new DVSA device. Setup has now finished, but some facilities will not be available until after a restart.

Please wait until you see the 'You are now syncing OneDrive' notification, then reboot your device.

Installation of some applications will continue after you restart.`"

[void] [System.Reflection.Assembly]::LoadWithPartialName(`"Microsoft.VisualBasic`")
[Microsoft.VisualBasic.Interaction]::MsgBox(`$message, `"OKonly,SystemModal,Information`", `$title)
" | Out-File $file -ErrorAction Ignore

# Commit the scheduled task (will be cleaned up later by another app
Register-ScheduledTask TellUserReboot -InputObject $D -Force | Out-Null

# Restart ZScaler Tray application (may be futile)
Stop-Process -Name ZSATray -Force -ErrorAction Ignore

# Trigger a run-once event
Start-ScheduledTask -TaskName TellUserReboot

# Exit
Write-Host "Success"
Exit 0