# Windows-Gaming-Tuning
一份对Windows游戏的CPU性能、丝滑度、跟手等因素的研究心得  

## 系统版本建议
请查看(https://learn.microsoft.com/windows-hardware/design/minimum/windows-processor-requirements)  
然后按照自己的CPU最高可用的Windows版本选择  
当然了，条件不允许就不强求了  

## 系统设置选项建议
| 系统版本 | 硬件加速GPU计划 | 窗口化游戏优化 |
| :------- | :-------------- | :------------- |
| <=23H2   | 不开            | 不开           |
| >=24H2   | 开              | 开             |

## 驱动建议
- `显卡驱动`需要定期更新  
- `网卡驱动`和`芯片组驱动`不要太老就好  

## 显示器建议
- 非到必要，不选择超频档刷新率，只选择原生刷新率，因为超频刷新率在图像数据复杂时，会破坏垂直同步变成负收益  
- 优先选择拥有VRR以及低延迟技术的显示器  

## 改进系统Tick
大部分程序在使用微秒单位的等待事件的时候，Windows默认会使用RTC  
RTC对CPU开销非常大，如果因此导致瓶颈，就会破坏游戏的Tick精准性  
有人说AMD骨骼动画卡顿是因为`Clock Stretching`的原因，但我的实验证明，罪魁祸首单纯是RTC  
如果要用超过1000HZ的鼠标，强烈建议阻止RTC  

- 修改方法  
  下载和管理员运行[`set-rtc-disabled.bat`](../bin/set-rtc-disabled.bat)
- 还原修改  
  下载和管理员运行[`restore-rtc-default.bat`](../bin/restore-rtc-default.bat)

> [!IMPORTANT]  
> 需要重启生效  

> [!NOTE]  
> 运行一次即整个系统永久保持，不需要加入开机自启  

## 关闭MPO
系统的MPO功能会在游戏高GPU负载时影响低GPU负载程序的画面更新，出现画面残留等  
关闭这个功能可以缓解  

- 修改方法  
  下载和管理员运行[`set-mpo-disabled.bat`](../bin/set-mpo-disabled.bat)
- 还原修改  
  下载和管理员运行[`restore-mpo-default.bat`](../bin/restore-mpo-default.bat)

> [!IMPORTANT]  
> 需要重启生效  

> [!NOTE]  
> 运行一次即整个系统永久保持，不需要加入开机自启  

## 关闭鼠标增强指针精度
这是一套大幅影响鼠标手感的修改，推荐FPS选手  

- 修改方法  
  下载和管理员运行[`set-mouseacceleration-off.bat`](../bin/set-mouseacceleration-off.bat)
- 还原修改  
  下载和管理员运行[`restore-mouseacceleration-default.bat`](../bin/restore-mouseacceleration-default.bat)

> [!NOTE]  
> 运行一次即整个系统永久保持，不需要加入开机自启  

## 修改前后台调度运作
这是一套细微影响鼠标手感的修改，推荐FPS选手  

- 修改方法  
  下载和管理员运行[`set-fgbg-var31.bat`](../bin/set-fgbg-var31.bat)
  或者下载和管理员运行[`set-fgbg-fix31.bat`](../bin/set-fgbg-fix31.bat)
- 还原修改  
  下载和管理员运行[`restore-fgbg-default.bat`](../bin/restore-fgbg-default.bat)

<details>
<summary>Win32PrioritySeparation二进制位解释</summary>

|          | 6~5位     | 4~3位      | 2~1位          |
| :------- | :-------- | :--------- | :------------- |
| 解释     | 时间长短  | 长短可变性 | 前后台时间比例 |
| 数值作用 | 00 = 默认 | 00 = 默认  | 00 = 1:1       |
| 数值作用 | 01 = 长   | 01 = 可变  | 01 = 2:1       |
| 数值作用 | 10 = 短   | 10 = 固定  | 10 = 3:1       |

举例：
- 二进制`010110`表示`可变长3:1`调度，对应十六进制`16`，十进制`22`
- 二进制`101010`表示`固定短3:1`调度，对应十六进制`2a`，十进制`42`

建议：
- 低灵敏度玩家使用`22`
- 高灵敏度玩家使用`42`

</details>

> [!NOTE]  
> 运行一次即整个系统永久保持，不需要加入开机自启  

## Credits
- https://sites.google.com/view/melodystweaks/misconceptions-about-timers-hpet-tsc-pmt
