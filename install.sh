#!/bin/bash
# 自动生成并运行 Velox 面板 (进化顶配版)

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
        4) echo -e "\n--- 正在启动任务管理器 ---"; echo "💡 提示：查看完毕后，请按键盘英文 'q' 键返回菜单！"; sleep 2; top ;;
        5) echo -e "\n--- 公网 IP ---"; curl -s ifconfig.me; echo "" ;;
        6) echo -e "\n--- 监听端口 ---"; ss -tuln ;;
        7) echo -e "\n--- Sing-box ---"; systemctl status sing-box --no-pager | grep -E "Active|Loaded" ;;
        8) 
            echo -e "\n--- WARP 接口测试 ---"
            curl -s https://www.cloudflare.com/cdn-cgi/trace | grep -E "warp=|ip=" || echo "未检测到 Cloudflare 代理特征"
            echo -e "\n--- Argo 进程检测 ---"
            ps aux | grep -i "cloudflared" | grep -v "grep" || { 
                echo -e "\033[31m检测到 Argo 隧道可能断开！\033[0m"
                read -p "是否尝试一键重启隧道？(y/n): " fix_it
                [ "$fix_it" == "y" ] && systemctl restart cloudflared && echo "重启指令已发送。"
            }
            ;;
        9) 
            echo -e "\n--- BBR 状态诊断 ---"
            sysctl net.ipv4.tcp_congestion_control
            lsmod | grep bbr && echo -e "\033[32mBBR 模块正运行在系统底层\033[0m" || echo -e "\033[31m警告：BBR 模块未在运行！\033[0m"
            ;;
        10) echo -e "\n--- 清理垃圾 ---"; sudo apt clean && sudo journalctl --vacuum-time=3d; echo "✅ 清理完成！" ;;
        11) read -p "⚠️ 确定要重启服务器吗？(y/n): " c; [[ "$c" == "y" ]] && sudo reboot ;;
        12) echo -e "\n--- 开始流媒体解锁测试 ---"; bash <(curl -L -s media.ispvps.com) ;;
        13) echo -e "\n--- 📊 静态内存报告 ---"; free -h --si ;;
        U|u) 
             read -p "⚠️ 确定卸载吗？(y/n): " c
             if [[ "$c" == "y" ]]; then 
                 rm -f /usr/local/bin/velox
                 echo -e "\n✅ 卸载成功，江湖再见！"
                 exit
             fi 
             ;;
        0) echo -e "\n祝玩机愉快！\n"; exit ;;
        *) echo -e "\n❌ 输入错误，请重新输入！" ;;
    esac
    echo ""; read -p "按回车键继续..."
done
EOF
chmod +x /usr/local/bin/velox
echo "✅ 面板进化成功！正在启动..."
velox
