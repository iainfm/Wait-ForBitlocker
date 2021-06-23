### For use in Enrolment Status Page - Waits for drive encrpytion to complete.

Compliled with https://github.com/MScholtes/TechNet-Gallery/tree/master/PS2EXE-GUI

Assign to users, not devices. Run as system context.

Optional Parameters:

**-Minutes [int]** : Time to wait for encryption to complete before exiting. Default 30.

**-DetectionText [string]** : String to detect for completed drive encryption. Default "FullyEncrypted"

**-ReturnCode [int]** : Return code to exit with when encryption has timed out. Default 1707.

*Scheduled task and ps1 file tided up by TODO: Insert app name here.*
