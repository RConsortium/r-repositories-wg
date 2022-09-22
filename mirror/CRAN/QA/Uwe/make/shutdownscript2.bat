IF DEFINED SICHERSHUT blat - -body "Shutdown %COMPUTERNAME%: Temperatures measured by USVs with %1 and %2 degrees Celsius." -to sysadmin@statistik.tu-dortmund.de -subject %COMPUTERNAME%_temperature_shutdown
IF DEFINED SICHERSHUT shutdown /f /s
exit
