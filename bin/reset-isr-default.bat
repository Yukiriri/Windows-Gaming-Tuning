powercfg -SetAcValueIndex Scheme_Current Sub_IntSteer Mode 0
powercfg -SetDcValueIndex Scheme_Current Sub_IntSteer Mode 0

bcdedit /DeleteValue UsePlatformTick
bcdedit /DeleteValue DisableDynamicTick

reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Session Manager\kernel" /v "ReservedCpuSets" /t REG_BINARY /d 0000000000000000 /f
