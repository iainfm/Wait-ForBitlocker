### For use in Enrolment Status Page - Waits for drive encrpytion to complete.

Assign to users, not devices. Run as system context.

Optional Parameters:

**-Minutes [int]** : Time to wait for encryption to complete before exiting. Default 30.

**-DetectionText [string]** : String to detect for completed drive encryption. Default "FullyEncrypted"

**-ReturnCode [int]** : Return code to exit with when encryption has timed out. Default 1707.

*Scheduled task and ps1 file tided up by Clean-WaitForBitlocker.ps1*

## How to use ##

Assumptions:
* Intune/EPM environment with a policy deployed that requires OS drive encryption
* ESP policy created and configured
* Knowledge of intune packaging and intunewinapputil.exe

**All scripts should be set to run as the system account**

(Optional) complile with https://github.com/MScholtes/TechNet-Gallery/tree/master/PS2EXE-GUI (improves reliability in my experience).

(Optional) create an intune Win32 app for Tag-AsESPBuild.ps1 and assign it to a device group that will use ESP deployment.
This is to prevent the main Wait-ForBitlocker script running on non-ESP devices and providing false info to the end user.
Not required if all devices will be built using ESP. Use the registry key created by the script as the manual detection method.

Create an Intune Win32 app for Wait-ForBitlocker. Assign to an appropriate user group. Use the detection script provided as the custom detection method.

Create an Intune Win32 app for Clean-WaitForBitlocker. Assign to appropriate user group. Use the detection script provided as the custom detection method. Make the Wait-ForBitlocker app a dependency of Clean-WaitForBitlocker to ensure WfB executes first.


Build a device using ESP. All being well, the user setup phase will 'pause' while the Wait-ForBitlocker app 'installs'. When encryption is complete the desktop will appear and the 'build complete' message will appear.
