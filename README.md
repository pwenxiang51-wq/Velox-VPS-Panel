# 🚀 Velox VPS Panel - 极客专属全能运维终端 (V5.2 满血终极版)

![License](https://img.shields.io/badge/License-MIT-blue.svg) ![Bash](https://img.shields.io/badge/Language-Bash-green.svg) ![Version](https://img.shields.io/badge/Version-V5.2-orange.svg) ![Platform](https://img.shields.io/badge/Platform-Debian%20%7C%20Ubuntu%20%7C%20CentOS-lightgrey.svg)

> **“不只是一个面板，它是拥有极客级智能感知与底层防爆机制的 VPS 私人管家。”**
> 
> 作者 GitHub: [@pwenxiang51-wq](https://github.com/pwenxiang51-wq) | 官方博客: [222382.xyz](https://222382.xyz) | 报告 Bug: [Issues](https://github.com/pwenxiang51-wq/Velox-VPS-Panel/issues)

Velox Panel 是一款专为极客与重度折腾玩家打造的 Linux 终端运维面板。**V5.2 终极版**引入了史诗级的**“全域架构防爆护盾”**与**“国际风控体检雷达”**，将复杂的代理维护、网络调优、安全防盗与跨机容灾，全部浓缩进了极致克制、色彩统一的高级交互菜单中。

---

## 📸 极客终端美学 (Screenshots)

![Velox 极客主菜单](Screenshots.png)

---

## ✨ 核心黑科技 (Core Features)

### 🧠 1. 史诗级智能环境感知与防爆盾 (New!)
告别传统的“死板执行”，Velox 拥有真正的底层探针：
- **LXC/OpenVZ 架构全局防爆**：智能拦截阉割版容器进行高危内核调优（如 BBR、队列算法、Swap 分配），自动输出免责护盾，**彻底告别小鸡改内核失联卡死的千古难题**。
- **动态分流嗅探雷达**：跑流媒体测试时，自动侦测 SOCKS5 端口与 WARP 虚拟网卡，强行接管测速流量，实现无感真·分流测试。

### 🛡️ 2. 原子级写入与绝对防断流 (New!)
- **核心引擎原子化**：拉取远程脚本与核心配置文件时，采用 `/tmp + mv` 极客级原子写入机制。即使下载中途网线被拔，面板及节点也绝对毫发无损。

### 🚨 3. 双核防御与 TG 智能闭环
- **SSH 隐身防盗门**：一键飞升纯密钥模式，并可根据机器架构智能选择部署重型装甲 `Fail2Ban`，或极简免依赖的 `Bash 底层机枪塔`。
- **全局 TG 凭证池**：一次配置，全域共享。神盾局异地登录预警、流量熔断红线报警、开机存活体检报表，实现极速秒达。

### 🌍 4. 国际顶级风控体检雷达 (New!)
- 摒弃国内存在偏差的传统 IP 库，全面接入 **IP-API** 与 **IPinfo** 国际基因库，并直通全球第一欺诈拦截网 **Scamalytics**，把奇葩商家的 IP 底裤扒得干干净净。

### 🧳 5. 全域资产一键克隆与星际舰队
- **无痕跨机搬家**：一键打包所有面板数据、节点配置、Acme 证书及定时任务，新机器一键解压，满血复活。
- **星际舰队群控**：生成 Velox 专属独立兵符，一键向所有僚机群发 Linux 运维指令。

---

## 🚀 极速部署 (Installation)

无需任何前置环境，直接在您的 VPS 终端 (推荐使用 `root` 用户) 执行以下官方命令，即可一键安装并自动唤醒面板：

```bash
bash <(curl -sL [https://raw.githubusercontent.com/pwenxiang51-wq/Velox-VPS-Panel/main/install.sh](https://raw.githubusercontent.com/pwenxiang51-wq/Velox-VPS-Panel/main/install.sh))
```
*(注：后续直接在终端输入 `velox` 即可随时唤醒面板)*


---


## 💻 兼容性说明 (Compatibility)

本脚本高度依赖 `systemd` 作为底层守护支持，并已针对多种环境进行代码级容错与防抖处理：

- 🟢 **完美兼容**: Debian 11/12, Ubuntu 20.04/22.04/24.04 (推荐)
- 🟡 **高度兼容**: CentOS 7/8/9, AlmaLinux, Rocky Linux
- 🔴 **不建议/不支持**: Alpine Linux (无 Systemd 环境), OpenVZ 架构 (受限的内核网络调优)

---

## 🛡️ 卸载说明 (Uninstall)

如果你想让系统恢复极其纯净的出厂状态，可在面板主菜单输入 `U` 进行卸载。
系统将启动**焦土化物理粉碎程序**，抹除所有面板、防御机枪塔、监控探针及网络调优参数，**但会自动智能保留你的代理节点容器与 Acme 证书**，保证业务不断网！

---

## ☕ 赞赏与支持

开源不易，如果 Velox 面板让你的折腾之旅变得更加优雅，为你节省了宝贵的时间，请务必在右上角给我点一个 **Star ⭐️**！你的点赞是我持续维护的唯一动力。

如果大佬觉得项目超赞，欢迎通过微信扫码请我喝杯冰美式，感激不尽！🚀

<div align="center">
    <img src="donate.png" alt="Velox 赞赏码" width="350" />
    <br />
    <br />
    <b>“ 感谢 velox 请喝咖啡！ ”</b>
</div>

<br />

Made with ❤️ by [pwenxiang51-wq](https://github.com/pwenxiang51-wq)
