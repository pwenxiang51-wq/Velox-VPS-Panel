#!/bin/bash
# 自动生成并运行 Velox 面板 (自愈修复版)

cat << 'EOF' > /usr/local/bin/velox
#!/bin/bash
while true; do
    clear
    echo "====================================================="
    echo "            🚀 Velox 专属 VPS 管理面板 🚀            "
    echo "====================================================="
    echo "  1. 📊 查看系统基础信息"
    echo "  2. 💾 查看磁盘空间占用"
    echo "  3. ⏱️  查看运行时间与负载"
    echo "  4. 📈 实时监控 CPU 与内存 (按 q 退出)"
    echo "  5. 🌐 查看当前公网 IP"
    echo "  6. 🔌 查看系统监听端口"
    echo "  7. 📦 查看 Sing-box 运行状态"
    echo "  8. ☁️  查看 WARP 与 Argo 状态 (含一键修复)"
    echo "  9. 🚀 深度验证 BBR 加速状态"
    echo "  10. 🧹 一键清理系统垃圾"
    echo "  11. 🔄 重启服务器"
    echo "  ---------------------------------------------------"
    echo "  12. 🎬 运行流媒体解锁测试 (第三方)"
    echo "  13. 📊 快速查看内存报告 (静态)"
    echo "  ---------------------------------------------------"
    echo "  U. 🗑️  一键卸载本面板 (清理无痕)"
    echo "  0. ❌ 退出面板"
    echo "====================================================="
    read -p "请选择操作: " choice
    case $choice in
        1) echo -e "\n--- 系统信息 ---"; hostnamectl; lsb_release -a 2>/dev/null ;;
        2) echo -e "\n--- 磁盘空间 ---"; df -h ;;
        3) echo -e "\n--- 运行状态 ---"; uptime ;;
        4) echo -e "\n--- 正在启动任务管理器 ---"; sleep 1; top ;;
        5) echo -e "\n--- 公网 IP ---"; curl -s ifconfig.me; echo "" ;;
        6) echo -e "\n--- 监听端口 ---"; ss -tuln ;;
        7) echo -e "\n--- Sing-box ---"; systemctl status sing-box --no-pager | grep -E "Active|Loaded" ;;
        8) 
            echo -e "\n--- 🌐 WARP 解锁状态 ---"
            curl -s https://www.cloudflare.com/cdn-cgi/trace | grep -E "warp=|ip="
            echo -e "\n--- 🚇 Argo 隧道进程检测 ---"
            ps aux | grep -i "cloudflared" | grep -v "grep" || echo -e "\033[31m[ 警告 ] 未发现 Argo 隧道进程运行！\033[0m"
            echo -e "\n---------------------------------------------------"
            read -p "如果发现状态异常，是否尝试强制重启 Argo 隧道？(y/n): " fix_it
            if [[ "$fix_it" == "y" ]]; then
                echo "正在尝试重启隧道服务..."
                systemctl restart cloudflared && echo -e "\033[32m重启指令已发送，请稍后重新按 8 查看！\033[0m"
            fi
            ;;
        9) 
            echo -e "\n--- 🚀 BBR 状态诊断 ---"
            sysctl net.ipv4.tcp_congestion_control
            lsmod | grep bbr && echo -e "\033[32mBBR 模块正运行在系统底层\033[0m"
            ;;
       10) 
            echo -e "\n--- 🧹 正在执行系统安全清理 ---"
            
            # 1. 查明细再清理 APT 缓存
            apt_before=$(du -sh /var/cache/apt/archives 2>/dev/null | cut -f1)
            echo -n "正在清理软件安装包缓存... "
            sudo apt-get clean -y
            sudo apt-get autoremove -y > /dev/null 2>&1
            echo -e "[\033[32m已完成\033[0m] (清理前占用: \033[33m${apt_before:-0B}\033[0m)"

            # 2. 清理日志，并强制显示释放了多少空间
            echo "正在清理 3 天前的系统过期日志："
            sudo journalctl --vacuum-time=3d
            
            echo -e "\n✅ \033[32m系统垃圾清理与汇报完毕！\033[0m"

            # --- 下面是保留的 Fail2ban 防护逻辑，一字没动 ---
            echo -e "\n--- 🛡️ SSH 安全防护状态 (Fail2ban) ---"
            if command -v fail2ban-client &> /dev/null; then
                echo -e "\033[32m✅ 防护已开启！\033[0m 当前防护详情："
                fail2ban-client status sshd | grep -E "Currently|Total"
            else
                echo -e "\033[31m⚠️  检测到本机未安装 Fail2ban 防护\033[0m"
                read -p "是否立即一键安装并开启 SSH 防破译保护？(y/n): " install_f2b
                if [[ "$install_f2b" == "y" ]]; then
                    echo "正在安装防护插件，请稍候..."
                    sudo apt-get update && sudo apt-get install fail2ban -y
                    sudo systemctl enable fail2ban && sudo systemctl start fail2ban
                    echo -e "✅ \033[32m安装成功！你的 VPS 现在自带防盗门了。\033[0m"
                fi
            fi
            ;;
        11) read -p "⚠️ 确定要重启服务器吗？(y/n): " c; [[ "$c" == "y" ]] && sudo reboot ;;
        12) echo -e "\n--- 开始流媒体解锁测试 ---"; bash <(curl -L -s media.ispvps.com) ;;
        13) echo -e "\n--- 📊 静态内存报告 ---"; free -h --si ;;
       U|u) 
             read -p "⚠️ 确定卸载本面板吗？(y/n): " c
             if [[ "$c" == "y" ]]; then 
                 # 1. 先删面板本体
                 rm -f /usr/local/bin/velox
                 echo -e "\n✅ 面板本体已卸载！"
                 
                 # 2. 询问是否连带强拆防盗门 (Fail2ban)
                 if command -v fail2ban-client &> /dev/null; then
                     echo -e "\n检测到系统当前安装了 SSH 防护 (Fail2ban)。"
                     read -p "是否一并【彻底强拆】防盗门？(y/n): " remove_f2b
                     if [[ "$remove_f2b" == "y" ]]; then
                         echo "正在拆除防盗门并清理残留..."
                         sudo apt-get remove --purge fail2ban -y > /dev/null 2>&1
                         sudo apt-get autoremove -y > /dev/null 2>&1
                         echo -e "✅ \033[32m防盗门已彻底拆除！\033[0m"
                     else
                         echo -e "💡 好的，防盗门已为你保留，继续在后台默默看家。"
                     fi
                 fi
                 
                 echo -e "\n江湖再见！"
                 exit
             fi 
             ;;
        0) echo -e "\n祝玩机愉快！\n"; exit ;;
        *) echo -e "\n❌ 输入错误！" ;;
    esac
    echo ""; read -p "按回车键继续..."
done
EOF
chmod +x /usr/local/bin/velox
echo "✅ Velox 面板已更新为【强制自愈版】！"
velox
