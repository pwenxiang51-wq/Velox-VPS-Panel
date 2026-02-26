#!/bin/bash
# 自动生成并运行 Velox 面板 (V4.1 作者专属版 - 智能系统嗅探 + TG徽章)

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

    # TG 报警状态检测
    if [ -f "/etc/profile.d/ssh_tg_alert.sh" ]; then
        tg_stat=$(echo -e "${green}[已部署]${plain}")
    else
        tg_stat=$(echo -e "${yellow}[未设置]${plain}")
    fi

    clear
    # ================= 专属署名区 =================
    echo -e "${cyan}=====================================================${plain}"
    echo -e "         🚀 ${green}Velox 专属 VPS 管理面板 (全能满血版)${plain} 🚀     "
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
    echo -e "  ${yellow}16.${plain} 🚨 ${red}设置/管理 SSH 异地登录 TG 报警 ${tg_stat}${plain}"
    echo -e "${cyan}  ---------------------------------------------------${plain}"
    echo -e "  ${yellow}17.${plain} 📈 ${purple}查看本机网卡流量统计 (防流量超标)${plain}"
    echo -e "  ${yellow}18.${plain} 💽 ${purple}自定义管理虚拟内存 Swap (1G小鸡救星)${plain}"
    echo -e "  ${yellow}19.${plain} 📝 ${purple}修改服务器主机名 (给 VPS 轻松改名)${plain}"
    echo -e "  ${yellow}20.${plain} 🔄 ${purple}一键更新系统软件库 (智能适配全系统)${plain}"
    echo -e "  ${yellow}21.${plain} 🕵️ ${purple}查看当前在线 SSH 用户 (抓内鬼排查)${plain}"
    echo -e "  ${yellow}22.${plain} 🚀 ${purple}召唤甬哥全家桶 (Sing-box 终端版 / X-UI 网页版)${plain}"
    echo -e "${cyan}  ---------------------------------------------------${plain}"
    echo -e "  ${red}U.${plain}  🗑️  ${red}一键卸载本面板 (清理无痕)${plain}"
    echo -e "  ${red}0.${plain}  ❌ ${red}退出面板${plain}"
    echo -e "${cyan}=====================================================${plain}"
    
    echo -ne "请选择操作 [${yellow}1-21${plain}]: "
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
                echo -e "${cyan}---------------------------------------------------${plain}"
                read -p "是否需要【彻底关闭并卸载】BBR 加速？(y/n): " remove_bbr
                if [[ "$remove_bbr" == "y" ]]; then
                    echo "正在执行 BBR 卸载程序..."
                    sudo sysctl -w net.ipv4.tcp_congestion_control=cubic > /dev/null 2>&1
                    sudo sed -i '/net.core.default_qdisc/d' /etc/sysctl.conf
                    sudo sed -i '/net.ipv4.tcp_congestion_control=bbr/d' /etc/sysctl.conf
                    sudo sysctl -p > /dev/null 2>&1
                    echo -e "${green}✅ BBR 已彻底关闭并恢复为系统默认算法 (cubic)！${plain}"
                fi
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
                    echo "正在刷新系统软件源并安装防护插件，请稍候..."
                    # 兼容不同系统安装 Fail2ban
                    if command -v apt-get &> /dev/null; then
                        sudo apt-get update --fix-missing -y > /dev/null 2>&1
                        sudo apt-get install fail2ban -y
                    elif command -v dnf &> /dev/null; then
                        sudo dnf install epel-release -y && sudo dnf install fail2ban -y
                    elif command -v yum &> /dev/null; then
                        sudo yum install epel-release -y && sudo yum install fail2ban -y
                    fi
                    
                    if command -v fail2ban-client &> /dev/null; then
                        sudo systemctl enable fail2ban && sudo systemctl start fail2ban
                        echo -e "✅ ${green}安装成功！你的 VPS 现在自带防盗门了。${plain}"
                    else
                        echo -e "❌ ${red}安装失败！可能是网络抽风或系统不支持。${plain}"
                    fi
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
            echo -e "\n${blue}--- 🚨 设置/管理 SSH 登录 Telegram 报警 ---${plain}"
            if [ -f "/etc/profile.d/ssh_tg_alert.sh" ]; then
                echo -e "${green}✅ 检测到当前已开启 TG 报警防线！${plain}"
                read -p "请选择操作 (r:重新配置 / d:彻底卸载删除 / n:取消): " tg_choice
                if [[ "$tg_choice" == "d" ]]; then
                    sudo rm -f /etc/profile.d/ssh_tg_alert.sh
                    echo -e "${green}✅ TG 报警防线已彻底卸载！您可以回到主菜单查看状态已变为 [未设置]。${plain}"
                elif [[ "$tg_choice" == "r" ]]; then
                    echo -e "\n💡 准备重新配置，Token 仅保存在本机，绝对安全！"
                    read -p "请输入新的 TG Bot Token: " tg_token
                    read -p "请输入新的 TG Chat ID: " tg_chatid
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
                        echo -e "\n${green}✅ TG 报警防线重新部署成功！${plain}"
                    else
                        echo -e "\n${red}❌ 输入不完整，已取消重新设置，您的旧配置仍保留生效。${plain}"
                    fi
                else
                    echo -e "${cyan}操作已取消。${plain}"
                fi
            else
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
                    echo -e "\n${green}✅ TG 报警防线部署成功！主菜单已点亮 [已部署] 徽章！${plain}"
                else
                    echo -e "\n${red}❌ 输入不完整，已取消设置。${plain}"
                fi
            fi
            ;;
        17)
            echo -e "\n${blue}--- 📈 网卡流量统计 (开机至今) ---${plain}"
            ip -s link | awk '/^[0-9]+:/ { iface=$2 } /RX:/ { getline; rx=$1 } /TX:/ { getline; tx=$1; printf "网卡 %s\n  ⬇️ 下载: %.2f MB\n  ⬆️ 上传: %.2f MB\n", iface, rx/1048576, tx/1048576 }'
            ;;
        18)
            echo -e "\n${blue}--- 💽 自定义虚拟内存 (Swap) 管理 ---${plain}"
            current_swap=$(free -m | grep Swap | awk '{print $2}')
            if [ "$current_swap" -gt "0" ]; then
                echo -e "${green}✅ 检测到当前已开启 ${current_swap} MB 虚拟内存。${plain}"
                read -p "是否需要【彻底关闭并删除】现有的虚拟内存？(y/n): " del_swap
                if [[ "$del_swap" == "y" ]]; then
                    sudo swapoff -a
                    sudo rm -f /swapfile
                    sudo sed -i '/swapfile/d' /etc/fstab
                    echo -e "${green}✅ 虚拟内存已彻底清空卸载！${plain}"
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
        19)
            echo -e "\n${blue}--- 📝 修改服务器主机名 (VPS 改名) ---${plain}"
            echo -e "当前主机名: ${yellow}$(hostname)${plain}"
            read -p "请输入新的主机名 (建议英文或数字，如 GCP-VeloX): " new_hostname
            if [[ -n "$new_hostname" ]]; then
                sudo hostnamectl set-hostname "$new_hostname"
                echo -e "${green}✅ 主机名已成功修改为: $new_hostname ${plain}"
                echo -e "💡 提示：按 12 重启服务器，或重新连接 SSH 终端后即可看到全新名称！"
            else
                echo -e "${red}❌ 输入为空，已取消修改。${plain}"
            fi
            ;;
        20)
            echo -e "\n${blue}--- 🔄 一键更新系统软件库 ---${plain}"
            echo "正在智能识别系统环境，并拉取最新安全补丁，请耐心等待..."
            if command -v apt-get &> /dev/null; then
                sudo apt-get update -y
                sudo DEBIAN_FRONTEND=noninteractive apt-get upgrade -y
            elif command -v dnf &> /dev/null; then
                sudo dnf check-update
                sudo dnf upgrade -y
            elif command -v yum &> /dev/null; then
                sudo yum check-update
                sudo yum upgrade -y
            else
                echo -e "${red}❌ 未知系统包管理器，无法自动更新！${plain}"
                break
            fi
            echo -e "\n${green}✅ 系统底层库及组件已全部更新至最新状态！机器状态满血！${plain}"
            ;;
       21)
            echo -e "\n${blue}--- 🕵️ 查看当前在线 SSH 用户 ---${plain}"
            echo "以下是目前正连接在您这台服务器上的所有终端会话: "
            echo -e "${cyan}---------------------------------------------------${plain}"
            w
            echo -e "${cyan}---------------------------------------------------${plain}"
            echo -e " 💡 如果您发现了除了您自己之外的陌生 IP 正在登录，请立刻拉响警报！ "
            echo -e "${cyan}---------------------------------------------------${plain}"
            read -p "请输入要制裁的终端号 (例如 pts/1，直接回车取消): " target_pts
            
            if [[ -n "$target_pts" ]]; then
                # 校验终端是否存在
                if w | grep -q "$target_pts"; then
                    # 抓取对方真实 IP
                    target_ip=$(w | grep "$target_pts" | awk '{print $3}')
                    echo -e "\n${yellow}🎯 已锁定目标: 终端 [$target_pts] | 来源 IP: [$target_ip]${plain}"
                    echo -e "  ${cyan}1.${plain} 🥾 强行踢出 (物理拔插头)"
                    echo -e "  ${cyan}2.${plain} 🧱 永久拉黑 (封禁IP + 踢出)"
                    echo -e "  ${cyan}3.${plain} 👻 极客恶搞 (发送恐怖警告并踢出)"
                    read -p "请为该内鬼选择制裁套餐 [1-3]: " punish_choice
                    
                    case $punish_choice in
                        1)
                            sudo skill -9 "$target_pts"
                            echo -e "${green}✅ 已将其一脚踹下线！${plain}"
                            ;;
                        2)
                            # 尝试用 fail2ban 封禁，如果没装就用 iptables 备用方案
                            if command -v fail2ban-client &> /dev/null; then
                                sudo fail2ban-client set sshd banip "$target_ip" >/dev/null 2>&1
                            else
                                sudo iptables -A INPUT -s "$target_ip" -j DROP
                            fi
                            sudo skill -9 "$target_pts"
                            echo -e "${green}✅ 关门打狗！IP [$target_ip] 已被永久拉黑，且已被踢出！${plain}"
                            ;;
                        3)
                            echo -e "\n${purple}😈 正在向对方屏幕发送“死神警告”，准备欣赏对方的恐惧...${plain}"
                            # 强行向对方的显示器输出红色恐吓文字
                            sudo bash -c "echo -e '\n\n\033[1;31m[FATAL WARNING] UNAUTHORIZED ACCESS DETECTED.\033[0m' > /dev/$target_pts"
                            sudo bash -c "echo -e '\033[1;31m[SYSTEM] YOUR REAL IP [$target_ip] HAS BEEN LOGGED AND REPORTED TO FBI CYBER DIVISION.\033[0m' > /dev/$target_pts"
                            sudo bash -c "echo -e '\033[1;31m[SYSTEM] INITIATING COUNTER-HACK SEQUENCE IN 3...\033[0m' > /dev/$target_pts"
                            sleep 1
                            sudo bash -c "echo -e '\033[1;31m2...\033[0m' > /dev/$target_pts"
                            sleep 1
                            sudo bash -c "echo -e '\033[1;31m1...\033[0m' > /dev/$target_pts"
                            sleep 1
                            sudo bash -c "echo -e '\033[1;31mGOODBYE.\033[0m\n\n' > /dev/$target_pts"
                            sudo skill -9 "$target_pts"
                            echo -e "${green}✅ 恶搞完毕！对方看着满屏飘红的警告被强制断开，估计正在连夜扛着主机跑路！${plain}"
                            ;;
                        *)
                            echo -e "${red}取消制裁。${plain}"
                            ;;
                    esac
                else
                    echo -e "${red}⚠️ 找不到指定的终端号 $target_pts，请重新按 21 核对！${plain}"
                fi
            fi
            ;;
        22)
            echo -e "\n${blue}======================================================${plain}"
            echo -e "${yellow}      🚀 欢迎进入甬哥专业脚本调用中心 🚀${plain}"
            echo -e "${blue}======================================================${plain}"
            echo -e "  ${cyan}1.${plain} 📦 调用 【Sing-box 精装桶】 (终端黑框命令行版)"
            echo -e "  ${cyan}2.${plain} 🖥️  调用 【X-UI 面板】 (带网页后台的多用户版)"
            echo -e "  ${cyan}0.${plain} ↩️  取消操作并返回上一级菜单"
            echo -e "${blue}------------------------------------------------------${plain}"
            read -p "👉 请输入对应数字并回车 [0-2]: " yg_choice
            
            case $yg_choice in
                1)
                    echo -e "\n${green}▶ 正在启动 Sing-box 脚本，请稍候...${plain}"
                    sleep 1
                    # 调用的就是你截图里的终端一键脚本
                    bash <(curl -Ls https://raw.githubusercontent.com/yonggekkk/sing-box-yg/main/sb.sh)
                    ;;
                2)
                    echo -e "\n${green}▶ 正在启动 X-UI 脚本，请稍候...${plain}"
                    sleep 1
                    # 调用的就是你截图里带网页可视化的安装脚本
                    bash <(curl -Ls https://raw.githubusercontent.com/yonggekkk/x-ui-yg/main/install.sh)
                    ;;
                0)
                    echo -e "\n${green}✅ 已取消操作，安全返回主菜单。${plain}"
                    ;;
                *)
                    # 万一手滑按成了别的数字或字母
                    echo -e "\n${red}❌ 错误：无效的选项，操作取消。${plain}"
                    ;;
            esac
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
                         if command -v apt-get &> /dev/null; then
                             sudo apt-get remove --purge fail2ban -y > /dev/null 2>&1
                             sudo apt-get autoremove -y > /dev/null 2>&1
                         elif command -v yum &> /dev/null; then
                             sudo yum remove fail2ban -y > /dev/null 2>&1
                         fi
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
echo -e "\033[1;32m✅ Velox V4.1 (智能UI细节修缮版) 部署完毕！请输入 velox 欣赏！\033[0m"
velox
