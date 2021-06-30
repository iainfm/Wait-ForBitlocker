# Script to tag a device build as being built with ESP. Prevents WfB running on non-ESP machines.
#
# Iain McLaren (DXC EUC) - iain.mclaren2@dxc.com
# 23 June 2021
#
# Seems most reliable to run via Endpoint Manager when converted
# to an exe with Win-PS2EXE - https://github.com/MScholtes/TechNet-Gallery/tree/master/PS2EXE-GUI
# Assign to devices and make a mandatory app in ESP.
# Use registry setting below as manual detection rule.

$regPath		 = 'HKLM:\Software\CORPNAME\DeviceBuild'
$regName		 = 'BuiltByESP'
New-Item $regPath -Force  -ErrorAction Stop | Out-Null
New-ItemProperty $regPath -Name $regName -Value 1 -PropertyType String -Force | Out-Null
Write-Host "Success"
Exit 0