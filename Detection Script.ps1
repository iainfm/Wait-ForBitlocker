$BV = Get-BitLockerVolume -MountPoint ${env:SystemDrive}
if ($BV.VolumeStatus -eq "FullyEncrypted") {
	write-output "Found"
}