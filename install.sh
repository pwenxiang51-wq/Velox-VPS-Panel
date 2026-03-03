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
    if [ -f "/usr/local/bin/ssh_tg_alert.sh" ]; then
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
    echo -e "  ${yellow}6.${plain}  🔌 ${green}查看系统监听端口${plain}"
    echo -e "  ${yellow}7.${plain}  📦 ${green}查看代理服务运行状态 (深度体检与 IP 查询) ${sb_stat}${plain}"
    echo -e "  ${yellow}8.${plain}  🌐  ${cyan}查看 WARP 与 Argo 出站详情 (独立管理中心)${plain}"
    echo -e "  ${yellow}9.${plain} 🚀 ${cyan}深度验证与管理 BBR 加速 ${bbr_stat}${plain}"
    echo -e "  ${yellow}10.${plain} 🧹 ${yellow}一键清理系统垃圾与防盗门 ${f2b_stat}${plain}"
    echo -e "  ${yellow}11.${plain} 🔄  ${green}重启 VPS 主机 (整机物理重启，SSH 会掉线)${plain}"
    echo -e "${cyan}  ---------------------------------------------------${plain}"
    echo -e "  ${yellow}12.${plain} 🎬 ${blue}流媒体解锁检测 (Netflix/ChatGPT等)${plain}"
    echo -e "  ${yellow}13.${plain} ⚡ ${blue}TCP 网络底层高阶调优 (极限压榨带宽)${plain}"
    echo -e "  ${yellow}14.${plain} 🛰️ ${blue}全球主流节点 Ping 延迟测速${plain}"
    echo -e "  ${yellow}15.${plain} 🚨 ${red}设置/管理 SSH 异地登录 TG 报警 (含开机秒报 & 环境深度兼容) ${tg_stat}${plain}"
    echo -e "${cyan}  ---------------------------------------------------${plain}"
    echo -e "  ${yellow}16.${plain} 📈 ${purple}查看本机网卡流量统计 (防流量超标)${plain}"
    echo -e "  ${yellow}17${plain} 💽 ${purple}自定义管理虚拟内存 Swap (1G小鸡救星)${plain}"
    echo -e "  ${yellow}18.${plain} 📝 ${purple}修改服务器主机名 (给 VPS 轻松改名)${plain}"
    echo -e "  ${yellow}19.${plain} 🔄 ${purple}一键更新系统软件库 (智能适配全系统)${plain}"
    echo -e "  ${yellow}20.${plain} 🕵️ ${purple}查看当前在线 SSH 用户 (抓内鬼排查)${plain}"
    echo -e "  ${yellow}21.${plain} 🚀 ${purple}召唤甬哥全家桶 (Sing-box 终端版 / X-UI 网页版)${plain}"
    echo -e "${cyan}  ---------------------------------------------------${plain}"
    echo -e "  ${yellow}22.${plain} ⏱️  ${cyan}设置定时任务 (设定 VPS 半夜自动重启 / 自动刷新 WARP)${plain}"
    echo -e "  ${yellow}23.${plain} 🔄  ${green}一键修复/重启所有代理服务 (解决掉线/假死/断流)${plain}"
    echo -e "  ${yellow}24.${plain} 🔗  ${purple}一键提取节点链接配置 (提取 vless/vmess/hy2)${plain}"
    echo -e "  ${yellow}25.${plain} 🔐  ${blue}Acme 域名证书深度管理 (查询到期 / 强制续签)${plain}"
    echo -e "${cyan}  ---------------------------------------------------${plain}"
    echo -e "  ${red}U.${plain}  🗑️  ${red}一键卸载本面板 (清理无痕)${plain}"
    echo -e "  ${red}0.${plain}  ❌ ${red}退出面板${plain}"
    echo -e "${cyan}=====================================================${plain}"
    
    echo -ne "请选择操作 [${yellow}1-22${plain}]: "
    read choice
    
    case $choice in
        1) echo -e "\n${blue}--- 系统信息 ---${plain}"; hostnamectl; lsb_release -a 2>/dev/null ;;
        2) echo -e "\n${blue}--- 磁盘空间 ---${plain}"; df -h ;;
        3) echo -e "\n${blue}--- 运行状态 ---${plain}"; uptime ;;
        4) echo -e "\n${blue}--- 📊 静态内存报告 ---${plain}"; free -h --si ;;
        5) echo -e "\n${cyan}--- 正在启动任务管理器 ---${plain}"; sleep 1; top ;;
        6) echo -e "\n${blue}--- 监听端口 ---${plain}"; ss -tuln ;;
     7)
        echo -e "\n${blue}=== 📦 代理核心深度体检 (系统底层) ===${plain}"
        echo -e "${yellow}当前北京时间：${green}$(date +"%Y-%m-%d %H:%M:%S")${plain}\n"

        check_detail() {
            local service=$1
            local display=$2
            if systemctl list-unit-files | grep -qw "${service}.service"; then
                # 自动提取版本号
                local version=$($service version 2>/dev/null | head -n 1 | awk '{print $2}')
                [ -z "$version" ] && version=$($service -version 2>/dev/null | head -n 1 | awk '{print $3}')
                [ -z "$version" ] && version="未知版本"

                # 提取监听端口
                local ports=$(ss -tlnp | grep "$service" | awk '{print $4}' | awk -F':' '{print $NF}' | sort -u | tr '\n' ' ')
                [ -z "$ports" ] && ports="无外部监听"

                if systemctl is-active --quiet "$service"; then
                    echo -e " ${display} : ${green}运行中 ✅${plain}"
                    echo -e "    └─ 版本: ${cyan}${version}${plain}  端口: ${cyan}${ports}${plain}"
                else
                    echo -e " ${display} : ${red}已停止/出故障 ❌${plain}"
                fi
            else
                echo -e " ${display} : ${yellow}未安装/未启用 ⚠️${plain}"
            fi
        }

        check_detail "sing-box" "🚀 Sing-box 核心"
        check_detail "xray"     "🛸 Xray     核心"

        echo -e "\n${blue}--- 🌍 服务器当前公网出口详情 ---${plain}"
        curl -sS --max-time 3 https://ip.gs || echo -e "${yellow}获取 IP 失败，请检查网络连接${plain}"
        
        echo -e "\n${yellow}------------------------------------------${plain}"
        read -p "👉 按【回车键】返回主菜单..."
        ;;
     8)
        echo -e "\n${blue}=== 🌐 WARP 与 Argo 隧道出站详情 ===${plain}"
        echo -e "${yellow}正在侦测网络出站链路，请稍候...${plain}\n"
        
        # 1. 侦测 WARP 状态与虚拟 IP
        echo -e "${cyan}[ WARP 解锁状态 ]${plain}"
        # 检查是否有 warp 服务在运行
        if systemctl is-active --quiet warp-go 2>/dev/null || systemctl is-active --quiet wg-quick@wgcf 2>/dev/null; then
            # 获取 Cloudflare trace 信息
            local trace=$(curl -s4m 3 https://www.cloudflare.com/cdn-cgi/trace)
            if echo "$trace" | grep -q "warp=on"; then
                local warp_ip=$(echo "$trace" | grep ip= | cut -d= -f2)
                echo -e " 🛡️  WARP 状态 : ${green}已开启并接管流量 ✅${plain}"
                echo -e " 🛡️  出口 IP   : ${cyan}${warp_ip}${plain} (Cloudflare 节点)"
            else
                echo -e " 🛡️  WARP 状态 : ${yellow}服务已启动但未成功接管流量 ⚠️${plain}"
            fi
        else
            echo -e " 🛡️  WARP 状态 : ${red}未开启或未安装 ❌${plain}"
        fi

        # 2. 侦测 Argo 隧道域名
        echo -e "\n${cyan}[ Argo 隧道状态 ]${plain}"
        if pgrep -x "cloudflared" >/dev/null; then
            echo -e " 🚇 Argo 进程 : ${green}运行中 ✅${plain}"
            # 这里的正则专门抓取你朋友那种 AnyTLS 或是甬哥脚本产生的临时 trycloudflare 域名
            local argo_url=$(ps -ef | grep cloudflared | grep -oE "[a-zA-Z0-9.-]+\.trycloudflare\.com" | head -n 1)
            if [ -n "$argo_url" ]; then
                echo -e " 🚇 临时域名 : ${cyan}https://${argo_url}${plain}"
            else
                echo -e " 🚇 临时域名 : ${yellow}未能提取到临时域名 (可能使用固定域名或正在启动)${plain}"
            fi
        else
            echo -e " 🚇 Argo 进程 : ${red}未运行 ❌${plain}"
        fi

        echo -e "\n${yellow}提示：如需修复以上出站异常，请返回主菜单使用第 24 项。${plain}"
        echo -e "${yellow}------------------------------------------${plain}"
        read -p "👉 按【回车键】继续..."
        ;;
     9) 
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
        11) 
        echo -e "\n${red}⚠️ 警告：此操作将物理重启整台 VPS 服务器！${plain}"
        echo -e "${yellow}执行后，当前的 SSH 连接将会立即断开，请等待 1-2 分钟后再重新连接。${plain}"
        read -p "确定要整机重启吗？(y/n): " c
        [[ "$c" == "y" || "$c" == "Y" ]] && sudo reboot 
        ;;
        12) echo -e "\n${blue}--- 开始流媒体解锁测试 ---${plain}"; bash <(curl -L -s media.ispvps.com) ;;
        13) 
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
        14)
            echo -e "\n${blue}--- 🛰️ 正在测试全球主流节点延迟 ---${plain}"
            echo -ne "🇺🇸 Cloudflare: " && ping -c 3 1.1.1.1 | tail -1 | awk -F '/' '{print $5" ms"}' || echo "超时"
            echo -ne "🇺🇸 Google: " && ping -c 3 8.8.8.8 | tail -1 | awk -F '/' '{print $5" ms"}' || echo "超时"
            echo -ne "🇨🇳 百度 (中国大陆): " && ping -c 3 220.181.38.251 | tail -1 | awk -F '/' '{print $5" ms"}' || echo "超时"
            echo -e "\n${green}✅ 测速完成！${plain}"
            ;;
        15)
            echo -e "\n${blue}--- 🚨 设置/管理 Telegram 智能报警监控 (全能体检版) ---${plain}"
            
            # 兼容性环境检查
            if ! command -v curl &> /dev/null; then
                echo -e "${yellow}正在安装必须的网络组件 curl...${plain}"
                apt-get update -y && apt-get install curl -y >/dev/null 2>&1 || yum install curl -y >/dev/null 2>&1
            fi

            if [ -f "/usr/local/bin/ssh_tg_alert.sh" ]; then
                echo -e "${green}✅ 检测到当前已开启 TG 报警防线！${plain}"
                read -p "请选择操作 (r:重新配置 / d:彻底卸载删除 / n:取消): " tg_choice
                if [[ "$tg_choice" == "d" ]]; then
                    sudo rm -f /usr/local/bin/ssh_tg_alert.sh
                    sudo rm -f /usr/local/bin/tg_boot_alert.sh
                    sudo sed -i '/ssh_tg_alert.sh/d' /etc/profile
                    sudo sed -i '/ssh_tg_alert.sh/d' /etc/bash.bashrc
                    sudo systemctl disable --now tg_boot_alert.service 2>/dev/null
                    sudo rm -f /etc/systemd/system/tg_boot_alert.service
                    sudo systemctl daemon-reload
                    
                    # --- 智能排雷与预览逻辑 ---
                    echo -e "\n${yellow}正在扫描系统定时任务 (crontab) 中的旧版残余报警指令...${plain}"
                    if crontab -l 2>/dev/null | grep -q "api.telegram.org"; then
                        echo -e "${red}发现以下残留的旧版发信指令（即将被清理，其余任务将保留）：${plain}"
                        crontab -l 2>/dev/null | grep "api.telegram.org"
                        echo -e "${cyan}---------------------------------------------------${plain}"
                        echo -e "${yellow}清理后，您的系统定时任务将变为以下状态（请预览确认）：${plain}"
                        crontab -l 2>/dev/null | grep -v "api.telegram.org"
                        echo -e "${cyan}---------------------------------------------------${plain}"
                        read -p "是否确认执行清理？(y/n): " confirm_clean
                        if [[ "$confirm_clean" == "y" || "$confirm_clean" == "Y" ]]; then
                            crontab -l 2>/dev/null | grep -v "api.telegram.org" | crontab -
                            echo -e "${green}✅ 旧版定时报警指令已彻底清理干净！${plain}"
                        else
                            echo -e "${yellow}已取消清理残留。${plain}"
                        fi
                    else
                        echo -e "${green}未发现旧版定时报警残留，您的系统很干净！${plain}"
                    fi
                    # -------------------------
                    
                    echo -e "${green}✅ TG 报警防线已彻底无痕卸载！您可以回到主菜单查看状态。${plain}"
                elif [[ "$tg_choice" == "r" || "$tg_choice" == "R" ]]; then
                    tg_setup_flag=1
                else
                    echo -e "${cyan}操作已取消。${plain}"
                    tg_setup_flag=0
                fi
            else
                echo -e "💡 本脚本开源安全，Token 仅保存在本机，不会上传网络！"
                tg_setup_flag=1
            fi

            if [[ "$tg_setup_flag" == "1" ]]; then
                echo -e "\n💡 准备配置，Token 仅保存在本机，绝对安全！"
                read -p "请输入你的 TG Bot Token: " tg_token
                read -p "请输入你的 TG Chat ID: " tg_chatid
                if [[ -n "$tg_token" && -n "$tg_chatid" ]]; then
                    
                    # ==========================================
                    # 1. 编写 SSH 登录发信脚本 (集成物理网卡绕过 WARP)
                    # ==========================================
                    cat << EOF2 > /usr/local/bin/ssh_tg_alert.sh
#!/bin/bash
if [ -z "\$TG_ALERT_TRIGGERED" ]; then
    export TG_ALERT_TRIGGERED=1
    export TZ="Asia/Shanghai"
    USER_IP=\$(echo \$SSH_CLIENT | awk '{print \$1}')
    if [ -n "\$USER_IP" ]; then
        MSG="🚨 [神盾局警告]
大佬，您的服务器 \$(hostname) 刚刚被登录了！
👉 来源 IP: \$USER_IP
⏰ 北京时间: \$(date +'%Y-%m-%d %H:%M:%S')"
        
        # --- 核心绝杀：强制绕过 WARP，抓取物理主网卡 ---
        MAIN_IF=\$(ip -4 route ls | grep default | grep -v tun | grep -v warp | grep -v wg | awk '{print \$5}' | head -n 1)
        
        if [ -n "\$MAIN_IF" ]; then
            curl --interface "\$MAIN_IF" -s -X POST "https://api.telegram.org/bot${tg_token}/sendMessage" --data-urlencode chat_id="${tg_chatid}" --data-urlencode text="\$MSG" > /dev/null 2>&1 &
        else
            curl -s -X POST "https://api.telegram.org/bot${tg_token}/sendMessage" --data-urlencode chat_id="${tg_chatid}" --data-urlencode text="\$MSG" > /dev/null 2>&1 &
        fi
    fi
fi
EOF2
                    chmod +x /usr/local/bin/ssh_tg_alert.sh
                    
                    # 2. 双重注入环境变量
                    sed -i '/ssh_tg_alert.sh/d' /etc/profile
                    sed -i '/ssh_tg_alert.sh/d' /etc/bash.bashrc
                    echo "source /usr/local/bin/ssh_tg_alert.sh" >> /etc/profile
                    echo "source /usr/local/bin/ssh_tg_alert.sh" >> /etc/bash.bashrc
                    
                    # ==========================================
                    # 3. 编写开机复苏发信脚本 (整合多核智能侦测体检)
                    # ==========================================
                    cat << EOF2 > /usr/local/bin/tg_boot_alert.sh
#!/bin/bash
sleep 15
export TZ="Asia/Shanghai"

# --- 智能多核心状态检查 ---
# Sing-box
if systemctl list-unit-files | grep -qw sing-box.service; then
    systemctl is-active --quiet sing-box && SB_STAT="运行中 ✅" || SB_STAT="异常 ❌"
else
    SB_STAT="未安装 ⚠️"
fi

# Xray
if systemctl list-unit-files | grep -qw xray.service; then
    systemctl is-active --quiet xray && XR_STAT="运行中 ✅" || XR_STAT="异常 ❌"
else
    XR_STAT="未安装 ⚠️"
fi

# Argo
if command -v cloudflared >/dev/null 2>&1 || systemctl list-unit-files | grep -qw cloudflared.service; then
    if pgrep -x "cloudflared" >/dev/null || systemctl is-active --quiet cloudflared 2>/dev/null; then
        ARGO_STAT="运行中 ✅"
    else
        ARGO_STAT="异常 ❌"
    fi
else
    ARGO_STAT="未安装 ⚠️"
fi

# WARP
if systemctl is-active --quiet warp-go 2>/dev/null || systemctl is-active --quiet wg-quick@wgcf 2>/dev/null; then
    WARP_STAT="已接管 ✅"
else
    WARP_STAT="未开启/未安装 ⚠️"
fi

# 构建带有多行排版的精美报告
MSG="🟢 [Velox 系统复苏通知]
大佬，您的服务器 \$(hostname) 已完成重启并成功连网！

📊 【核心体检报告】
🚀 Sing-box : \$SB_STAT
🛸 Xray 核心: \$XR_STAT
🚇 Argo 隧道: \$ARGO_STAT
🛡️ WARP 出站: \$WARP_STAT

⏰ 北京时间: \$(date +'%Y-%m-%d %H:%M:%S')"

# --- 核心绝杀：强制绕过 WARP，抓取物理主网卡 ---
MAIN_IF=\$(ip -4 route ls | grep default | grep -v tun | grep -v warp | grep -v wg | awk '{print \$5}' | head -n 1)

if [ -n "\$MAIN_IF" ]; then
    curl --interface "\$MAIN_IF" -s -X POST "https://api.telegram.org/bot${tg_token}/sendMessage" --data-urlencode chat_id="${tg_chatid}" --data-urlencode text="\$MSG" > /dev/null 2>&1
else
    curl -s -X POST "https://api.telegram.org/bot${tg_token}/sendMessage" --data-urlencode chat_id="${tg_chatid}" --data-urlencode text="\$MSG" > /dev/null 2>&1
fi
EOF2
                    chmod +x /usr/local/bin/tg_boot_alert.sh
                    
                    # 4. 部署工业级 Systemd 守护进程
                    cat << EOF3 > /etc/systemd/system/tg_boot_alert.service
[Unit]
Description=Telegram Boot Alert
After=network-online.target
Wants=network-online.target

[Service]
Type=oneshot
ExecStart=/usr/local/bin/tg_boot_alert.sh

[Install]
WantedBy=multi-user.target
EOF3
                    systemctl daemon-reload
                    systemctl enable tg_boot_alert.service > /dev/null 2>&1
                    
                    echo -e "\n${green}✅ TG 全能体检报警防线部署成功！主菜单已点亮 [已部署] 徽章！${plain}"
                else
                    echo -e "\n${red}❌ 输入不完整，已取消设置。${plain}"
                fi
            fi
            
            echo ""
            read -p "👉 按【回车键】返回主菜单..."
            ;;
        16)
            echo -e "\n${blue}--- 📈 网卡流量统计 (开机至今) ---${plain}"
            ip -s link | awk '/^[0-9]+:/ { iface=$2 } /RX:/ { getline; rx=$1 } /TX:/ { getline; tx=$1; printf "网卡 %s\n  ⬇️ 下载: %.2f MB\n  ⬆️ 上传: %.2f MB\n", iface, rx/1048576, tx/1048576 }'
            ;;
        17)
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
        18)
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
        19)
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
       20)
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
       21)
            echo -e "\n${blue}======================================================${plain}"
            echo -e "${yellow}      🚀 欢迎进入专业代理部署与维稳中心 🚀${plain}"
            echo -e "${blue}======================================================${plain}"
            echo -e "  ${cyan}1.${plain} 📦 安装/管理 【Sing-box 核心】 (终端命令行版)"
            echo -e "  ${cyan}2.${plain} 🖥️  安装/管理 【X-UI 面板】 (网页可视化多用户版)"
            echo -e "  ${red}3.${plain} 🛑 停止 Sing-box 核心服务 (释放端口与内存)"
            echo -e "  ${green}4.${plain} ⚡ 启动 Sing-box 核心服务 (恢复节点运行)"
            echo -e "  ${red}5.${plain} 🛑 停止 X-UI 面板服务 (释放端口与内存)"
            echo -e "  ${green}6.${plain} ⚡ 启动 X-UI 面板服务 (恢复节点运行)"
            echo -e "  ${cyan}0.${plain} ↩️  取消操作并返回上一级菜单"
            echo -e "${blue}------------------------------------------------------${plain}"
            read -p "👉 请输入对应数字并回车 [0-6]: " yg_choice
            
            case $yg_choice in
                1)
                    echo -e "\n${green}▶ 正在启动 Sing-box 部署脚本，请稍候...${plain}"
                    sleep 1
                    bash <(wget -qO- https://raw.githubusercontent.com/yonggekkk/sing-box-yg/main/sb.sh)
                    ;;
                2)
                    echo -e "\n${green}▶ 正在启动 X-UI 部署脚本，请稍候...${plain}"
                    sleep 1
                    bash <(wget -qO- https://raw.githubusercontent.com/yonggekkk/x-ui-yg/main/install.sh)
                    ;;
                3)
                    echo -e "\n${yellow}▶ 正在停止 Sing-box 服务...${plain}"
                    systemctl stop sing-box
                    echo -e "${red}✅ 已停止！Sing-box 核心已退出，相关端口已释放。${plain}"
                    sleep 2
                    ;;
                4)
                    echo -e "\n${yellow}▶ 正在启动 Sing-box 服务...${plain}"
                    systemctl start sing-box
                    echo -e "${green}✅ 已启动！Sing-box 节点已恢复正常运行。${plain}"
                    sleep 2
                    ;;
                5)
                    echo -e "\n${yellow}▶ 正在停止 X-UI 服务...${plain}"
                    systemctl stop x-ui
                    echo -e "${red}✅ 已停止！X-UI 面板已退出，相关端口已释放。${plain}"
                    sleep 2
                    ;;
                6)
                    echo -e "\n${yellow}▶ 正在启动 X-UI 服务...${plain}"
                    systemctl start x-ui
                    echo -e "${green}✅ 已启动！X-UI 面板及节点已恢复正常运行。${plain}"
                    sleep 2
                    ;;
                0)
                    echo -e "\n${green}✅ 已取消操作，安全返回主菜单。${plain}"
                    ;;
                *)
                    echo -e "\n${red}❌ 错误：无效的选项，操作取消。${plain}"
                    ;;
            esac
            ;;
    22)
        while true; do
            echo -e "\n${blue}=== ⏱️ VPS 高级定时任务管理 ===${plain}"
            echo -e "${yellow}说明：设置后 VPS 会在指定时间自动干活。若已设置，再次设置将自动覆盖旧任务。${plain}"
            timedatectl set-timezone Asia/Shanghai
            echo -e "当前系统已强制校准为北京时间：${green}$(date +"%Y-%m-%d %H:%M:%S")${plain}\n"
            
            echo -e "${cyan}【VPS 整机自动重启】 (清理内存垃圾，防卡死)${plain}"
            echo -e "1. 设置 [每天] 定时整机重启      11. ${red}彻底删除${plain} [整机重启] 任务"
            echo -e "2. 设置 [每周] 定时整机重启"
            echo -e "3. 设置 [每月] 定时整机重启"
            echo -e "\n${cyan}【WARP IP 自动刷新】 (防 Netflix/ChatGPT 封锁)${plain}"
            echo -e "4. 设置 [每天] 定时刷新 WARP     44. ${red}彻底删除${plain} [刷新WARP] 任务"
            echo -e "\n${cyan}【综合任务管理】${plain}"
            echo -e "5. 查看当前已生效的任务列表      6. ✍️  手动高级编辑 (极客专属)"
            echo -e "55. ${red}一键清空${plain} 所有任务 (慎用)     0. ${yellow}退出并返回主菜单${plain}"
            echo -e "--------------------------------------------------------"
            read -p "请输入指令 [0-6, 11, 44, 55]: " cron_choice

            case $cron_choice in
                1) 
                    read -p "请输入每天重启的小时(0-23, 填4代表北京时间凌晨4点) [直接回车取消]: " h
                    if [[ -n "$h" && "$h" =~ ^[0-9]+$ && "$h" -ge 0 && "$h" -le 23 ]]; then
                        crontab -l 2>/dev/null | grep -v "reboot" | sed '/^$/d' > /tmp/cron_tmp
                        echo "0 $h * * * /sbin/reboot" >> /tmp/cron_tmp
                        crontab /tmp/cron_tmp
                        rm -f /tmp/cron_tmp
                        echo -e "\n${green}✅ 设置成功！每天北京时间 $h:00 会自动执行 VPS 整机重启。${plain}"
                    else
                        echo -e "\n${yellow}⚠️ 检测到无效输入或已直接回车，取消设置，未做任何修改。${plain}"
                    fi
                    ;;
                2) 
                    read -p "星期几执行整机重启(1-7, 7代表周日) [直接回车取消]: " d
                    read -p "几点重启(0-23, 填4代表北京时间凌晨4点) [直接回车取消]: " h
                    if [[ -n "$d" && "$d" =~ ^[1-7]$ && -n "$h" && "$h" =~ ^[0-9]+$ && "$h" -ge 0 && "$h" -le 23 ]]; then
                        [ "$d" == "7" ] && d=0
                        crontab -l 2>/dev/null | grep -v "reboot" | sed '/^$/d' > /tmp/cron_tmp
                        echo "0 $h * * $d /sbin/reboot" >> /tmp/cron_tmp
                        crontab /tmp/cron_tmp
                        rm -f /tmp/cron_tmp
                        echo -e "\n${green}✅ 设置成功！每周 $d 的北京时间 $h:00 会自动重启 VPS。${plain}"
                    else
                        echo -e "\n${yellow}⚠️ 检测到无效输入或已直接回车，取消设置，未做任何修改。${plain}"
                    fi
                    ;;
                3) 
                    read -p "每月几号执行整机重启(1-28) [直接回车取消]: " d
                    read -p "几点重启(0-23, 填4代表北京时间凌晨4点) [直接回车取消]: " h
                    if [[ -n "$d" && "$d" =~ ^([1-9]|1[0-9]|2[0-8])$ && -n "$h" && "$h" =~ ^[0-9]+$ && "$h" -ge 0 && "$h" -le 23 ]]; then
                        crontab -l 2>/dev/null | grep -v "reboot" | sed '/^$/d' > /tmp/cron_tmp
                        echo "0 $h $d * * /sbin/reboot" >> /tmp/cron_tmp
                        crontab /tmp/cron_tmp
                        rm -f /tmp/cron_tmp
                        echo -e "\n${green}✅ 设置成功！每月 $d 号的北京时间 $h:00 会自动重启 VPS。${plain}"
                    else
                        echo -e "\n${yellow}⚠️ 检测到无效输入或已直接回车，取消设置，未做任何修改。${plain}"
                    fi
                    ;;
                11)
                    crontab -l 2>/dev/null | grep -v "reboot" | sed '/^$/d' > /tmp/cron_tmp
                    crontab /tmp/cron_tmp
                    rm -f /tmp/cron_tmp
                    echo -e "\n${green}✅ 成功！已彻底抹除 [VPS整机自动重启] 相关的定时任务。${plain}"
                    ;;
                4) 
                    read -p "请输入每天刷新 WARP 的小时(0-23, 填4代表北京时间凌晨4点) [直接回车取消]: " h
                    if [[ -n "$h" && "$h" =~ ^[0-9]+$ && "$h" -ge 0 && "$h" -le 23 ]]; then
                        crontab -l 2>/dev/null | grep -i -v "warp" | sed '/^$/d' > /tmp/cron_tmp
                        echo "0 $h * * * systemctl stop warp-go;systemctl restart warp-go;systemctl restart wg-quick@wgcf;systemctl restart warp-svc" >> /tmp/cron_tmp
                        crontab /tmp/cron_tmp
                        rm -f /tmp/cron_tmp
                        echo -e "\n${green}✅ 设置成功！每天北京时间 $h:00 会自动彻底更换一次 WARP 的 IP。${plain}"
                    else
                        echo -e "\n${yellow}⚠️ 检测到无效输入或已直接回车，取消设置，未做任何修改。${plain}"
                    fi
                    ;;
                44)
                    crontab -l 2>/dev/null | grep -i -v "warp" | sed '/^$/d' > /tmp/cron_tmp
                    crontab /tmp/cron_tmp
                    rm -f /tmp/cron_tmp
                    echo -e "\n${green}✅ 成功！已彻底抹除 [WARP IP 自动刷新] 相关的定时任务。${plain}"
                    ;;
                5) 
                    echo -e "\n${yellow}👇 当前系统已生效的定时任务列表如下 (如果下方没内容则代表暂无任务)：${plain}"
                    crontab -l 2>/dev/null
                    echo -e "${yellow}--------------------------------------------------------${plain}"
                    ;;
                6) 
                    echo -e "\n${cyan}正在进入 crontab 极客编辑模式... (按 Ctrl+X 或 :wq 保存退出)${plain}"
                    crontab -e
                    echo -e "\n${green}✅ 手动编辑结束。${plain}"
                    ;;
                55)
                    read -p "⚠️ 警告：这会清空当前用户所有的定时任务，确定要执行吗？(y/n): " clear_all
                    if [[ "$clear_all" == "y" || "$clear_all" == "Y" ]]; then
                        crontab -r 2>/dev/null
                        echo -e "\n${red}🔥 已清空当前用户下的所有定时任务！${plain}"
                    else
                        echo -e "\n${yellow}已取消清空操作。${plain}"
                    fi
                    ;;
                0) 
                    echo -e "\n${green}退出定时任务管理，返回主菜单...${plain}"
                    break
                    ;;
                *) 
                    echo -e "\n${red}❌ 无效选项，请重新输入。${plain}"
                    ;;
            esac
            
            # 暂停器，完美防止菜单文字乱飞
            if [[ "$cron_choice" != "0" ]]; then
                echo ""
                read -p "👉 按【回车键】继续..."
            fi
        done
        ;;
        
    23)
        while true; do
            echo -e "\n${blue}=== ⚡ 代理节点服务无痛重启 ===${plain}"
            echo -e "${yellow}小白科普：当你发现节点连不上、断流时使用此功能。此操作【不会】重启整台 VPS，SSH 终端【不会】断开，瞬间完成。${plain}\n"
            echo -e "1. 仅重启 Sing-box 核心 (修复直连节点连不上)\n2. 仅重启 Xray 核心\n3. 仅重启 Cloudflared 进程 (修复 Argo 隧道/节点报-1假死)\n4. 🚀 一键通用重启所有代理服务 (最推荐)\n0. ${yellow}取消并返回主菜单${plain}"
            read -p "请选择操作 [0-4]: " res_choice
            
            case $res_choice in
                1) 
                    systemctl restart sing-box >/dev/null 2>&1
                    if [ $? -eq 0 ]; then 
                        echo -e "\n${green}✅ Sing-box 代理核心已成功重启！${plain}"
                    else 
                        echo -e "\n${yellow}⚠️ 未检测到 Sing-box 正在运行，或当前系统未安装该核心。${plain}"
                    fi
                    ;;
                2) 
                    systemctl restart xray >/dev/null 2>&1
                    if [ $? -eq 0 ]; then 
                        echo -e "\n${green}✅ Xray 代理核心已成功重启！${plain}"
                    else 
                        echo -e "\n${yellow}⚠️ 未检测到 Xray 正在运行，或当前系统未安装该核心。${plain}"
                    fi
                    ;;
                3) 
                    if command -v cloudflared >/dev/null 2>&1 || ps -ef | grep -v grep | grep -q cloudflared; then
                        # 先暴力杀进程，再优雅重启服务，专治 Argo 假死
                        pkill -9 cloudflared >/dev/null 2>&1
                        systemctl restart cloudflared >/dev/null 2>&1
                        echo -e "\n${green}✅ Argo 隧道已刷新连接，请稍等 10 秒后重新测速！${plain}"
                    else
                        echo -e "\n${yellow}⚠️ 当前环境未启用 Argo 隧道进程，无需刷新。${plain}"
                    fi
                    ;;
                4) 
                    echo -e "\n${cyan}正在执行系统级底层服务重启，通杀所有脚本环境...${plain}"
                    
                    # 直接针对系统服务下手，不管什么脚本装的，有就重启，没有就不管
                    systemctl restart sing-box >/dev/null 2>&1
                    systemctl restart xray >/dev/null 2>&1
                    pkill -9 cloudflared >/dev/null 2>&1
                    systemctl restart cloudflared >/dev/null 2>&1
                    
                    echo -e "\n${green}✅ 当前系统中存在的所有代理服务已全部满血复活！${plain}"
                    ;;
                0) 
                    echo -e "\n${green}返回主菜单...${plain}"
                    break
                    ;;
                *) 
                    echo -e "\n${red}❌ 无效选项，请重新输入。${plain}"
                    ;;
            esac
            
            if [[ "$res_choice" != "0" ]]; then
                echo ""
                read -p "👉 按【回车键】继续..."
            fi
        done
        ;;
        
    24)
        echo -e "\n${blue}=== 🔗 节点全能雷达扫描与迷你二维码提取 ===${plain}"
        
        # 0. 自动安装终端二维码画图组件
        if ! command -v qrencode >/dev/null 2>&1; then
            echo -e "${yellow}正在给系统安装二维码生成模块 (qrencode)...${plain}"
            apt-get update -y && apt-get install qrencode -y >/dev/null 2>&1 || yum install qrencode -y >/dev/null 2>&1
        fi

        # 核心画图函数：采用 UTF8 编码，二维码体积缩小一半，手机也能扫！
        draw_qr() {
            local link=$1
            echo -e "\n${cyan}------------------------------------------------${plain}"
            echo -e "${green}🔗 提取到节点：${plain}${link}"
            echo -e "${yellow}👇 扫描下方 [迷你二维码] 导入客户端：${plain}"
            qrencode -m 2 -t UTF8 "$link"
            echo -e "${cyan}------------------------------------------------${plain}"
        }

        found_node=0
        
        # 终极正则匹配库：加入 # 号支持，通杀 anytls, tuic, hy2, vmess 等所有主流/非主流协议
        REGEX_PATTERN="(anytls|vless|vmess|trojan|hysteria2|hy2|tuic|ss|ssr)://[a-zA-Z0-9_=+/%@:?&.\#-]+"

        # 1. 精准狙击：小钢炮 (AnyTLS) 
        if [ -f "/root/agsbx/jh.txt" ]; then
            echo -e "\n${cyan}🎯 扫描到 [小钢炮/AnyTLS] 配置文件，正在提取所有节点...${plain}"
            # 提取所有命中规则的链接
            agsbx_links=$(grep -oE "$REGEX_PATTERN" /root/agsbx/jh.txt)
            if [ -n "$agsbx_links" ]; then
                for link in $agsbx_links; do
                    draw_qr "$link"
                done
                found_node=1
            fi
        fi

        # 2. 精准狙击：甬哥 sb 脚本
        if command -v sb >/dev/null 2>&1; then
            echo -e "\n${cyan}🎯 扫描到 [甬哥 sb 一键脚本] 运行环境，正在提取所有节点...${plain}"
            # 搜索常见目录，去除冗余，获取所有链接 (去掉 head -n 1 限制)
            sb_links=$(grep -rhoE "$REGEX_PATTERN" /etc/s-box/ /etc/sing-box/ /root/ 2>/dev/null | sort -u)
            
            if [ -n "$sb_links" ]; then
                for link in $sb_links; do
                    draw_qr "$link"
                done
                found_node=1
            else
                echo -e "${yellow}💡 提示：未在明文文件中扫到 sb 节点。sb 脚本原生自带精美二维码，请退回主界面输入 sb 查看。${plain}"
                found_node=1
            fi
        fi

        # 3. 万能兜底：全盘正则暴力盲扫
        if [ "$found_node" -eq 0 ]; then
            echo -e "\n${cyan}📡 未发现常见脚本特征，启动底层正则全盘盲扫 (通杀模式)...${plain}"
            blind_links=$(grep -rhoE "$REGEX_PATTERN" /root/ 2>/dev/null | sort -u)
            
            if [ -n "$blind_links" ]; then
                echo -e "${green}🎉 暴力扫描命中！为您挖出以下隐藏节点：${plain}"
                for link in $blind_links; do
                    draw_qr "$link"
                done
            else
                echo -e "${red}❌ 扫描结束：未能提取到明文节点链接。部分高级脚本需使用专属快捷键查看。${plain}"
            fi
        fi

        echo -e "\n${yellow}------------------------------------------${plain}"
        read -p "👉 按【回车键】返回主菜单..."
        ;;
        
    25)
        echo -e "\n${blue}=== 🔐 Acme 证书查询与续签 ===${plain}"
        if [ -f "/root/.acme.sh/acme.sh" ]; then
            echo -e "${yellow}当前域名证书列表及到期时间如下：${plain}"
            /root/.acme.sh/acme.sh --list
            echo ""
            read -p "是否需要强制执行续签并重启服务？(y/n): " force_renew
            if [[ "$force_renew" == "y" || "$force_renew" == "Y" ]]; then
                echo -e "${cyan}正在向 Let's Encrypt 申请强制续签，请稍候...${plain}"
                /root/.acme.sh/acme.sh --cron --force
                systemctl restart sing-box xray
                echo -e "${green}✅ 续签尝试完成，并已重启代理服务。${plain}"
            else
                echo -e "${yellow}已取消强制续签。${plain}"
            fi
        else
            echo -e "${red}❌ 未检测到 Acme.sh 安装环境，说明当前使用的是自签证书或纯 IP 节点。${plain}"
        fi
        ;;
     U|u) 
            echo -e "\n${red}--- ⚠️  卸载操作 ---${plain}"
             read -p "确定卸载本面板吗？(y/n): " c
             if [[ "$c" == "y" ]]; then 
                 # 1. 删除面板本体及独立组件
                 rm -f /usr/local/bin/velox
                 rm -f /usr/local/bin/ssh_tg_alert.sh
                 rm -f /usr/local/bin/tg_boot_alert.sh
                 sed -i '/ssh_tg_alert.sh/d' /etc/profile
                 sed -i '/ssh_tg_alert.sh/d' /etc/bash.bashrc
                 
                 # 2. 停止并删除 Systemd 守护服务
                 systemctl disable --now tg_boot_alert.service 2>/dev/null
                 rm -f /etc/systemd/system/tg_boot_alert.service
                 systemctl daemon-reload
                 
                 echo -e "${green}✅ 面板本体及报警组件已卸载！${plain}"
                 
                 # 3. 智能排雷与预览逻辑
                 if crontab -l 2>/dev/null | grep -q "api.telegram.org"; then
                     echo -e "\n${yellow}正在扫描定时任务，发现旧版报警残留！${plain}"
                     echo -e "${cyan}---------------------------------------------------${plain}"
                     echo -e "${yellow}清理后您的定时任务将保留如下内容（请确认）：${plain}"
                     crontab -l 2>/dev/null | grep -v "api.telegram.org"
                     echo -e "${cyan}---------------------------------------------------${plain}"
                     read -p "是否顺手清理掉这些残留报警指令？(y/n): " clean_cron
                     if [[ "$clean_cron" == "y" ]]; then
                         crontab -l 2>/dev/null | grep -v "api.telegram.org" | crontab -
                         echo -e "${green}✅ 定时任务残留已清空！${plain}"
                     fi
                 fi
                 
                 if command -v fail2ban-client &> /dev/null; then
                     read -p "是否一并【彻底强拆】防盗门(Fail2ban)？(y/n): " remove_f2b
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
        0) echo -e "\n${green}祝Velox折腾愉快！${plain}\n"; exit ;;
        *) echo -e "\n${red}❌ 输入错误，请重新输入！${plain}" ;;
    esac
    echo -e "\n${cyan}按回车键继续...${plain}"; read
done
EOF
chmod +x /usr/local/bin/velox
echo -e "\033[1;32m✅ Velox V4.1 (智能UI细节修缮版) 部署完毕！请输入 velox 欣赏！\033[0m"
velox
