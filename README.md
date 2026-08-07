一份对Windows游戏的丝滑度、手感等因素的研究心得  

## 系统版本建议
请查看(https://learn.microsoft.com/windows-hardware/design/minimum/windows-processor-requirements)  
然后按照自己的CPU最高可用的Windows版本选择  

## 系统设置选项建议
| 系统版本 | 硬件加速GPU计划 | 窗口化游戏优化 |
| :------- | :-------------- | :------------- |
| <=23H2   | 不开            | 不开           |
| >=24H2   | 开              | 开             |

## 驱动建议
- 新显卡的`显卡驱动`需要定期更新，老显卡用系统自动装的驱动就是最稳定  

- 追求最新特性和最新BUG修复就选择`GameReady`驱动  

- 特别注重新驱动的稳定性可以选择`Studio`驱动  

- `网卡驱动`和`芯片组驱动`不要太老就好  

## 显示器建议
- 一定要注意显卡`DP`和`HDMI`接口版本和显示器接口版本是不是对等  
  其次如果要保证延迟稳定性，线材最长不超过`1.5m`  
  然后不要被显示器分辨率迷惑，4K高刷如果DP接口只有`DP1.4`，就必须开DSC使用  
  开DSC要付出很多代价，不开就没法用高刷  

- 用DP接口需要手动在显示器开启`AdaptiveSync`，HDMI接口是自动识别`VRR`  
  优先买拥有这2个`可变垂直同步`技术的显示器  
  注意这2个技术和`DSC`不兼容，`DSC`也和自定义刷新率不兼容  

- 非到必要，不选择超频档刷新率，只选择原生刷新率  
  超频档刷新率大部分都会导致显存无法休眠，永远在最高频  

- 进阶操作可以使用[CRU](https://github.com/kreier/cru)工具创建一个更稳的刷新率  
  计时标准选择`Automatic PC`，这个是消隐兼容性最好的计时  
  更稳的刷新率意思是把刷新率调整到`像素频率`不超过显示器面板带载上限  

> [!TIP]  
> 我个人更喜欢尽最大可能优选用DP  
> 我在用X3D CPU，搭配300HZ的屏幕，接的DP + 无DSC + AdaptiveSync + CRU调整消隐  
> 简直棒得不行  

## 关闭MPO
系统的MPO功能会在游戏高GPU负载时影响低GPU负载程序的画面更新，出现画面残留等，关闭这个功能可以缓解  

[set-mpo-disabled.bat ]: ../bin/set-mpo-disabled.bat
[reset-mpo-default.bat]: ../bin/reset-mpo-default.bat

- 修改方法  
  下载和管理员运行[set-mpo-disabled.bat]  
- 重置修改  
  下载和管理员运行[reset-mpo-default.bat]  

> [!IMPORTANT]  
> 需要重启生效  

> [!NOTE]  
> 运行一次即整个系统永久保持，不需要加入开机自启  

## 关闭鼠标增强指针精度
这是一个大幅影响鼠标手感的修改，推荐FPS选手  
如果要玩的游戏不支持`原始鼠标输入`，这个修改就可以消除鼠标加速带来的游戏里的奇怪鼠标手感  

[set-mouseacceleration-off.bat      ]: ../bin/set-mouseacceleration-off.bat
[reset-mouseacceleration-default.bat]: ../bin/reset-mouseacceleration-default.bat

- 修改方法  
  下载和管理员运行[set-mouseacceleration-off.bat]  
- 重置修改  
  下载和管理员运行[reset-mouseacceleration-default.bat]  

> [!IMPORTANT]  
> 需要重启生效  

> [!NOTE]  
> 运行一次即整个系统永久保持，不需要加入开机自启  

## 修改前后台时间片分配
这是一个细微影响鼠标手感的修改，推荐FPS选手  

[set-fgbgslice-fix31.bat    ]: ../bin/set-fgbgslice-fix31.bat
[set-fgbgslice-var31.bat    ]: ../bin/set-fgbgslice-var31.bat
[reset-fgbgslice-default.bat]: ../bin/reset-fgbgslice-default.bat

- 修改方法  
  - `低灵敏度玩家`：下载和管理员运行[set-fgbgslice-fix31.bat]  
  - `高灵敏度玩家`：下载和管理员运行[set-fgbgslice-var31.bat]  
- 重置修改  
  下载和管理员运行[reset-fgbgslice-default.bat]  

> [!IMPORTANT]  
> 需要重启生效  

> [!NOTE]  
> 运行一次即整个系统永久保持，不需要加入开机自启  

<details>
<summary>Win32PrioritySeparation二进制位解释</summary>

|          | 6~5位      | 4~3位      | 2~1位            |
| :------- | :--------- | :--------- | :--------------- |
| 解释     | 时间片长短 | 长短可变性 | 前后台时间片比例 |
| 数值作用 | 00 = 默认  | 00 = 默认  | 00 = 1:1         |
| 数值作用 | 01 = 长    | 01 = 可变  | 01 = 2:1         |
| 数值作用 | 10 = 短    | 10 = 固定  | 10 = 3:1         |
| 数值作用 | 11 = 默认  | 10 = 默认  | 11 = 3:1         |

举例：
- 二进制`010110`表示`可变长3:1`调度，对应十六进制`16`，十进制`22`
- 二进制`101010`表示`固定短3:1`调度，对应十六进制`2a`，十进制`42`

</details>

## 锁定ISR到CPU0
把ISR锁定到CPU0处理，可以防止ISR轮流到不同CPU核心反复切换C-State导致的延迟，尤其是鼠标的ISR收益会更大  
再把tick中断来源设置为强制LAPIC，可以阻止老游戏使用主板的慢速tick  

[set-isr-cpu0.bat     ]: ../bin/set-isr-cpu0.bat
[set-isr-lapic.bat    ]: ../bin/set-isr-lapic.bat
[reset-isr-default.bat]: ../bin/reset-isr-default.bat

- 修改方法  
  下载和管理员运行[set-isr-cpu0.bat]  
  下载和管理员运行[set-isr-lapic.bat]  
- 重置修改  
  下载和管理员运行[reset-isr-default.bat]  

> [!TIP]  
> 建议把鼠标设备插入到主板上能和CPU直连的PCIe链路上  
> 可以免去走芯片组中继  

> [!IMPORTANT]  
> 需要重启生效  

> [!NOTE]  
> 运行一次即整个系统永久保持，不需要加入开机自启  

建议也把CPU0设置为默认调度不使用的保留核心，防止用户层线程调度到CPU0上被ISR反复排挤  

[set-isr-cpu0-reserved.bat]: ../bin/set-isr-cpu0-reserved.bat

- 修改方法  
  下载和管理员运行[set-isr-cpu0-reserved.bat]  
- 重置修改  
  下载和管理员运行[reset-isr-default.bat]  

> [!NOTE]  
> 对于没有超线程的CPU，第1个CPU核心会被完全不可调度(除非设置Affinity)  

> [!IMPORTANT]  
> 需要重启生效  

> [!NOTE]  
> 运行一次即整个系统永久保持，不需要加入开机自启  

## 全局计时器精度
重新开启全局同步的最高计时器精度，可以让每个程序的中断计时器获得同等的最高精度  

[set-globaltimeres-enable.bat   ]: ../bin/set-globaltimeres-enable.bat
[reset-globaltimeres-default.bat]: ../bin/reset-globaltimeres-default.bat

- 修改方法  
  下载和管理员运行[set-globaltimeres-enable.bat]  
- 重置修改  
  下载和管理员运行[reset-globaltimeres-default.bat]  

> [!IMPORTANT]  
> 需要重启生效  

> [!NOTE]  
> 运行一次即整个系统永久保持，不需要加入开机自启  

## AMD关闭核心性能排序的方法
Windows事件日志中`Kernel-Processor-Power`的最大性能百分比，会直接影响Windows的线程调度分布  

- 单CCD AM4的关闭方法  
  BIOS中选择`CPPC Preferred Cores`为禁用  
- 双CCD或者AM5以后的关闭方法  
  BIOS中选择`PBO Per-core Boost Clock Limit`  
  - 属于CCD0的核心设置为高于CCD1的频率  
    (随便高多少)  
  - 属于CCD1的核心设置为CCD1的频率上限  
    (也可以是自己想要的上限)  

> [!NOTE]  
> 有研究兴趣可以尝试  
