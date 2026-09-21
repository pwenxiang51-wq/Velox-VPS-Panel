# 🛰️ VeloX VPS Panel v6.2.8

[![OS](https://img.shields.io/badge/OS-Ubuntu%20%7C%20Debian-orange.svg)]()
[![Language](https://img.shields.io/badge/Language-Pure%20Bash-blue.svg)]()
[![Security](https://img.shields.io/badge/Security-Idiot--Proof-red.svg)]()

> 一款基于纯 Bash 编写的轻量级 VPS 运维与调度面板。
> 坚持零内存常驻与模块化解耦，将复杂的高阶网络调优与系统防御，收束为极简的终端交互体验。大道至简，克制且高效。

---

## ⚙️ 核心功能矩阵

* **🛡️ 系统与网络调优**
  提供独立的模块化 BBR 拥塞控制配置（卸载不留痕）；安全的 PageCache 与系统日志碎片清理机制；内置 NextTrace 路由追踪工具进行出站测速。
* **🔌 代理环境调度**
  支持 TCP/UDP 读写队列底层扩容；集成流媒体解锁检测；提供 SSH 异地登录的 TG 毫秒级预警及开机自愈服务。
* **🚨 轻量化流量与防御**
  基于 `vnstat` 构建低资源开销的流量探针，支持自定义双向流量阈值熔断与报警；支持一键部署轻量级 Bash 脚本机枪塔或 Fail2Ban，防止 SSH 暴力破解。
* **📡 资产管理与无损克隆**
  3 秒快速扫描系统核心监听端口与大体积文件；支持“交互式点餐”打包核心资产，锁定绝对路径与内核级权限，实现跨 VPS 环境的无损快速恢复。

---

## 🔐 交互与安全过滤

面板内置严格的输入校验机制（Idiot-Proof），避免因误操作导致的系统配置文件损坏：
* **边界校验**：端口设置、定时任务等交互强制进行范围与合法字符正则检测，非法输入自动阻断。
* **公钥嗅探**：免密配置时自动校验 `ssh-rsa` / `ssh-ed25519` 等标准公钥前缀，拒收格式错误的文本。
* **活体验证**：Telegram Token 配置时强行向官方接口发包测试，收到 `"ok":true` 才允许写入全局环境。

---

## 📥 快速安装

在纯净的 **Ubuntu / Debian** 系统终端中，执行以下指令即可一键安装：

```bash
bash <(curl -sL [https://raw.githubusercontent.com/pwenxiang51-wq/Velox-VPS-Panel/refs/heads/main/install.sh](https://raw.githubusercontent.com/pwenxiang51-wq/Velox-VPS-Panel/refs/heads/main/install.sh))
```
> 💡 提示：安装完成后，随时在终端输入 `velox` 即可唤醒面板。

---

## 💥 纯净卸载

当您不再需要本面板时，在主菜单按下 `U` 键即可触发纯净卸载程序。
系统将自动清理面板本体、防御脚本、定时任务及环境变量。**卸载过程仅移除 VeloX 产生的相关文件，绝不触碰您原有的业务数据与私有配置。**

---

## 👨‍💻 作者与支持
* **GitHub**: [github.com/pwenxiang51-wq](https://github.com/pwenxiang51-wq)
* **Blog**: [222382.xyz](https://222382.xyz)
* **Telegram**: [@Velox95](https://t.me/Velox95)
