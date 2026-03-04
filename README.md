# 🚀 Velox 专属 VPS 管理面板 (极客满血版 V4.1)

<div align="center">

![Bash](https://img.shields.io/badge/Language-Bash-blue.svg?style=flat-square)
![Platform](https://img.shields.io/badge/Platform-Debian%20%7C%20Ubuntu%20%7C%20CentOS%20%7C%20Rocky-brightgreen.svg?style=flat-square)
![Version](https://img.shields.io/badge/Version-V4.1-red.svg?style=flat-square)
![License](https://img.shields.io/badge/License-MIT-purple.svg?style=flat-square)

**专为 VPS 极客玩家打造的「全域管理与容灾备份」航母级一键脚本。**<br>
告别繁琐的命令行，一键接管系统调优、节点维稳、安全防盗与跨机搬家。

[作者博客](https://222382.xyz) • [报告 Bug](https://github.com/pwenxiang51-wq/Velox/issues)

</div>

---

## 🔥 核心杀手锏 (Why Velox?)

与市面上普通的监控脚本不同，Velox 深入 Linux 底层，为你提供真正的极客级掌控力：

* **🚨 SSH 隐身防盗门与 TG 报警阵列**
  内置高阶底层安全审计，一键深挖近 24 小时黑客爆破日志（智能兼容 `journalctl` 与 `auth.log`）。支持一键剔除在线非法用户、拉黑 IP、发送死神恶搞警告。搭配物理网卡级绕过 WARP 的 Telegram 开机/防盗秒报系统。
* **🧳 全域资产一键打包与跨机无缝搬家**
  买新机器了？只需 1 分钟！Velox 会高强度压缩你的节点配置、面板数据、Acme 证书、甚至自定义网盘/Docker 目录。自动生成兼容 Windows / Mac 的终端克隆长指令，新机器一键粘贴，满血复活（完美保留源文件绝对路径）。
* **🌐 代理网络高阶排雷与底层调优**
  内置 ping0 与备用数据库双轨 IP 纯净度检测，直观展示“原生/机房/风险”属性。支持 TCP 读写窗口底层暴力扩容、BBR 一键接管、Argo 隧道与 WARP 出站状态智能探活与修复。
* **📡 节点资产雷达提取**
  全盘正则自动扫描机器内隐藏的各种 VLESS / VMess / Hy2 / AnyTLS 节点，一键生成聚合 Base64 订阅链接与终端独立二维码，方便客户端秒扫接入。

---

## 🧰 全景功能矩阵 (27项全能)

<details>
<summary><b>✨ 点击展开查看完整的 27 项功能清单</b></summary>

### [ 板块一：🛡️ 系统核心运维 ]
1. 📊 查看系统基础信息
2. 💾 查看磁盘空间占用
3. ⏱️ 查看运行时间与负载
4. 📊 快速查看内存报告 (静态快照)
5. 📈 实时监控 CPU 与内存 (按 q 退出)
6. 🔌 查看系统监听端口

### [ 板块二：🚀 网络高阶调优 ]
7. 📦 查看代理服务运行状态 (多核心深度体检)
8. 🌐 查看 WARP 与 Argo 出站详情 (专属提取)
9. 🚀 深度验证与管理 BBR 暴力加速
10. 🧹 一键清理系统垃圾与部署 Fail2ban 防盗门
11. 🔄 重启 VPS 主机 (整机物理重启)

### [ 板块三：🔌 代理核心管理 ]
12. 🎬 流媒体解锁检测 (Netflix/ChatGPT等)
13. 🛡️ IP 纯净度与欺诈风险体检 (精准排雷)
14. ⚡ TCP 网络底层高阶调优 (极限压榨带宽)
15. 🛰️ 全球主流节点 Ping 延迟测速
16. 🚨 设置/管理 SSH 异地登录 Telegram 报警 (含开机秒报)

### [ 板块四：🛠️ 自动化与高阶工具 ]
17. 📈 查看本机网卡流量统计 (精准计算，防超标)
18. 💽 自定义管理虚拟内存 Swap (1G 小鸡救星)
19. 📝 修改服务器主机名 (VPS 轻松改名)
20. 🔄 一键更新系统软件库 (智能适配全平台包管理器)
21. 🚨 SSH 隐身防盗门与安全审计中心 (抓外鬼/改端口/一键部署公钥)
22. 🚀 召唤甬哥全家桶 (Sing-box / X-UI 启停维稳中心)

### [ 板块五：⚡ 核心修复与配置提取 ]
23. ⏱️ 设置系统定时任务 (自动重启 / 自动刷新 WARP IP)
24. 🔄 一键修复/无痛重启所有代理服务 (解决断流假死)
25. 🔗 一键提取节点链接与二维码 (Base64 聚合编码版)
26. 🔐 Acme 域名证书深度管理 (查询到期 / 强制续签联动)
27. 🧳 全域资产一键打包与跨机搬家 (终极克隆方案)

</details>

---

## 💻 兼容性说明

本脚本高度依赖 `systemd` 作为底层守护支持，并已针对多种包管理器 (`apt`, `yum`, `dnf`) 进行智能适配。

- **🟢 完美兼容**：Debian 11/12, Ubuntu 20.04/22.04/24.04
- **🟡 高度兼容**：CentOS 7/8, AlmaLinux, Rocky Linux
- **🔴 不支持**：Alpine Linux (无 Systemd 环境)

---

## 🚀 极速部署 (一键安装)

请在你的 VPS 终端（推荐使用 root 用户）执行以下命令：  

```bash
bash <(curl -sL https://sink.222382.xyz/kggwmy)
```

💡 使用说明：

首次安装：复制上方代码块在 VPS 终端运行，系统会自动安装所需组件并弹出 UI 面板。

日常召唤：部署成功后，以后无论何时登录 VPS，只需在命令行输入 velox 并按回车，即可瞬间唤醒本面板！

☕ 赞赏与支持
开源不易，如果 Velox 面板让你的折腾之旅变得更加优雅，为你节省了宝贵的时间，请务必在右上角给我点一个 Star ⭐️ ！你的点赞是我持续维护的唯一动力。

如果大佬觉得项目超赞，欢迎通过微信扫码请我喝杯冰美式，感激不尽！🚀

<div align="center">
<img src="coffee.jpg" alt="Velox 赞赏码" width="300" style="border-radius: 10px; box-shadow: 0 4px 8px rgba(0,00,0,0.1);" />



<i>为极致的折腾干杯！</i>
</div>

<p align="center">Made with ❤️ by <a href="https://github.com/pwenxiang51-wq">pwenxiang51-wq</a></p>
