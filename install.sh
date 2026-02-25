#!/bin/bash
# 自动生成并运行 Velox 面板 (全彩极客终极版)

cat << 'EOF' > /usr/local/bin/velox
#!/bin/bash
# 定义内部颜色变量
blue='\033[1;34m'
green='\033[1;32m'
yellow='\033[1;33m'
cyan='\033[1;36m'
red='\033[1;31m'
plain='\033[0m'

while true; do
    clear
    echo -e "${cyan}=====================================================${plain}"
    echo -e "            🚀 ${green}Velox 专属 VPS 管理面板${plain} 🚀            "
    echo -e "${cyan}=====================================================${plain}"
    # 这里把 emoji 后面的文字全部加上了颜色！
    echo -e "  ${yellow}1.${plain} 📊 ${green}查看系统基础信息${plain}"
    echo -e "  ${yellow}2.${plain} 💾 ${green}查看磁盘空间占用${plain}"
    echo -e "  ${yellow}3.${plain} ⏱️  ${green}查看运行时间与负载${plain}"
    echo -e "  ${yellow}4.${plain} 📈 ${green}实时监控 CPU 与内存 (按 q 退出)${plain}"
    echo -e "  ${yellow}5.${plain} 🌐 ${green}查看当前公网 IP${plain}"
    echo -e "  ${yellow}6.${plain} 🔌 ${green}查看系统监听端口${plain}"
    echo -e "  ${yellow}7.${plain} 📦 ${green}查看 Sing-box 运行状态${plain}"
    echo -e "  ${yellow}8.${plain} ☁️  ${cyan}查看 WARP 与 Argo 状态 (含一键修复)${plain}"
    echo -e "  ${yellow}9.${plain} 🚀 ${cyan}深度验证 BBR 加速状态${plain}"
    echo -e "  ${yellow}10.${plain} 🧹 ${yellow}一键清理系统垃圾 (含安全防护)${plain}"
    echo -e "  ${yellow}11.${plain} 🔄 ${green}重启服务器${plain}"
    echo -e "${cyan}  ---------------------------------------------------${plain}"
    echo -e "  ${yellow}12.${plain} 🎬 ${blue}运行流媒体解锁测试 (第三方)${plain}"
    echo -e "  ${yellow}13.${plain} 📊 ${blue}快速查看内存报告 (静态)${plain}"
    echo -e "${cyan}  ---------------------------------------------------${plain}"
    echo -e "  ${red}U.${plain} 🗑️  ${red}一键卸载本面板 (清理无痕)${plain}"
    echo -e "  ${red}0.${plain} ❌ ${red}退出面板${plain}"
    echo -e "${cyan}=====================================================${plain}"
    
    # 修复了 read -p 颜色代码暴露的问题
    echo -ne "请选择操作 [${yellow}1-13${plain}]: "
    read choice
    
    case $choice in
        1) echo -e "\n${blue}--- 系统信息 ---${plain}"; hostnamectl; lsb_release -a 2>/dev/null ;;
        2) echo -e "\n${blue}--- 磁盘空间 ---${plain}"; df -h ;;
        3) echo -e "\n${blue}--- 运行状态 ---${plain}"; uptime ;;
        4) echo -e "\n${cyan}--- 正在启动任务管理器 ---${plain}"; sleep 1; top ;;
        5) echo -e "\n${blue}--- 公网 IP ---${plain}"; curl -s ifconfig.me; echo "" ;;
        6) echo -e "\n${blue}--- 监听端口 ---${plain}"; ss -tuln ;;
        7) echo -e "\n${blue}--- Sing-box 状态 ---${plain}"; systemctl status sing-box --no-pager | grep -E "Active|Loaded" ;;
        8) 
            echo -e "\n${blue}--- 🌐 WARP 解锁状态 ---${plain}"
            curl -s https://www.cloudflare.com/cdn-cgi/trace | grep -E "warp=|ip="
            echo -e "\n${blue}--- 🚇 Argo 隧道进程检测 ---${plain}"
            ps aux | grep -i "cloudflared" | grep -v "grep" || echo -e "${red}[ 警告 ] 未发现 Argo 隧道进程运行！${plain}"
            echo -e "\n${cyan}---------------------------------------------------${plain}"
            read -p "如果发现状态异常，是否尝试强制重启 Argo 隧道？(y/n): " fix_it
            if [[ "$fix_it" == "y" ]]; then
                echo "正在尝试重启隧道服务..."
                systemctl restart cloudflared && echo -e "${green}重启指令已发送，请稍后重新按 8 查看！${plain}"
            fi
            ;;
        9) 
            echo -e "\n${blue}--- 🚀 BBR 状态诊断 ---${plain}"
            sysctl net.ipv4.tcp_congestion_control
            lsmod | grep bbr && echo -e "${green}BBR 模块正运行在系统底层，加速生效中！${plain}"
            ;;
        10) 
            echo -e "\n${blue}--- 🧹 正在执行系统安全清理 ---${plain}"
            apt_before=$(du -sh /var/cache/apt/archives 2>/dev/null | cut -f1)
            echo -n "正在清理软件安装包缓存... "
            sudo apt-get clean -y
            sudo apt-get autoremove -y > /dev/null 2>&1
            echo -e "[${green}已完成${plain}] (释放空间: ${yellow}${apt_before:-0B}${plain})"
            echo "正在清理 3 天前的系统过期日志："
            sudo journalctl --vacuum-time=3d
            echo -e "\n✅ ${green}系统垃圾清理与汇报完毕！${plain}"

            echo -e "\n${blue}--- 🛡️ SSH 安全防护状态 (Fail2ban) ---${plain}"
            if command -v fail2ban-client &> /dev/null; then
                echo -e "${green}✅ 防护已开启！${plain} 当前防护详情："
                fail2ban-client status sshd | grep -E --color=always "Currently|Total|([0-9]+)"
            else
                echo -e "${red}⚠️  检测到本机未安装 Fail2ban 防护${plain}"
                read -p "是否立即一键安装并开启 SSH 防破译保护？(y/n): " install_f2b
                if [[ "$install_f2b" == "y" ]]; then
                    echo "正在安装防护插件，请稍候..."
                    sudo apt-get update && sudo apt-get install fail2ban -y
                    sudo systemctl enable fail2ban && sudo systemctl start fail2ban
                    echo -e "✅ ${green}安装成功！你的 VPS 现在自带防盗门了。${plain}"
                fi
            fi
            ;;
        11) read -p "⚠️  确定要重启服务器吗？(y/n): " c; [[ "$c" == "y" ]] && sudo reboot ;;
        12) echo -e "\n${blue}--- 开始流媒体解锁测试 ---${plain}"; bash <(curl -L -s media.ispvps.com) ;;
        13) echo -e "\n${blue}--- 📊 静态内存报告 ---${plain}"; free -h --si ;;
        U|u) 
             echo -e "\n${red}--- ⚠️  卸载操作 ---${plain}"
             read -p "确定卸载本面板吗？(y/n): " c
             if [[ "$c" == "y" ]]; then 
                 rm -f /usr/local/bin/velox
                 echo -e "${green}✅ 面板本体已卸载！${plain}"
                 if command -v fail2ban-client &> /dev/null; then
                     echo -e "\n检测到 SSH 防护 (Fail2ban)。"
                     read -p "是否一并【彻底强拆】防盗门？(y/n): " remove_f2b
                     if [[ "$remove_f2b" == "y" ]]; then
                         echo "正在拆除防盗门..."
                         sudo apt-get remove --purge fail2ban -y > /dev/null 2>&1
                         sudo apt-get autoremove -y > /dev/null 2>&1
                         echo -e "${green}✅ 防盗门已彻底拆除！${plain}"
                     else
                         echo -e "${cyan}💡 防盗门已保留。${plain}"
                     fi
                 fi
                 echo -e "\n江湖再见！"; exit
             fi 
             ;;
        0) echo -e "\n${green}祝玩机愉快！${plain}\n"; exit ;;
        *) echo -e "\n${red}❌ 输入错误，请重新输入！${plain}" ;;
    esac
    # 修复底部回车键乱码
    echo -e "\n${cyan}按回车键继续...${plain}"; read
done
EOF
chmod +x /usr/local/bin/velox
echo -e "\033[1;32m✅ 面板进化成功！请输入 velox 体验全彩极客版！\033[0m"
velox
