#!/bin/bash
# 自动生成并运行 Velox 面板 (V3.1 作者专属版 - 修复测速引擎)

cat << 'EOF' > /usr/local/bin/velox
#!/bin/bash
# 定义内部颜色变量
blue='\033[1;34m'
green='\033[1;32m'
yellow='\033[1;33m'
cyan='\033[1;36m'
red='\033[1;31m'
purple='\033[1;35m'
plain='\033[0m'

while true; do
    # === 核心服务动态状态检测 ===
    if systemctl list-unit-files | grep -q "sing-box.service"; then
        sb_stat=$(systemctl is-active --quiet sing-box && echo -e "${green}[运行中]${plain}" || echo -e "${red}[已停止]${plain}")
    else
        sb_stat=$(echo -e "${yellow}[未安装]${plain}")
    fi

    bbr_stat=$(sysctl net.ipv4.tcp_congestion_control 2>/dev/null | grep -q bbr && echo -e "${green}[加速中]${plain}" || echo -e "${yellow}[未生效]${plain}")

    if command -v fail2ban-client &> /dev/null; then
        f2b_stat=$(systemctl is-active --quiet fail2ban && echo -e "${green}[守护中]${plain}" || echo -e "${red}[已停止]${plain}")
    else
        f2b_stat=$(echo -e "${yellow}[未安装]${plain}")
    fi

    clear
    # ================= 专属署名区 =================
    echo -e "${cyan}=====================================================${plain}"
    echo -e "         🚀 ${green}Velox 专属 VPS 管理面板 (Ultra 满血版)${plain} 🚀     "
    echo -e "${cyan}=====================================================${plain}"
    echo -e "作者GitHub项目 : ${blue}github.com/pwenxiang51-wq${plain}"
    echo -e "作者Velo.x博客 : ${blue}222382.xyz${plain}"
    echo -e "${cyan}=====================================================${plain}"
    # ==============================================
    echo -e "  ${yellow}1.${plain}  📊 ${green}查看系统基础信息${plain}"
    echo -e "  ${yellow}2.${plain}  💾 ${green}查看磁盘空间占用${plain}"
    echo -e "  ${yellow}3.${plain}  ⏱️  ${green}查看运行时间与负载${plain}"
    echo -e "  ${yellow}4.${plain}  📊 ${green}快速查看内存报告 (静态快照)${plain}"
    echo -e "  ${yellow}5.${plain}  📈 ${green}实时监控 CPU 与内存 (按 q 退出)${plain}"
    echo -e "  ${yellow}6.${plain}  🌐 ${green}查看当前公网 IP${plain}"
    echo -e "  ${yellow}7.${plain}  🔌 ${green}查看系统监听端口${plain}"
    echo -e "  ${yellow}8.${plain}  📦 ${green}查看 Sing-box 运行状态 ${sb_stat}${plain}"
    echo -e "  ${yellow}9.${plain}  ☁️  ${cyan}查看 WARP 与 Argo 状态 (含一键修复)${plain}"
    echo -e "  ${yellow}10.${plain} 🚀 ${cyan}深度验证与管理 BBR 加速 ${bbr_stat}${plain}"
    echo -e "  ${yellow}11.${plain} 🧹 ${yellow}一键清理系统垃圾与防盗门 ${f2b_stat}${plain}"
    echo -e "  ${yellow}12.${plain} 🔄 ${green}重启服务器${plain}"
    echo -e "${cyan}  ---------------------------------------------------${plain}"
    echo -e "  ${yellow}13.${plain} 🎬 ${blue}流媒体解锁检测 (Netflix/ChatGPT等)${plain}"
    echo -e "  ${yellow}14.${plain} ⚡ ${blue}TCP 网络底层高阶调优 (极限压榨带宽)${plain}"
    echo -e "  ${yellow}15.${plain} 🛰️ ${blue}全球主流节点 Ping 延迟测速${plain}"
    echo -e "  ${yellow}16.${plain} 🚨 ${red}设置 SSH 异地登录 TG 机器人报警${plain}"
    echo -e "${cyan}  ---------------------------------------------------${plain}"
    echo -e "  ${yellow}17.${plain} 📈 ${purple}查看本机网卡流量统计 (防流量超标)${plain}"
    echo -e "  ${yellow}18.${plain} 🏎️ ${purple}顶级三网测速 (Hyperspeed 极速测速引擎)${plain}"
    echo -e "  ${yellow}19.${plain} 💽 ${purple}自定义管理虚拟内存 Swap (防爆内存)${plain}"
    echo -e "${cyan}  ---------------------------------------------------${plain}"
    echo -e "  ${red}U.${plain}  🗑️  ${red}一键卸载本面板 (清理无痕)${plain}"
    echo -e "  ${red}0.${plain}  ❌ ${red}退出面板${plain}"
    echo -e "${cyan}=====================================================${plain}"
    
    echo -ne "请选择操作 [${yellow}1-19${plain}]: "
    read choice
    
    case $choice in
        1) echo -e "\n${blue}--- 系统信息 ---${plain}"; hostnamectl; lsb_release -a 2>/dev/null ;;
        2) echo -e "\n${blue}--- 磁盘空间 ---${plain}"; df -h ;;
        3) echo -e "\n${blue}--- 运行状态 ---${plain}"; uptime ;;
        4) echo -e "\n${blue}--- 📊 静态内存报告 ---${plain}"; free -h --si ;;
        5) echo -e "\n${cyan}--- 正在启动任务管理器 ---${plain}"; sleep 1; top ;;
        6) echo -e "\n${blue}--- 公网 IP ---${plain}"; curl -s ifconfig.me; echo "" ;;
        7) echo -e "\n${blue}--- 监听端口 ---${plain}"; ss -tuln ;;
        8) echo -e "\n${blue}--- Sing-box 状态 ---${plain}"; systemctl status sing-box --no-pager | grep -E "Active|Loaded" ;;
        9) 
            echo -e "\n${blue}--- 🌐 WARP 解锁状态 ---${plain}"
            curl -s https://www.cloudflare.com/cdn-cgi/trace | grep -E "warp=|ip="
            echo -e "\n${blue}--- 🚇 Argo 隧道进程检测 ---${plain}"
            ps aux | grep -i "cloudflared" | grep -v "grep" || echo -e "${red}[ 警告 ] 未发现 Argo 隧道进程运行！${plain}"
            echo -e "\n${cyan}---------------------------------------------------${plain}"
            read -p "如果发现状态异常，是否尝试强制重启 Argo 隧道？(y/n): " fix_it
            if [[ "$fix_it" == "y" ]]; then
                echo "正在尝试重启隧道服务..."
                systemctl restart cloudflared && echo -e "${green}重启指令已发送，请稍后重新按 9 查看！${plain}"
            fi
            ;;
        10) 
            echo -e "\n${blue}--- 🚀 BBR 状态诊断与管理 ---${plain}"
            current_cc=$(sysctl net.ipv4.tcp_congestion_control 2>/dev/null | awk '{print $3}')
            echo -e "当前系统正在使用的算法: ${yellow}${current_cc}${plain}"
            
            if [[ "$current_cc" == "bbr" ]]; then
                echo -e "${green}✅ BBR 加速已完美生效，网络正在狂飙！${plain}"
            else
                echo -e "${red}⚠️ 检测到当前未开启 BBR 加速！${plain}"
                read -p "是否立即【一键开启 BBR 暴力加速】？(y/n): " enable_bbr
                if [[ "$enable_bbr" == "y" ]]; then
                    echo "正在向系统内核注入 BBR 参数..."
                    sed -i '/net.core.default_qdisc/d' /etc/sysctl.conf
                    sed -i '/net.ipv4.tcp_congestion_control/d' /etc/sysctl.conf
                    echo "net.core.default_qdisc=fq" >> /etc/sysctl.conf
                    echo "net.ipv4.tcp_congestion_control=bbr" >> /etc/sysctl.conf
                    sysctl -p >/dev/null 2>&1
                    
                    if sysctl net.ipv4.tcp_congestion_control 2>/dev/null | grep -q bbr; then
                        echo -e "\n${green}🎉 开启成功！请按回车键返回主菜单，您将看到徽章已变为 [加速中]！${plain}"
                    else
                        echo -e "\n${red}❌ 开启失败，可能当前系统内核版本过低不支持 BBR。${plain}"
                    fi
                fi
            fi
            ;;
        11) 
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
        12) read -p "⚠️  确定要重启服务器吗？(y/n): " c; [[ "$c" == "y" ]] && sudo reboot ;;
        13) echo -e "\n${blue}--- 开始流媒体解锁测试 ---${plain}"; bash <(curl -L -s media.ispvps.com) ;;
        14) 
            echo -e "\n${blue}--- ⚡ 正在进行 TCP 网络底层调优 ---${plain}"
            sed -i '/net.core.rmem_max/d' /etc/sysctl.conf
            sed -i '/net.core.wmem_max/d' /etc/sysctl.conf
            sed -i '/net.ipv4.tcp_rmem/d' /etc/sysctl.conf
            sed -i '/net.ipv4.tcp_wmem/d' /etc/sysctl.conf
            echo "net.core.rmem_max=16777216" >> /etc/sysctl.conf
            echo "net.core.wmem_max=16777216" >> /etc/sysctl.conf
            echo "net.ipv4.tcp_rmem=4096 87380 16777216" >> /etc/sysctl.conf
            echo "net.ipv4.tcp_wmem=4096 65536 16777216" >> /etc/sysctl.conf
            sysctl -p > /dev/null 2>&1
            echo -e "${green}✅ TCP 读写窗口缓冲区已强行扩展！大文件下载起步将变得更加残暴！${plain}"
            ;;
        15)
            echo -e "\n${blue}--- 🛰️ 正在测试全球主流节点延迟 ---${plain}"
            echo -ne "🇺🇸 Cloudflare: " && ping -c 3 1.1.1.1 | tail -1 | awk -F '/' '{print $5" ms"}' || echo "超时"
            echo -ne "🇺🇸 Google: " && ping -c 3 8.8.8.8 | tail -1 | awk -F '/' '{print $5" ms"}' || echo "超时"
            echo -ne "🇨🇳 百度 (中国大陆): " && ping -c 3 220.181.38.251 | tail -1 | awk -F '/' '{print $5" ms"}' || echo "超时"
            echo -e "\n${green}✅ 测速完成！${plain}"
            ;;
        16)
            echo -e "\n${blue}--- 🚨 设置 SSH 登录 Telegram 报警 ---${plain}"
            echo -e "💡 本脚本开源安全，Token 仅保存在本机，不会上传网络！"
            read -p "请输入你的 TG Bot Token: " tg_token
            read -p "请输入你的 TG Chat ID: " tg_chatid
            if [[ -n "$tg_token" && -n "$tg_chatid" ]]; then
                cat << EOF2 > /etc/profile.d/ssh_tg_alert.sh
#!/bin/bash
USER_IP=\$(echo \$SSH_CLIENT | awk '{print \$1}')
if [ -n "\$USER_IP" ]; then
    MSG="🚨 [神盾局警告] 大佬，你的服务器 \$(hostname) 刚刚被登录了！%0A👉 来源 IP: \$USER_IP%0A⏰ 时间: \$(date +'%Y-%m-%d %H:%M:%S')"
    curl -s -X POST "https://api.telegram.org/bot${tg_token}/sendMessage" -d chat_id="${tg_chatid}" -d text="\$MSG" > /dev/null 2>&1 &
fi
EOF2
                chmod +x /etc/profile.d/ssh_tg_alert.sh
                echo -e "\n${green}✅ TG 报警防线部署成功！下次只要这台机器被连上，你的手机就会立刻震动！${plain}"
            else
                echo -e "\n${red}❌ 输入不完整，已取消设置。${plain}"
            fi
            ;;
        17)
            echo -e "\n${blue}--- 📈 网卡流量统计 (开机至今) ---${plain}"
            ip -s link | awk '/^[0-9]+:/ { iface=$2 } /RX:/ { getline; rx=$1 } /TX:/ { getline; tx=$1; printf "网卡 %s\n  ⬇️ 下载: %.2f MB\n  ⬆️ 上传: %.2f MB\n", iface, rx/1048576, tx/1048576 }'
            ;;
        18)
            echo -e "\n${blue}--- 🏎️ 正在呼叫顶级三网测速引擎 (Hyperspeed) ---${plain}"
            echo -e "💡 即将测试国内多地节点的真实上行与下行带宽，请稍候..."
            bash <(curl -Lso- https://bench.im/hyperspeed)
            ;;
        19)
            echo -e "\n${blue}--- 💽 自定义虚拟内存 (Swap) 管理 ---${plain}"
            current_swap=$(free -m | grep Swap | awk '{print $2}')
            if [ "$current_swap" -gt "0" ]; then
                echo -e "${green}✅ 检测到当前已开启 ${current_swap} MB 虚拟内存。${plain}"
                read -p "是否需要【关闭并删除】现有的虚拟内存？(y/n): " del_swap
                if [[ "$del_swap" == "y" ]]; then
                    sudo swapoff -a
                    sudo rm -f /swapfile
                    sudo sed -i '/swapfile/d' /etc/fstab
                    echo -e "${green}✅ 虚拟内存已清空！${plain}"
                fi
            else
                echo -e "${yellow}⚠️ 当前未开启虚拟内存，小内存机器极易爆内存宕机！${plain}"
                read -p "是否立即创建虚拟内存文件？(y/n): " add_swap
                if [[ "$add_swap" == "y" ]]; then
                    read -p "请输入需要创建的容量大小 (纯数字，单位:GB，例如输入 2 代表 2GB): " swap_size
                    if [[ "$swap_size" =~ ^[0-9]+$ ]]; then
                        echo "正在创建 ${swap_size}GB 虚拟内存，请稍候..."
                        sudo fallocate -l ${swap_size}G /swapfile
                        sudo chmod 600 /swapfile
                        sudo mkswap /swapfile > /dev/null 2>&1
                        sudo swapon /swapfile
                        echo '/swapfile none swap sw 0 0' | sudo tee -a /etc/fstab > /dev/null
                        echo -e "${green}✅ ${swap_size}GB 虚拟内存创建完毕！系统运行更稳定了。${plain}"
                    else
                        echo -e "${red}❌ 输入错误，请输入纯数字！${plain}"
                    fi
                fi
            fi
            ;;
        U|u) 
             echo -e "\n${red}--- ⚠️  卸载操作 ---${plain}"
             read -p "确定卸载本面板吗？(y/n): " c
             if [[ "$c" == "y" ]]; then 
                 rm -f /usr/local/bin/velox
                 rm -f /etc/profile.d/ssh_tg_alert.sh
                 echo -e "${green}✅ 面板本体及报警组件已卸载！${plain}"
                 if command -v fail2ban-client &> /dev/null; then
                     read -p "是否一并【彻底强拆】防盗门？(y/n): " remove_f2b
                     if [[ "$remove_f2b" == "y" ]]; then
                         sudo apt-get remove --purge fail2ban -y > /dev/null 2>&1
                         sudo apt-get autoremove -y > /dev/null 2>&1
                         echo -e "${green}✅ 防盗门已彻底拆除！${plain}"
                     fi
                 fi
                 echo -e "\n江湖再见！"; exit
             fi 
             ;;
        0) echo -e "\n${green}祝作者大佬折腾愉快！${plain}\n"; exit ;;
        *) echo -e "\n${red}❌ 输入错误，请重新输入！${plain}" ;;
    esac
    echo -e "\n${cyan}按回车键继续...${plain}"; read
done
EOF
chmod +x /usr/local/bin/velox
echo -e "\033[1;32m✅ Velox V3.1 (完美测速修复版) 部署完毕！请输入 velox 体验狂飙！\033[0m"
velox
