reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Session Manager\kernel" /v "ReservedCpuSets" /t REG_BINARY /d 0100000000000000 /f
