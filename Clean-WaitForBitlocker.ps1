# Script to tidy up Wait for Bitlocker task and ps1 file
#
# Iain McLaren (DXC EUC) - iain.mclaren2@dxc.com
# 23 June 2021
#
# Seems most reliable to run via Endpoint Manager when converted
# to an exe with Win-PS2EXE - https://github.com/MScholtes/TechNet-Gallery/tree/master/PS2EXE-GUI
#

$taskFile = "${env:PROGRAMDATA}\Tell-UserReboot.ps1"
$taskName = "TellUserReboot"

Unregister-ScheduledTask -TaskName $taskName -Confirm:$false -ErrorAction Ignore
Remove-Item -Force $taskFile -ErrorAction Ignore

# Success is nice but not a necessity, so assume all ok.

Write-Host "Success"
Exit 0