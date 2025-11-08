# Windows-Gaming-Experience
一份对Windows游戏的CPU性能、丝滑度、跟手等因素的研究心得  
AMD和Intel通用，台式和笔记本也通用  

> [!IMPORTANT]
> 全文提到的cmd命令都需要管理员身份运行  

> [!NOTE]
> 仓库的`bin`文件夹里有写好的一键脚本版  

## 系统版本
尽可能上最新的`Win11 24H2 26100.6899`  
当然了，条件不允许就不强求了  

## 系统设置选项
| 系统版本 | 硬件加速GPU计划 | 窗口化游戏优化 |
| :------- | :-------------- | :------------- |
| <=23H2   | 不开            | 不开           |
| >=24H2   | 不开白不开      | 可以开         |

## 驱动
- `显卡驱动`需要定期更新  
- `网卡驱动`和`芯片组驱动`不要太老就好  

## 修复系统Tick
大部分程序在使用微秒单位的等待事件的时候，Windows默认会使用RTC  
RTC对CPU开销非常大，如果因此导致瓶颈，就会破坏游戏的Tick精准性  
有人说AMD骨骼动画卡顿是因为`Clock Stretching`的原因，但我的实验证明，罪魁祸首单纯是RTC  
如果要用超过1000HZ的鼠标，强烈建议阻止RTC  
  
cmd命令一览：
- 恢复默认TSC
  ```
  bcdedit /DeleteValue UsePlatformClock >nul
  ```
- 阻止RTC
  ```
  bcdedit /Set UsePlatformTick No
  ```
- 禁用Tick节能
  ```
  bcdedit /Set DisableDynamicTick Yes
  ```

> [!IMPORTANT]
> 需要重启生效  

> [!NOTE]
> 运行一次即整个系统永久保持，不需要加入开机自启  
> 除非撤销了这些BCD选项，或者使用了新系统  

## 关闭鼠标增强指针精度
这是一套大幅影响鼠标手感的修改，推荐FPS选手  
  
cmd命令一览：
- 关闭增强指针精度
  ```
  reg add "HKEY_CURRENT_USER\Control Panel\Mouse" /v "MouseSpeed" /t REG_SZ /d "0" /f
  reg add "HKEY_CURRENT_USER\Control Panel\Mouse" /v "MouseThreshold1" /t REG_SZ /d "0" /f
  reg add "HKEY_CURRENT_USER\Control Panel\Mouse" /v "MouseThreshold2" /t REG_SZ /d "0" /f
  ```
- 恢复系统默认
  ```
  reg add "HKEY_CURRENT_USER\Control Panel\Mouse" /v "MouseSpeed" /t REG_SZ /d "1" /f
  reg add "HKEY_CURRENT_USER\Control Panel\Mouse" /v "MouseThreshold1" /t REG_SZ /d "6" /f
  reg add "HKEY_CURRENT_USER\Control Panel\Mouse" /v "MouseThreshold2" /t REG_SZ /d "10" /f
  ```

> [!NOTE]
> 运行一次即整个系统永久保持，不需要加入开机自启  
> 除非恢复默认，或者使用了新系统  

## 修改前后台调度运作
这是一套细微影响鼠标手感的修改，推荐FPS选手  
  
`Win32PrioritySeparation`二进制位解释
|          | 6~5位     | 4~3位      | 2~1位          |
| :------- | :-------- | :--------- | :------------- |
| 解释     | 时间长短  | 长短可变性 | 前后台时间比例 |
| 数值作用 | 00 = 默认 | 00 = 默认  | 00 = 1:1       |
| 数值作用 | 01 = 长   | 01 = 可变  | 01 = 2:1       |
| 数值作用 | 10 = 短   | 10 = 固定  | 10 = 3:1       |

举例：
- 二进制 010110 表示可变长3:1调度 对应十进制22 十六进制16
- 二进制 101010 表示固定短3:1调度 对应十进制42 十六进制2a

建议：
- 低灵敏度玩家使用22
- 高灵敏度玩家使用42

cmd命令一览：
- 22
  ```
  reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\PriorityControl" /v "Win32PrioritySeparation" /t REG_DWORD /d 16 /f
  ```
- 42
  ```
  reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\PriorityControl" /v "Win32PrioritySeparation" /t REG_DWORD /d 2a /f
  ```
- 恢复系统默认
  ```
  reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\PriorityControl" /v "Win32PrioritySeparation" /t REG_DWORD /d 2 /f
  ```

> [!NOTE]
> 运行一次即整个系统永久保持，不需要加入开机自启  
> 除非恢复默认，或者使用了新系统  

# Credits
- https://sites.google.com/view/melodystweaks/misconceptions-about-timers-hpet-tsc-pmt
