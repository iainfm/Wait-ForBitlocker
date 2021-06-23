# Dectection script for Clean-WaitForBitlocker
#
# Iain McLaren (DXC EUC) - iain.mclaren2@dxc.com
# 23 June 2021
#

# Which to test for...? $taskFile is easiest!
$taskFile = "${env:PROGRAMDATA}\Tell-UserReboot.ps1"
$taskName = "TellUserReboot"

if ((Test-Path $taskFile) -eq $False) {
	Write-Host "Success"
	Exit 0
}
Exit 0