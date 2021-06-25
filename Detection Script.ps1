$BV = Get-BitLockerVolume -MountPoint ${env:SystemDrive}
$file = "${env:PROGRAMDATA}\Tell-UserReboot.ps1"
if (($BV.VolumeStatus -eq "FullyEncrypted") -Or (Test-Path $file)) {
	write-output "Found"
}