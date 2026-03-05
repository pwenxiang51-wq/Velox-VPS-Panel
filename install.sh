#!/bin/bash
# 自动生成并运行 Velox 面板 (V4.1 作者专属版 - 智能系统嗅探 + TG徽章)

cat << 'EOF' > /usr/local/bin/velox
#!/bin/bash 
# 定义内部颜色变量
blue='\033[38;5;39m'
green='\033[1;32m'
yellow='\033[1;33m' 
cyan='\033[1;36m'
red='\033[1;31m'
purple='\033[38;5;207m'
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
    # --- 第一板块：系统核心运维 ---
    echo -e "${blue}[ 板块一：🛡️ 系统核心运维 ]${plain}"
    echo -e "  ${yellow}1.${plain}  📊 ${green}查看系统基础信息${plain}"
    echo -e "  ${yellow}2.${plain}  💾 ${green}查看磁盘空间占用${plain}"
    echo -e "  ${yellow}3.${plain}  ⏱️  ${green}查看运行时间与负载${plain}"
    echo -e "  ${yellow}4.${plain}  📊 ${green}快速查看内存报告 (静态快照)${plain}"
    echo -e "  ${yellow}5.${plain}  📈 ${green}实时监控 CPU 与内存 (按 q 退出)${plain}"
    echo -e "  ${yellow}6.${plain}  🔌 ${green}查看系统监听端口${plain}"
    # --- 第二板块：网络高阶调优 ---
    echo -e "\n${blue}[ 板块二：🚀 网络高阶调优 ]${plain}"
    echo -e "  ${yellow}7.${plain}  📦 ${green}查看代理服务运行状态 (深度体检与 IP 查询) ${sb_stat}${plain}"
    echo -e "  ${yellow}8.${plain}  🌐  ${cyan}查看 WARP 与 Argo 出站详情 (独立管理中心)${plain}"
    echo -e "  ${yellow}9.${plain} 🚀 ${cyan}深度验证与管理 BBR 加速 ${bbr_stat}${plain}"
    echo -e "  ${yellow}10.${plain} 🧹 ${yellow}一键清理系统垃圾与强制释放内存${plain}"
    echo -e "  ${yellow}11.${plain} 🔄  ${green}重启 VPS 主机 (整机物理重启，SSH 会掉线)${plain}"
    # --- 第三板块：代理核心管理 ---
    echo -e "\n${blue}[ 板块三：🔌 代理核心管理 ]${plain}"
    echo -e "  ${yellow}12.${plain} 🎬 ${blue}流媒体解锁检测 (Netflix/ChatGPT等)${plain}"
    echo -e "  ${yellow}13.${plain} 🛡️ ${green}IP 纯净度与欺诈风险体检 (精准排雷)${plain}"
    echo -e "  ${yellow}14.${plain} ⚡ ${blue}TCP/UDP 网络底层高阶调优 (极限压榨带宽)${plain}"
    echo -e "  ${yellow}15.${plain} 🛰️ ${blue}全球主流节点 Ping 延迟测速${plain}"
    echo -e "  ${yellow}16.${plain} 🚨 ${red}设置/管理 SSH 异地登录 TG 报警 (含开机秒报 & 环境深度兼容) ${tg_stat}${plain}"
    # --- 第四板块：自动化与工具 ---
    echo -e "\n${blue}[ 板块四：🛠️ 自动化与高阶工具 ]${plain}"
    echo -e "  ${yellow}17.${plain} 📈 ${purple}网卡流量统计与极客动态视窗 (防超标 / 实时看网速)${plain}"
    echo -e "  ${yellow}18.${plain} 💽 ${purple}自定义管理虚拟内存 Swap (1G小鸡救星)${plain}"
    echo -e "  ${yellow}19.${plain} 📝 ${purple}修改服务器主机名 (给 VPS 轻松改名)${plain}"
    echo -e "  ${yellow}20.${plain} 🔄 ${purple}一键更新系统软件库 (智能适配全系统)${plain}"
    echo -e "  ${yellow}21.${plain} 🚨 ${red}SSH 隐身防盗门与双核防御中心 (抓外鬼/锁密码/防爆破机枪塔)${plain}"
    echo -e "  ${yellow}22.${plain} 🚀 ${purple}召唤甬哥全家桶 (Sing-box 终端版 / X-UI 网页版)${plain}"
    # --- 第五板块：核心修复与导出 ---
    echo -e "\n${blue}[ 板块五：⚡ 核心修复与配置提取 ]${plain}"
    echo -e "  ${yellow}23.${plain} ⏱️  ${cyan}设置定时任务 (设定 VPS 半夜自动重启 / 自动刷新 WARP)${plain}"
    echo -e "  ${yellow}24.${plain} 🔄  ${green}一键修复/重启所有代理服务 (解决掉线/假死/断流)${plain}"
    echo -e "  ${yellow}25.${plain} 🔗  ${purple}一键提取节点链接配置 (提取 vless/vmess/hy2)${plain}"
    echo -e "  ${yellow}26.${plain} 🔐  ${blue}Acme 域名证书深度管理 (查询到期 / 强制续签)${plain}"
    echo -e "  ${yellow}27.${plain} 🧳 ${purple}全域资产跨机搬家与星际舰队中心 (多机容灾/指令群发)${plain}"
    echo -e "${cyan}  ---------------------------------------------------${plain}"
    echo -e "  ${red}U.${plain}  🗑️  ${red}一键卸载本面板 (清理无痕)${plain}"
    echo -e "  ${red}0.${plain}  ❌ ${red}退出面板${plain}"
    echo -e "${cyan}=====================================================${plain}"
    
    echo -ne "请选择操作 [${yellow}1-27${plain}]: "
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
            # 获取 Cloudflare trace 信息 (已移除 local)
            trace=$(curl -s4m 3 https://www.cloudflare.com/cdn-cgi/trace)
            if echo "$trace" | grep -q "warp=on"; then
                # 已移除 local
                warp_ip=$(echo "$trace" | grep ip= | cut -d= -f2)
                echo -e " 🛡️  WARP 状态 : ${green}已开启并接管流量 ✅${plain}"
                echo -e " 🛡️  出口 IP   : ${cyan}${warp_ip}${plain} (Cloudflare 节点)"
            else
                echo -e " 🛡️  WARP 状态 : ${yellow}服务已启动但未成功接管流量 ⚠️${plain}"
            fi
        else
            echo -e " 🛡️  WARP 状态 : ${red}未开启或未安装 ❌${plain}"
        fi

        # 2. 侦测 Argo 隧道状态 (全环境自适应版)
        echo -e "\n${cyan}[ Argo 隧道状态 ]${plain}"
        if pgrep -x "cloudflared" >/dev/null; then
            echo -e " 🚇 Argo 进程 : ${green}运行中 ✅${plain}"
            
            # 尝试抓取临时隧道域名 (针对测试/小白用户) (已移除 local)
            argo_url=$(ps -ef | grep cloudflared | grep -oE "[a-zA-Z0-9.-]+\.trycloudflare\.com" | head -n 1)
            
            if [ -n "$argo_url" ]; then
                echo -e " 🔗 链路模式 : ${cyan}https://${argo_url}${plain} ${yellow}(临时隧道)${plain}"
            else
                # 这里就是区分极客与新手的关键逻辑
                # 如果进程在跑但没抓到 trycloudflare，通常只有两种可能：
                # 1. 正在使用 Token/YAML 配置的固定域名 (Named Tunnel)
                # 2. 进程刚启动，临时域名还没分配下来
                echo -e " 🔗 链路模式 : ${purple}固定域名或 Token 模式 ${plain}${yellow}(未侦测到临时 URL)${plain}"
                echo -e " 💡 ${yellow}提示：若您使用固定隧道，请在 Cloudflare 后台查看解析状态。${plain}"
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
        echo -e "\n${blue}--- 🧹 正在执行系统深度垃圾清理 ---${plain}"
        
        echo -e "${yellow}1. 正在清理软件安装包残留缓存...${plain}"
        if command -v apt-get >/dev/null 2>&1; then
            apt_before=$(du -sh /var/cache/apt/archives 2>/dev/null | cut -f1)
            apt-get autoremove -y >/dev/null 2>&1
            apt-get clean -y >/dev/null 2>&1
            echo -e "[${green}已完成${plain}] (Debian/Ubuntu 缓存已清理，约释放: ${yellow}${apt_before:-0B}${plain})"
        elif command -v dnf >/dev/null 2>&1; then
            dnf clean all >/dev/null 2>&1
            echo -e "[${green}已完成${plain}] (Rocky/Alma 缓存已清理)"
        elif command -v yum >/dev/null 2>&1; then
            yum clean all >/dev/null 2>&1
            echo -e "[${green}已完成${plain}] (CentOS 缓存已清理)"
        fi

        echo -e "\n${yellow}2. 正在清理 3 天前的系统过期日志...${plain}"
        if command -v journalctl >/dev/null 2>&1; then
            journalctl --vacuum-time=3d
        else
            echo -e "${red}未检测到 journalctl 工具，跳过日志清理。${plain}"
        fi

        echo -e "\n${yellow}3. 正在强制释放系统物理内存缓存 (Drop Caches)...${plain}"
        # 强制把系统内存里的 pagecache、dentries 和 inodes 缓存清空，拯救内存只有 512M 的小鸡
        sync; echo 3 > /proc/sys/vm/drop_caches
        echo -e "[${green}已完成${plain}] 内存缓存已释放，小鸡呼吸更加顺畅！"

        echo -e "\n🎉 ${green}系统深度垃圾清理与内存释放完毕！${plain}"
        echo -e "${cyan}-------------------------------------------------------------${plain}"
        read -p "👉 按【回车键】返回主菜单..."
        ;;
     11) 
        echo -e "\n${red}⚠️ 警告：此操作将物理重启整台 VPS 服务器！${plain}"
        echo -e "${yellow}执行后，当前的 SSH 连接将会立即断开，请等待 1-2 分钟后再重新连接。${plain}"
        read -p "确定要整机重启吗？(y/n): " c
        [[ "$c" == "y" || "$c" == "Y" ]] && sudo reboot 
        ;;
     12) echo -e "\n${blue}--- 开始流媒体解锁测试 ---${plain}"; bash <(curl -L -s media.ispvps.com) ;;
     13)
        echo -e "\n${blue}=== 🛡️ 节点 IP 纯净度与欺诈风险体检 ===${plain}"
        echo -e "${yellow}正在向全球数据库查询当前 VPS 的出站 IP 纯净度，请稍候...${plain}\n"

        VPS_IP=$(curl -s4m 3 https://api.ipify.org || curl -s4m 3 https://ip.gs)
        
        if [ -n "$VPS_IP" ]; then
            echo -e "🌍 当前出站 IP: ${cyan}${VPS_IP}${plain}\n"
            
            echo -e "${yellow}--- 📊 IP 综合分析报告 ---${plain}"
            # 完整输出 ping0 的报告（不限制行数，防截断）
            curl -sL "https://ping0.cc/geo" 2>/dev/null
            
            # 补充备用数据库查询（更直观的中文格式）
            echo -e "\n${cyan}--- 🌐 备用数据库补充信息 ---${plain}"
            curl -sL "http://ip-api.com/line/$VPS_IP?lang=zh-CN&fields=country,regionName,city,isp,org,as,mobile,proxy,hosting" 2>/dev/null | awk 'NR==1{print "国家/地区: "$0} NR==2{print "省份/州: "$0} NR==3{print "城市: "$0} NR==4{print "ISP 运营商: "$0} NR==5{print "所属机构: "$0} NR==6{print "ASN 号: "$0} NR==7{print "是否移动网络: "($0=="true"?"是":"否")} NR==8{print "是否代理/VPN: "($0=="true"?"是 (被标记)":"否 (干净)")} NR==9{print "是否机房 IP: "($0=="true"?"是 (Hosting)":"否 (家宽)")}'
            
            echo -e "\n${green}💡 极客科普：${plain}"
            echo -e "🟢 ${green}原生 IP (ISP)${plain}: 极品！流媒体全解锁，免谷歌验证码。"
            echo -e "🟡 ${yellow}机房 IP (Hosting)${plain}: 普通 VPS 都是这种，偶发验证码。"
            echo -e "🔴 ${red}风险 IP (Risk/Fraud)${plain}: 欺诈值若飘红，说明 IP 已被玩烂，建议套 WARP！"
            echo -e ""
            echo -e "🔗 ${cyan}想要查看 42% 这种精准欺诈分数，以及是否为广播 IP？${plain}"
            echo -e "👉 ${green}请按住 Ctrl 点击打开深度体检报告: ${plain}\033[4;34mhttps://ping0.cc/ip/$VPS_IP\033[0m"
        else
            echo -e "${red}❌ 无法获取本机 IP，请检查网络连接。${plain}"
        fi
        
        echo -e "\n${yellow}------------------------------------------${plain}"
        read -p "👉 按【回车键】返回主菜单..."
        ;;
     14)
        echo -e "\n${cyan}请选择网络底层调优方向：${plain}"
        echo -e "  ${green}1.${plain} ⚡ TCP 暴力扩容 (传统大文件下载提速)"
        echo -e "  ${green}2.${plain} 🌪️ UDP 极限压榨 (Hysteria2 / TUIC 专属抗丢包)"
        echo -e "  ${green}3.${plain} 🔥 双管齐下 (同时执行 TCP 与 UDP 调优，小孩子才做选择！)"
        echo -e "  ${red}4.${plain} 🗑️ 恢复系统默认 (清除所有自定义扩容参数，一键后悔)"
        echo -e "  ${cyan}0.${plain} 🔙 返回主菜单"
        read -p "👉 请输入选择 [0-4]: " tune_choice
        
        if [ "$tune_choice" == "0" ]; then
            echo -e "\n${yellow}已取消操作，返回主菜单。${plain}"
        else
            if [ "$tune_choice" == "1" ] || [ "$tune_choice" == "3" ]; then
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
                echo -e "${green}✅ TCP 读写窗口缓冲区已强行扩展！${plain}"
            fi

            if [ "$tune_choice" == "2" ] || [ "$tune_choice" == "3" ]; then
                echo -e "\n${blue}--- 🌪️ 正在进行 UDP 网络底层高阶调优 ---${plain}"
                sed -i '/net.core.rmem_max/d' /etc/sysctl.conf
                sed -i '/net.core.wmem_max/d' /etc/sysctl.conf
                sed -i '/net.ipv4.udp_rmem_min/d' /etc/sysctl.conf
                sed -i '/net.ipv4.udp_wmem_min/d' /etc/sysctl.conf
                echo "net.core.rmem_max=26214400" >> /etc/sysctl.conf
                echo "net.core.wmem_max=26214400" >> /etc/sysctl.conf
                echo "net.ipv4.udp_rmem_min=8192" >> /etc/sysctl.conf
                echo "net.ipv4.udp_wmem_min=8192" >> /etc/sysctl.conf
                sysctl -p > /dev/null 2>&1
                echo -e "${green}✅ UDP 读写缓冲区已暴力扩容至 25MB！${plain}"
                
                echo -e "\n${yellow}👉 正在嗅探主网卡并配置 CAKE/FQ 队列调度算法...${plain}"
                DEFAULT_IF=$(ip route get 8.8.8.8 | awk '{print $5}' | head -n 1)
                tc qdisc add dev $DEFAULT_IF root cake >/dev/null 2>&1 || tc qdisc add dev $DEFAULT_IF root fq >/dev/null 2>&1
                echo -e "${green}✅ 网卡 [$DEFAULT_IF] 队列调度已接管优化！(Hy2 速度将大幅提升)${plain}"
            fi

            if [ "$tune_choice" == "4" ]; then
                echo -e "\n${blue}--- 🗑️ 正在清除所有网络自定义调优参数 ---${plain}"
                sed -i '/net.core.rmem_max/d' /etc/sysctl.conf
                sed -i '/net.core.wmem_max/d' /etc/sysctl.conf
                sed -i '/net.ipv4.tcp_rmem/d' /etc/sysctl.conf
                sed -i '/net.ipv4.tcp_wmem/d' /etc/sysctl.conf
                sed -i '/net.ipv4.udp_rmem_min/d' /etc/sysctl.conf
                sed -i '/net.ipv4.udp_wmem_min/d' /etc/sysctl.conf
                sysctl -p > /dev/null 2>&1
                
                DEFAULT_IF=$(ip route get 8.8.8.8 | awk '{print $5}' | head -n 1)
                tc qdisc del dev $DEFAULT_IF root >/dev/null 2>&1
                echo -e "${green}✅ 所有强行注入的扩容参数已抹除，系统网络恢复默认状态！${plain}"
            fi

            if [[ ! "$tune_choice" =~ ^[0-4]$ ]]; then
                echo -e "${red}❌ 无效输入，已取消操作。${plain}"
            fi
        fi
        ;;
      15)
            echo -e "\n${blue}--- 🛰️ 正在测试全球主流节点延迟 ---${plain}"
            echo -ne "🇺🇸 Cloudflare: " && ping -c 3 1.1.1.1 | tail -1 | awk -F '/' '{print $5" ms"}' || echo "超时"
            echo -ne "🇺🇸 Google: " && ping -c 3 8.8.8.8 | tail -1 | awk -F '/' '{print $5" ms"}' || echo "超时"
            echo -ne "🇨🇳 百度 (中国大陆): " && ping -c 3 220.181.38.251 | tail -1 | awk -F '/' '{print $5" ms"}' || echo "超时"
            echo -e "\n${green}✅ 测速完成！${plain}"
            ;;
        16)
            echo -e "\n${blue}--- 🚨 设置/管理 Telegram 智能报警监控 (全能体检版) ---${plain}"
            
            # 兼容性环境检查
            if ! command -v curl &> /dev/null; then
                echo -e "${yellow}正在安装必须的网络组件 curl...${plain}"
                apt-get update -y && apt-get install curl -y >/dev/null 2>&1 || yum install curl -y >/dev/null 2>&1 || dnf install curl -y >/dev/null 2>&1
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
     17)
        echo -e "\n${cyan}请选择网卡流量监控模式：${plain}"
        echo -e "  ${green}1.${plain} 📊 静态累计流量报表 (查看自上次开机后的总消耗)"
        echo -e "  ${green}2.${plain} 📈 极客动态流量视窗 (黑客级 TUI 实时网速监控仪表盘)"
        echo -e "  ${cyan}0.${plain} 🔙 返回主菜单"
        read -p "👉 请输入选择 [0-2]: " traffic_choice

        if [ "$traffic_choice" == "0" ]; then
            echo -e "\n${yellow}已取消操作，返回主菜单。${plain}"
            
        elif [ "$traffic_choice" == "1" ]; then
            echo -e "\n${blue}=== 📊 本机网卡累计流量报表 ===${plain}"
            echo -e "统计自上次开机以来的总流量 (重启系统后会清零)："
            echo -e "${cyan}-------------------------------------------------------------${plain}"
            awk '
            BEGIN {
                printf "%-12s | %-12s | %-12s | %-12s\n", "🌐 网卡接口", "⬇️ 下载量", "⬆️ 上传量", "🔄 流量总计"
                printf "-------------------------------------------------------------\n"
            }
            NR > 2 {
                rx = $2; tx = $10; total = rx + tx;
                if (rx > 1073741824) {rx_str = sprintf("%.2f GB", rx/1073741824)}
                else if (rx > 1048576) {rx_str = sprintf("%.2f MB", rx/1048576)}
                else {rx_str = sprintf("%.2f KB", rx/1024)}
                
                if (tx > 1073741824) {tx_str = sprintf("%.2f GB", tx/1073741824)}
                else if (tx > 1048576) {tx_str = sprintf("%.2f MB", tx/1048576)}
                else {tx_str = sprintf("%.2f KB", tx/1024)}
                
                if (total > 1073741824) {total_str = sprintf("%.2f GB", total/1073741824)}
                else if (total > 1048576) {total_str = sprintf("%.2f MB", total/1048576)}
                else {total_str = sprintf("%.2f KB", total/1024)}
                
                if ($1 != "lo:") {
                    printf "%-14s | %-14s | %-14s | %-14s\n", $1, rx_str, tx_str, total_str
                }
            }
            ' /proc/net/dev
            echo -e "${cyan}-------------------------------------------------------------${plain}"
            echo -e "💡 ${yellow}提示：${plain} 此数据为系统底层实时统计。如果需要按月统计的持久化账单，建议以后考虑安装 vnstat。"
            
        elif [ "$traffic_choice" == "2" ]; then
            DEFAULT_IF=$(ip route get 8.8.8.8 | awk '{print $5}' | head -n 1)
            clear
            echo -e "${cyan}=======================================================${plain}"
            echo -e "      📈 Velox 极客视窗 - 实时网络监控仪 (网卡: $DEFAULT_IF)"
            echo -e "      💡 ${yellow}直接在键盘按【任意键】即可无缝退出监控模式${plain}"
            echo -e "${cyan}=======================================================${plain}\n\n\n\n"
            
            while true; do
                RX1=$(cat /sys/class/net/$DEFAULT_IF/statistics/rx_bytes)
                TX1=$(cat /sys/class/net/$DEFAULT_IF/statistics/tx_bytes)
                read -t 1 -n 1 -s key
                if [[ $? -eq 0 ]]; then break; fi
                RX2=$(cat /sys/class/net/$DEFAULT_IF/statistics/rx_bytes)
                TX2=$(cat /sys/class/net/$DEFAULT_IF/statistics/tx_bytes)
                RX_KB=$(( (RX2 - RX1) / 1024 ))
                TX_KB=$(( (TX2 - TX1) / 1024 ))
                RX_BAR_LEN=$((RX_KB / 50)); [[ $RX_BAR_LEN -gt 35 ]] && RX_BAR_LEN=35
                TX_BAR_LEN=$((TX_KB / 50)); [[ $TX_BAR_LEN -gt 35 ]] && TX_BAR_LEN=35
                RX_BAR=$(printf '%*s' $RX_BAR_LEN '' | tr ' ' '█')
                TX_BAR=$(printf '%*s' $TX_BAR_LEN '' | tr ' ' '█')
                echo -en "\033[4A\033[J"
                echo -e "⬇️  下载: ${green}$(printf "%7s" $RX_KB) KB/s${plain} | ${cyan}$RX_BAR${plain}"
                echo -e "⬆️  上传: ${red}$(printf "%7s" $TX_KB) KB/s${plain} | ${yellow}$TX_BAR${plain}"
                echo -e "\n👉 ${yellow}正在实时监控中... (按任意键返回主菜单)${plain}"
            done
            echo -e "\n${green}✅ 已退出动态监控模式。${plain}"
            sleep 0.5
            
        else
            echo -e "${red}❌ 无效输入，已取消操作。${plain}"
        fi
        
        # 统一的返回拦截点，避免选 0 还要再按一次回车
        if [[ "$traffic_choice" != "0" && "$traffic_choice" != "2" ]]; then
            echo ""
            read -p "👉 按【回车键】返回主菜单..."
        fi
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
        echo -e "\n${blue}--- 📝 修改服务器主机名 (VPS 改名/洗白) ---${plain}"
        echo -e "当前主机名: ${yellow}$(hostname)${plain}"
        echo -e "  ${green}1.${plain} 🔄 恢复系统默认主机名 (洗白为: localhost)"
        echo -e "  ${cyan}0.${plain} 🔙 返回主菜单"
        read -p "👉 请输入新主机名(纯英文/数字)，或输入 [0-1] 执行选项: " new_hostname
        
        # 第一道防线：安全退出
        if [ "$new_hostname" == "0" ]; then
            echo -e "\n${yellow}已取消操作，返回主菜单。${plain}"
            
        # 第二道防线：一键洗白恢复默认
        elif [ "$new_hostname" == "1" ]; then
            sudo hostnamectl set-hostname "localhost"
            echo -e "\n${green}✅ 主机名已成功洗白，恢复为系统默认: localhost ${plain}"
            echo -e "💡 提示: 重启服务器，或重新连接 SSH 终端后即可看到全新名称！"
            
        # 第三道防线：自定义改名（带硬核安全校验）
        elif [[ -n "$new_hostname" ]]; then
            # 极客正则校验：主机名只允许字母、数字、连字符，防止特殊符号把系统搞死
            if [[ "$new_hostname" =~ ^[a-zA-Z0-9-]+$ ]]; then
                sudo hostnamectl set-hostname "$new_hostname"
                echo -e "\n${green}✅ 主机名已成功修改为: $new_hostname ${plain}"
                echo -e "💡 提示: 重启服务器，或重新连接 SSH 终端后即可看到全新名称！"
            else
                echo -e "\n${red}❌ 格式严重错误！为了系统安全，主机名只能包含字母、数字和连字符(-)。${plain}"
            fi
            
        # 第四道防线：防瞎敲回车
        else
            echo -e "\n${red}❌ 输入为空，已取消修改。${plain}"
        fi
        
        # 统一的暂停点
        if [ "$new_hostname" != "0" ]; then
            echo ""
            read -p "👉 按【回车键】继续..."
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
        while true; do
            # 动态侦测当前 SSH 端口
            current_port=$(grep -iE "^Port " /etc/ssh/sshd_config | awk '{print $2}' | head -n 1)
            [ -z "$current_port" ] && current_port="22 (默认)"

            # 动态侦测密码登录状态
            if grep -q "^PasswordAuthentication no" /etc/ssh/sshd_config; then
                pw_status="${red}已关闭 (高安全)${plain}"
                pw_toggle="重新开启"
            else
                pw_status="${green}已开启 (有风险)${plain}"
                pw_toggle="强制关闭"
            fi

            # 💡 史诗级双核动态侦测：看看到底装了哪个防盗门
            defender_status="${red}裸奔中 (未部署防爆破)${plain}"
            if systemctl is-active --quiet velox-defender 2>/dev/null; then
                defender_status="${cyan}已激活 (纯 Bash 轻量机枪塔)${plain}"
            elif systemctl is-active --quiet fail2ban 2>/dev/null; then
                defender_status="${purple}已激活 (Fail2Ban 工业级装甲)${plain}"
            fi

            echo -e "\n${blue}=== 🚨 SSH 隐身防盗门与双核防御中心 ===${plain}"
            echo -e "${yellow}⚠️ 当前状态 -> 端口: [$current_port] | 密码: [$pw_status] | 防御: [$defender_status]${plain}\n"
            
            echo -e "  ${yellow}1.${plain} 🕵️  查看当前在线 SSH 用户并实施制裁"
            echo -e "  ${yellow}2.${plain} 💣  审计被拦截的黑客爆破日志 (查外鬼)"
            echo -e "  ${yellow}3.${plain} 🚪  修改 SSH 端口 (输入 22 即可恢复默认)"
            echo -e "  ${yellow}4.${plain} 🔑  一键切换密码登录开关 (执行: $pw_toggle)"
            echo -e "  ${yellow}5.${plain} 🛡️  ${green}一键添加 SSH 公钥 (配置免密登录必备)${plain}"
            echo -e "  ${red}6. 🚀 部署/卸载安全防御武器库 (机枪塔 / Fail2Ban 双核任选)${plain}"
            echo -e "  ${cyan}0.${plain}  返回主菜单"
            echo -e "--------------------------------------------------------"
            read -p "👉 请选择安全操作 [0-6]: " ssh_choice
            
            case $ssh_choice in
                1)
                    echo -e "\n${blue}--- 🕵️ 查看当前在线 SSH 用户 ---${plain}"
                    w
                    echo -e "${cyan}---------------------------------------------------${plain}"
                    read -p "请输入要制裁的终端号 (例如 pts/1，必须完整输入): " target_pts
                    if [[ -n "$target_pts" ]]; then
                        if [[ "$target_pts" =~ ^pts/[0-9]+$ ]]; then
                            if w | grep -q "$target_pts"; then
                                target_ip=$(w | grep "$target_pts" | grep -oE '[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+' | head -1)
                                [ -z "$target_ip" ] && target_ip="未知IP或隐藏来源"
                                
                                echo -e "\n${yellow}🎯 已锁定目标: 终端 [$target_pts] | 来源 IP: [$target_ip]${plain}"
                                echo -e "  ${cyan}1.${plain} 🥾 强行踢出\n  ${cyan}2.${plain} 🧱 永久拉黑\n  ${cyan}3.${plain} 👻 极客恶搞"
                                read -p "选择制裁套餐 [1-3]: " punish_choice
                                case $punish_choice in
                                    1) sudo pkill -9 -t "${target_pts#*/}" 2>/dev/null || sudo skill -9 "$target_pts"; echo -e "${green}✅ 已踢出！${plain}" ;;
                                    2)
                                        if [ "$target_ip" != "未知IP或隐藏来源" ]; then
                                            sudo iptables -A INPUT -s "$target_ip" -j DROP
                                        fi
                                        sudo pkill -9 -t "${target_pts#*/}" 2>/dev/null || sudo skill -9 "$target_pts"; echo -e "${green}✅ 已永久拉黑！${plain}" ;;
                                    3)
                                        echo -e "\n${purple}😈 发送死神警告...${plain}"
                                        sudo bash -c "echo -e '\n\n\033[1;31m[FATAL WARNING] UNAUTHORIZED ACCESS.\033[0m' > /dev/$target_pts" 2>/dev/null
                                        sleep 2
                                        sudo pkill -9 -t "${target_pts#*/}" 2>/dev/null || sudo skill -9 "$target_pts"; echo -e "${green}✅ 恶搞完毕并踢出！${plain}" ;;
                                    *) echo -e "${red}取消操作。${plain}" ;;
                                esac
                            else
                                echo -e "${red}⚠️ 找不到终端 [$target_pts]！${plain}"
                            fi
                        else
                            echo -e "${red}⚠️ 格式错误！必须输入如 pts/1 格式。${plain}"
                        fi
                    fi
                    ;;
                2)
                    echo -e "\n${blue}--- 💣 正在统计恶意爆破日志 (Top 10) ---${plain}"
                    ATTACKS=""
                    if [ -f "/var/log/auth.log" ]; then
                        ATTACKS=$(grep "Failed password" /var/log/auth.log | awk '{print $(NF-3)}' | sort | uniq -c | sort -nr | head -n 10)
                    elif [ -f "/var/log/secure" ]; then
                        ATTACKS=$(grep "Failed password" /var/log/secure | awk '{print $(NF-3)}' | sort | uniq -c | sort -nr | head -n 10)
                    elif command -v journalctl &> /dev/null; then
                        ATTACKS=$(journalctl -u ssh -u sshd --no-pager 2>/dev/null | grep "Failed password" | awk '{print $(NF-3)}' | sort | uniq -c | sort -nr | head -n 10)
                    fi
                    if [ -z "$ATTACKS" ]; then echo -e "${green}🎉 系统底层未查到任何被爆破的记录！${plain}"; else echo -e "${yellow}次数   |   攻击者 IP${plain}\n${cyan}$ATTACKS${plain}"; fi
                    ;;
                3)
                    read -p "✍️ 请输入新的 SSH 端口号 (1000-65535, 输入 22 恢复默认): " new_port
                    if [[ "$new_port" =~ ^[0-9]+$ ]] && ([ "$new_port" -eq 22 ] || ([ "$new_port" -ge 1000 ] && [ "$new_port" -le 65535 ])); then
                        sed -i "s/^#\?Port .*/Port $new_port/g" /etc/ssh/sshd_config
                        grep -q "^Port " /etc/ssh/sshd_config || echo "Port $new_port" >> /etc/ssh/sshd_config
                        systemctl restart sshd 2>/dev/null || systemctl restart ssh 2>/dev/null
                        if [ "$new_port" -eq 22 ]; then echo -e "\n${green}✅ SSH 端口已恢复为默认 ${red}22${plain} 端口！${plain}"; else echo -e "\n${green}✅ SSH 端口已修改为: ${red}$new_port${plain}\n⚠️ ${yellow}切记去云面板放行此端口！${plain}"; fi
                    else
                        echo -e "\n${red}❌ 端口不合法。${plain}"
                    fi
                    ;;
                4)
                    if grep -q "^PasswordAuthentication no" /etc/ssh/sshd_config; then
                        sed -i 's/^PasswordAuthentication no/PasswordAuthentication yes/g' /etc/ssh/sshd_config
                        systemctl restart sshd 2>/dev/null || systemctl restart ssh 2>/dev/null
                        echo -e "\n${yellow}🔓 密码登录已【重新开启】！${plain}"
                    else
                        read -p "⚠️ 确认关闭密码登录？(y/n): " confirm_key
                        if [[ "$confirm_key" == "y" || "$confirm_key" == "Y" ]]; then
                            sed -i 's/^#\?PasswordAuthentication.*/PasswordAuthentication no/g' /etc/ssh/sshd_config
                            grep -q "^PasswordAuthentication no" /etc/ssh/sshd_config || echo "PasswordAuthentication no" >> /etc/ssh/sshd_config
                            systemctl restart sshd 2>/dev/null || systemctl restart ssh 2>/dev/null
                            echo -e "\n${green}✅ 密码登录已【永久关闭】！${plain}"
                        fi
                    fi
                    ;;
                5)
                    echo -e "\n${blue}--- 🛡️ 一键添加 SSH 公钥 (配置免密登录) ---${plain}"
                    read -p "👉 请粘贴公钥: " ssh_pub_key
                    if [[ "$ssh_pub_key" == ssh-rsa* ]] || [[ "$ssh_pub_key" == ssh-ed25519* ]] || [[ "$ssh_pub_key" == ecdsa-sha2* ]]; then
                        mkdir -p ~/.ssh && chmod 700 ~/.ssh; echo "$ssh_pub_key" >> ~/.ssh/authorized_keys; chmod 600 ~/.ssh/authorized_keys
                        systemctl restart sshd 2>/dev/null || systemctl restart ssh 2>/dev/null; echo -e "\n${green}✅ 公钥已成功注入系统底座！${plain}"
                    else echo -e "\n${red}❌ 格式识别失败！${plain}"; fi
                    ;;
                6)
                    echo -e "\n${blue}--- 🚀 Velox 双核安全防御武器库 ---${plain}"
                    echo -e "  ${cyan}1.${plain} 🟢 [极简特种兵] 部署纯 Bash 底层机枪塔 (0 内存消耗，专防 SSH)"
                    echo -e "  ${cyan}2.${plain} 🗑️ ${red}[极简特种兵] 拆除并物理粉碎 Bash 机枪塔${plain}"
                    echo -e "  ${purple}3.${plain} 🛡️ [工业正规军] 安装 Fail2Ban 顶级防御 (全面防护，占内存)"
                    echo -e "  ${purple}4.${plain} 🗑️ ${red}[工业正规军] 完全卸载并清除 Fail2Ban 所有残留${plain}"
                    echo -e "  ${yellow}5.${plain} 📜 查看当前武器库的防御战果与拦截名单"
                    read -p "👉 请选择武器库操作 [1-5]: " def_choice
                    
                    if [ "$def_choice" == "1" ]; then
                        echo -e "\n${yellow}正在手搓 Bash 底层守护进程并注入 Systemd...${plain}"
                        
                        # 采用极其硬核的纯 echo 写入法，彻底粉碎任何编辑器的 EOF 缩进天坑！
                        echo '#!/bin/bash' > /usr/local/bin/velox-defender.sh
                        echo 'LOG_FILE="/var/log/auth.log"' >> /usr/local/bin/velox-defender.sh
                        echo '[ -f /var/log/secure ] && LOG_FILE="/var/log/secure"' >> /usr/local/bin/velox-defender.sh
                        echo 'tail -Fn0 "$LOG_FILE" | awk '\''/Failed password/ {print $(NF-3)}'\'' | while read IP; do' >> /usr/local/bin/velox-defender.sh
                        echo '    if [ -n "$IP" ]; then' >> /usr/local/bin/velox-defender.sh
                        echo '        COUNT=$(grep -c "^$IP$" /tmp/velox_ip_counts.txt 2>/dev/null || echo 0)' >> /usr/local/bin/velox-defender.sh
                        echo '        if [ "$COUNT" -ge 4 ]; then' >> /usr/local/bin/velox-defender.sh
                        echo '            if ! iptables -C INPUT -s "$IP" -j DROP &>/dev/null; then iptables -I INPUT -s "$IP" -j DROP; echo "$(date +'\''%Y-%m-%d %H:%M:%S'\'') - 💥 击毙爆破 IP: $IP" >> /var/log/velox-defender.log; fi' >> /usr/local/bin/velox-defender.sh
                        echo '            sed -i "/^$IP$/d" /tmp/velox_ip_counts.txt 2>/dev/null' >> /usr/local/bin/velox-defender.sh
                        echo '        else echo "$IP" >> /tmp/velox_ip_counts.txt; fi' >> /usr/local/bin/velox-defender.sh
                        echo '    fi' >> /usr/local/bin/velox-defender.sh
                        echo 'done' >> /usr/local/bin/velox-defender.sh
                        
                        chmod +x /usr/local/bin/velox-defender.sh
                        
                        echo '[Unit]' > /etc/systemd/system/velox-defender.service
                        echo 'Description=Velox SSH Defender Auto-Ban Daemon' >> /etc/systemd/system/velox-defender.service
                        echo 'After=network.target' >> /etc/systemd/system/velox-defender.service
                        echo '[Service]' >> /etc/systemd/system/velox-defender.service
                        echo 'ExecStart=/usr/local/bin/velox-defender.sh' >> /etc/systemd/system/velox-defender.service
                        echo 'Restart=always' >> /etc/systemd/system/velox-defender.service
                        echo 'RestartSec=3' >> /etc/systemd/system/velox-defender.service
                        echo '[Install]' >> /etc/systemd/system/velox-defender.service
                        echo 'WantedBy=multi-user.target' >> /etc/systemd/system/velox-defender.service
                        
                        systemctl daemon-reload; systemctl enable velox-defender >/dev/null 2>&1; systemctl restart velox-defender
                        echo -e "${green}✅ Bash 机枪塔已部署！连续输错 5 次密码的 IP 将被物理超度！${plain}"
                        
                    elif [ "$def_choice" == "2" ]; then
                        systemctl stop velox-defender >/dev/null 2>&1; systemctl disable velox-defender >/dev/null 2>&1
                        rm -f /usr/local/bin/velox-defender.sh; rm -f /etc/systemd/system/velox-defender.service; rm -f /tmp/velox_ip_counts.txt
                        systemctl daemon-reload
                        echo -e "${green}✅ Bash 机枪塔已彻底拆除并粉碎，不留一丝痕迹！${plain}"
                        
                    elif [ "$def_choice" == "3" ]; then
                        echo -e "\n${yellow}正在全网拉取 Fail2Ban 工业装甲...${plain}"
                        if command -v apt-get >/dev/null; then apt-get update >/dev/null 2>&1; apt-get install fail2ban -y >/dev/null 2>&1; fi
                        if command -v yum >/dev/null; then yum install epel-release -y >/dev/null 2>&1; yum install fail2ban -y >/dev/null 2>&1; fi
                        if command -v dnf >/dev/null; then dnf install epel-release -y >/dev/null 2>&1; dnf install fail2ban -y >/dev/null 2>&1; fi
                        
                        LOGPATH="/var/log/auth.log"; [ -f /var/log/secure ] && LOGPATH="/var/log/secure"
                        echo '[sshd]' > /etc/fail2ban/jail.local
                        echo 'enabled = true' >> /etc/fail2ban/jail.local
                        echo 'port = ssh' >> /etc/fail2ban/jail.local
                        echo 'filter = sshd' >> /etc/fail2ban/jail.local
                        echo "logpath = $LOGPATH" >> /etc/fail2ban/jail.local
                        echo 'maxretry = 5' >> /etc/fail2ban/jail.local
                        echo 'bantime = 86400' >> /etc/fail2ban/jail.local
                        
                        systemctl enable fail2ban >/dev/null 2>&1; systemctl restart fail2ban >/dev/null 2>&1
                        echo -e "${green}✅ Fail2Ban 顶级装甲已部署完毕！(拉黑时间默认 24 小时)${plain}"
                        
                    elif [ "$def_choice" == "4" ]; then
                        echo -e "\n${yellow}正在暴力拆除 Fail2Ban...${plain}"
                        systemctl stop fail2ban >/dev/null 2>&1; systemctl disable fail2ban >/dev/null 2>&1
                        if command -v apt-get >/dev/null; then apt-get remove --purge fail2ban -y >/dev/null 2>&1; fi
                        if command -v yum >/dev/null; then yum remove fail2ban -y >/dev/null 2>&1; fi
                        if command -v dnf >/dev/null; then dnf remove fail2ban -y >/dev/null 2>&1; fi
                        rm -rf /etc/fail2ban
                        echo -e "${green}✅ Fail2Ban 及其所有依赖和配置残留已彻底抹除！${plain}"
                        
                    elif [ "$def_choice" == "5" ]; then
                        if systemctl is-active --quiet velox-defender 2>/dev/null; then
                            echo -e "\n${cyan}--- 🎖️ Bash 机枪塔战果统计 (最新 15 条) ---${plain}"
                            [ -f "/var/log/velox-defender.log" ] && cat /var/log/velox-defender.log | tail -n 15 || echo "系统目前很安全，暂无击毙记录！"
                        elif systemctl is-active --quiet fail2ban 2>/dev/null; then
                            echo -e "\n${purple}--- 🎖️ Fail2Ban 拦截战果 ---${plain}"
                            fail2ban-client status sshd
                        else
                            echo -e "\n${yellow}⚠️ 您目前处于裸奔状态，未开启任何防御系统！${plain}"
                        fi
                    else echo -e "${red}❌ 无效输入。${plain}"; fi
                    ;;
                0) break ;;
                *) echo -e "\n${red}❌ 无效输入。${plain}" ;;
            esac
            
            if [[ "$ssh_choice" != "0" ]]; then
                echo ""
                read -p "👉 按【回车键】继续..."
            fi
        done
        ;;
       22)
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
    23)
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
        
    24)
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
        
    25)
        echo -e "\n${blue}=== 🔗 节点全能雷达扫描与二维码提取 (聚合编码版) ===${plain}"
        
        # 0. 自动安装终端二维码画图组件
        if ! command -v qrencode >/dev/null 2>&1; then
            echo -e "${yellow}正在给系统安装二维码生成模块 (qrencode)...${plain}"
            apt-get update -y && apt-get install qrencode -y >/dev/null 2>&1 || yum install qrencode -y >/dev/null 2>&1 || dnf install qrencode -y >/dev/null 2>&1
        fi

        echo -e "${cyan}📡 正在启动全局底层正则扫描，为您搜罗所有隐藏节点...${plain}"

        # 终极正则匹配库：通杀所有主流协议
        REGEX_PATTERN="(anytls|vless|vmess|trojan|hysteria2|hy2|tuic|ss|ssr)://[a-zA-Z0-9_=+/%@:?&.\#-]+"

        # 全盘扫描 + 自动去重
        ALL_LINKS=$(grep -rhoE "$REGEX_PATTERN" /root/ /etc/s-box/ /etc/sing-box/ /usr/local/ 2>/dev/null | sort -u | tr -d '\r')

        if [ -n "$ALL_LINKS" ]; then
            # 1. 自动生成 Base64 聚合订阅编码
            # Linux 原生 base64 命令，-w 0 保证长字符串不断行
            BASE64_SUB=$(echo -e "$ALL_LINKS" | base64 -w 0)

            echo -e "\n${green}🎉 扫描完毕！成功为您抓取到以下不重复的节点：${plain}"
            echo -e "${yellow}======================================================================${plain}"
            
            # 模块 A：Base64 聚合订阅 (高级玩法)
            echo -e "🚀【 全节点聚合订阅 (Base64编码) 】节点信息如下："
            echo -e "分享链接（可直接粘贴到客户端的“从剪贴板导入订阅”）："
            echo -e "${cyan}${BASE64_SUB}${plain}\n"
            
            # 模块 B：明文聚合直连 (防呆玩法)
            echo -e "📦【 纯净明文节点列表 (供一次性批量复制) 】："
            echo -e "${cyan}${ALL_LINKS}${plain}\n"
            echo -e "${yellow}======================================================================${plain}"
            echo -e "💡 ${red}复制提示${plain}：现在链接独占一行，鼠标【双击链接】即可精准全选，不会再粘到汉字了！\n"

            # 模块 C：单节点瀑布流 + 迷你二维码 (甬哥同款排版)
            echo -e "${cyan}👇 下面为您逐一展示单节点详情与【迷你二维码】：${plain}"
            echo -e "${yellow}------------------------------------------------${plain}"
            
            for link in $ALL_LINKS; do
                # 智能提取协议名称并转大写，用于展示酷炫标题 (比如 VLESS, ANYTLS)
                PROTO=$(echo "$link" | awk -F'://' '{print $1}' | tr 'a-z' 'A-Z')
                
                echo -e "🚀【 ${PROTO} 】节点信息如下："
                echo -e "\n分享链接："
                # 链接独占一行，解决鼠标双击复制的痛点
                echo -e "${cyan}${link}${plain}\n"
                
                echo -e "二维码："
                qrencode -m 2 -t UTF8 "$link"
                echo -e "${yellow}------------------------------------------------${plain}"
            done

        else
            echo -e "\n${red}❌ 扫描结束：未能提取到明文节点链接。${plain}"
        fi

        echo -e "\n${yellow}------------------------------------------${plain}"
        read -p "👉 按【回车键】返回主菜单..."
        ;;
     26)
        echo -e "\n${blue}=== 🔐 Acme 域名证书深度体检与管理 ===${plain}"
        
        # 智能侦测 Acme.sh 真实路径
        ACME_BIN=""
        if [ -f "/root/.acme.sh/acme.sh" ]; then
            ACME_BIN="/root/.acme.sh/acme.sh"
        elif [ -f "$HOME/.acme.sh/acme.sh" ]; then
            ACME_BIN="$HOME/.acme.sh/acme.sh"
        fi

        if [ -z "$ACME_BIN" ]; then
            echo -e "${yellow}⚠️ 未检测到 Acme.sh 安装路径。${plain}"
            echo -e "可能原因：当前 VPS 未申请过本地证书，或使用了 Certbot 等其他证书管理工具。"
        else
            echo -e "${cyan}👇 当前 VPS 本地已申请的证书列表与到期时间如下：${plain}"
            echo -e "${yellow}--------------------------------------------------------------------------------${plain}"
            "$ACME_BIN" --list
            echo -e "${yellow}--------------------------------------------------------------------------------${plain}"
            
            echo -e "\n${green}💡 小白防坑科普：${plain}"
            echo -e "虽然域名托管在 Cloudflare，但这层证书是签发并保存在 ${red}VPS 本地硬盘${plain} 上的（用于节点底层加密）。"
            echo -e "正常的 Acme 脚本会自动在后台续签。但若发现节点突然断流，且距离到期不足 10 天，请手动强制续签！"
            
            echo ""
            read -p "👉 是否需要强制执行续签，并自动重启所有代理服务？(y/n): " force_renew
            if [[ "$force_renew" == "y" || "$force_renew" == "Y" ]]; then
                read -p "✍️ 请输入上方列表中你需要续签的【主域名 Main_Domain】 (例如 bwg.123.xyz): " renew_domain
                if [ -n "$renew_domain" ]; then
                    echo -e "\n${cyan}⏳ 正在向签发机构强制请求续签域名 [ ${renew_domain} ]，请耐心等待...${plain}"
                    
                    # 采用 Acme 官方标准续签语法，并兼容 ECC 证书
                    "$ACME_BIN" --renew -d "$renew_domain" --force --ecc 2>/dev/null
                    if [ $? -ne 0 ]; then
                        # 若 ECC 失败，则尝试普通 RSA 证书续签模式
                        "$ACME_BIN" --renew -d "$renew_domain" --force
                    fi
                    
                    echo -e "\n${cyan}⚡ 续签流程结束！正在联动重启底层代理核心，让新证书瞬间生效...${plain}"
                    systemctl restart sing-box >/dev/null 2>&1
                    systemctl restart xray >/dev/null 2>&1
                    echo -e "${green}✅ 操作完毕！代理服务已满血复活！${plain}"
                else
                    echo -e "${red}❌ 域名输入为空，已取消续签操作。${plain}"
                fi
            else
                echo -e "${yellow}已取消强制续签。${plain}"
            fi
        fi

        echo -e "\n${yellow}------------------------------------------${plain}"
        read -p "👉 按【回车键】返回主菜单..."
        ;;
   27)
        while true; do
            echo -e "\n${blue}=== 🛰️ 星际舰队与跨机容灾中心 ===${plain}"
            echo -e "  ${green}1.${plain} 📦 全域资产一键打包与跨机搬家 (原版数据克隆终极版)"
            echo -e "  ${cyan}2.${plain} 🤝 组建舰队: 配置多机免密互信 (打通专属 SSH 桥梁)"
            echo -e "  ${purple}3.${plain} 🚀 舰队出击: 向所有僚机群发执行指令 (万机齐发)"
            echo -e "  ${red}4.${plain} 🗑️ 解散舰队: 清除本机群发记录与专属密钥 (安全无痕)"
            echo -e "  ${yellow}0.${plain} 返回主菜单"
            echo -e "--------------------------------------------------------"
            read -p "👉 请选择操作 [0-4]: " fleet_choice
            
            case $fleet_choice in
                1)
                    echo -e "\n${blue}--- 🧳 全域资产一键打包与跨机搬家 ---${plain}"
                    echo -e "${yellow}正在启动全频段雷达，扫描系统内的节点配置、面板数据、证书和定时任务...${plain}\n"

                    BACKUP_DIR="/root/velox_backup_$(date +%Y%m%d)"
                    mkdir -p "$BACKUP_DIR"
                    has_data=0

                    # --- 1. 代理脚本与面板全家桶扫描 ---
                    if [ -d "/root/agsbx" ]; then cp -r /root/agsbx "$BACKUP_DIR/"; echo -e "✅ 成功提取 [小钢炮/AnyTLS] 核心配置"; has_data=1; fi
                    if [ -d "/etc/s-box" ]; then cp -r /etc/s-box "$BACKUP_DIR/"; echo -e "✅ 成功提取 [甬哥 sb 脚本] 核心配置"; has_data=1;
                    elif [ -d "/etc/sing-box" ]; then cp -r /etc/sing-box "$BACKUP_DIR/"; echo -e "✅ 成功提取 [甬哥 sb 脚本] 核心配置"; has_data=1; fi
                    if [ -d "/etc/x-ui" ]; then cp -r /etc/x-ui "$BACKUP_DIR/"; echo -e "✅ 成功提取 [X-UI / 3X-UI 面板] 数据库与配置"; has_data=1; fi

                    # --- 2. 核心护盾扫描 ---
                    if [ -d "/root/.acme.sh" ]; then cp -r /root/.acme.sh "$BACKUP_DIR/"; echo -e "✅ 成功提取 [Acme 域名证书资产]"; has_data=1;
                    elif [ -d "$HOME/.acme.sh" ]; then cp -r "$HOME/.acme.sh" "$BACKUP_DIR/"; echo -e "✅ 成功提取 [Acme 域名证书资产]"; has_data=1; fi

                    # --- 3. 自动化任务扫描 ---
                    if crontab -l > "$BACKUP_DIR/crontab_backup.txt" 2>/dev/null; then
                        if [ -s "$BACKUP_DIR/crontab_backup.txt" ]; then echo -e "✅ 成功提取 [系统定时任务 (crontab)]"; has_data=1;
                        else rm -f "$BACKUP_DIR/crontab_backup.txt"; fi
                    fi

                    echo -e "${cyan}--------------------------------------------------------${plain}"
                    
                    # --- 4. 极客专属：自定义目录打包引擎 ---
                    echo -e "💡 ${green}除了以上标准资产，您是否还有其他应用需要一起打包搬家？${plain}"
                    echo -e "${purple}📚 【常见应用路径小抄】 (如需打包，请直接复制下方路径)：${plain}"
                    echo -e "   - ☁️ Alist 网盘数据:  ${yellow}/opt/alist/data${plain}"
                    echo -e "   - 🤖 哪吒探针面板:  ${yellow}/opt/nezha${plain}"
                    echo -e "   - 🐳 Docker 数据卷:  ${yellow}/var/lib/docker/volumes${plain}"
                    echo -e "   - 🌐 Nginx 网站目录:  ${yellow}/var/www/html${plain}"
                    read -p "👉 请输入完整路径 (多个用空格隔开，回车跳过): " custom_paths

                    if [ -n "$custom_paths" ]; then
                        mkdir -p "$BACKUP_DIR/custom_assets"
                        for path in $custom_paths; do
                            if [ -d "$path" ] || [ -f "$path" ]; then
                                cd /
                                rel_path="${path#/}"
                                cp --parents -r "$rel_path" "$BACKUP_DIR/custom_assets/" 2>/dev/null
                                echo -e "📦 成功将自定义路径追加至包裹: ${yellow}$path${plain}"
                                has_data=1
                            else
                                echo -e "⚠️ ${red}找不到指定的文件或目录，已跳过: $path${plain}"
                            fi
                        done
                        cd /root
                    fi

                    if [ "$has_data" -eq 1 ]; then
                        echo -e "\n${cyan}⏳ 正在对包裹进行高强度压缩加密，请耐心等待...${plain}"
                        cd /root
                        tar -czf "Velox_Assets_Backup.tar.gz" "$(basename "$BACKUP_DIR")" >/dev/null 2>&1
                        rm -rf "$BACKUP_DIR"
                        SSH_PORT=$(grep -iE "^Port " /etc/ssh/sshd_config | awk '{print $2}')
                        [ -z "$SSH_PORT" ] && SSH_PORT="22"

                        echo -e "\n${green}🎉 资产克隆打包完毕！您的全域备份文件已生成：${plain}"
                        echo -e "${cyan}📂 文件绝对路径：/root/Velox_Assets_Backup.tar.gz${plain}"
                        
                        # 👇👇👇 把我最经典的保姆级教学加回来了 👇👇👇
                        echo -e "\n${yellow}💡 【跨机无缝恢复教学】 (全系统平台智能适配版)：${plain}"
                        echo -e "--------------------------------------------------------"
                        echo -e "${cyan}👉 方案 A：使用图形化 SSH 软件 (如 FinalShell / Xshell / Termius)${plain}"
                        echo -e "  1. 在软件的文件管理界面，进入 /root 目录，右键下载备份包到电脑桌面。"
                        echo -e "  2. 登录【新机器】，直接将该包拖拽上传到新机器的 /root 目录下。\n"
                        
                        echo -e "${cyan}👉 方案 B：使用纯命令行工具 (CMD / PowerShell / Mac 终端)${plain}"
                        echo -e "  📥 【第一步：下载到本地电脑】打开电脑本地新终端，复制执行 (请修改旧IP)："
                        echo -e "   - [Windows 用户] (存至 D 盘): scp -P $SSH_PORT root@旧VPS的IP:/root/Velox_Assets_Backup.tar.gz D:/"
                        echo -e "   - [Mac/Linux 用户] (存至桌面): scp -P $SSH_PORT root@旧VPS的IP:/root/Velox_Assets_Backup.tar.gz ~/Desktop/"
                        echo -e ""
                        echo -e "  📤 【第二步：上传至新机器】(请修改新IP及端口)："
                        echo -e "   - [Windows 用户]: scp -P 22 D:/Velox_Assets_Backup.tar.gz root@新VPS的IP:/root/"
                        echo -e "   - [Mac/Linux 用户]: scp -P 22 ~/Desktop/Velox_Assets_Backup.tar.gz root@新VPS的IP:/root/"
                        echo -e ""
                        # 👆👆👆 教学部分结束 👆👆👆

                        echo -e "${purple}🔥 【第三步：新机器终极恢复长指令】 (在新 VPS 终端执行)：${plain}"
                        echo -e "  ${cyan}cd /root && tar -xzf Velox_Assets_Backup.tar.gz && BACKUP_NAME=\$(ls -d velox_backup_*) && cp -rf \$BACKUP_NAME/agsbx /root/ 2>/dev/null; cp -rf \$BACKUP_NAME/s-box /etc/ 2>/dev/null; cp -rf \$BACKUP_NAME/sing-box /etc/ 2>/dev/null; cp -rf \$BACKUP_NAME/x-ui /etc/ 2>/dev/null; cp -rf \$BACKUP_NAME/.acme.sh /root/ 2>/dev/null; cp -rf \$BACKUP_NAME/custom_assets/* / 2>/dev/null; crontab \$BACKUP_NAME/crontab_backup.txt 2>/dev/null; rm -rf Velox_Assets_Backup.tar.gz \$BACKUP_NAME; echo -e \"\\n✅ 资产覆盖恢复成功！节点与证书已满血复活！\"${plain}"
                    else
                        echo -e "\n${red}❌ 未提取到任何资产，打包已取消。${plain}"
                        rm -rf "$BACKUP_DIR"
                    fi
                    ;;
                2)
                    echo -e "\n${blue}--- 🤝 组建星际舰队：打通免密互信 ---${plain}"
                    echo -e "💡 原理：本机将生成 Velox 专属独立密钥，并塞入目标机器。不影响您原有的任何 SSH 配置！"
                    
                    # 史诗级修正：使用独立命名的密钥文件，绝不误伤默认的 id_rsa
                    if [ ! -f ~/.ssh/velox_fleet_rsa ]; then
                        echo -e "${yellow}正在为母舰生成专属指挥官兵符 (velox_fleet_rsa)...${plain}"
                        ssh-keygen -t rsa -b 4096 -N "" -f ~/.ssh/velox_fleet_rsa >/dev/null 2>&1
                    fi
                    
                    read -p "👉 请输入目标僚机 IP 地址: " target_ip
                    if [ -n "$target_ip" ]; then
                        read -p "👉 请输入目标机器 SSH 端口 (默认 22): " target_port
                        [ -z "$target_port" ] && target_port=22
                        
                        echo -e "\n${cyan}即将连接目标机器，如果提示 (yes/no) 请手动输入 yes 并回车，随后输入目标机器的 root 密码！${plain}"
                        # 指定使用我们刚生成的专属公钥进行投递
                        ssh-copy-id -i ~/.ssh/velox_fleet_rsa.pub -p "$target_port" "root@$target_ip"
                        
                        if [ $? -eq 0 ]; then
                            echo "$target_ip:$target_port" >> /root/.velox_fleet_nodes.txt
                            sort -u /root/.velox_fleet_nodes.txt -o /root/.velox_fleet_nodes.txt
                            echo -e "${green}✅ 互信打通成功！节点 [$target_ip] 已编入舰队序列！${plain}"
                        else
                            echo -e "${red}❌ 互信失败，请检查 IP、端口或密码是否正确。${plain}"
                        fi
                    fi
                    ;;
                3)
                    if [ ! -s /root/.velox_fleet_nodes.txt ]; then
                        echo -e "\n${red}⚠️ 舰队空空如也！请先使用 [选项 2] 添加僚机！${plain}"
                    else
                        echo -e "\n${blue}--- 🚀 舰队出击：万机齐发 ---${plain}"
                        echo -e "当前已编入舰队的僚机列表："
                        cat /root/.velox_fleet_nodes.txt | awk -F: '{print " - 🟢 IP: "$1" (端口: "$2")"}'
                        echo -e "${cyan}--------------------------------------------------------${plain}"
                        echo -e "💡 你可以输入类似 ${yellow}apt update -y${plain} 或者 ${yellow}reboot${plain}"
                        read -p "👉 请输入要对所有僚机下达的 Linux 指令: " fleet_cmd
                        
                        if [ -n "$fleet_cmd" ]; then
                            echo -e "\n${purple}📡 正在向全频段广播指令...${plain}"
                            for node in $(cat /root/.velox_fleet_nodes.txt); do
                                ip=$(echo "$node" | cut -d: -f1)
                                port=$(echo "$node" | cut -d: -f2)
                                echo -e "\n${yellow}[执行节点 -> $ip] 的回传报告：${plain}"
                                # 强制使用我们的专属私钥进行连接，无视密码校验
                                ssh -i ~/.ssh/velox_fleet_rsa -o ConnectTimeout=10 -o StrictHostKeyChecking=no -p "$port" "root@$ip" "$fleet_cmd"
                            done
                            echo -e "\n${green}🎉 舰队指令群发完毕！${plain}"
                        fi
                    fi
                    ;;
                4)
                    echo -e "\n${blue}--- 🗑️ 解散舰队与痕迹清理 ---${plain}"
                    read -p "⚠️ 此操作将删除本机的群发名单及 Velox 专属兵符，确认解散？(y/n): " confirm_disband
                    if [[ "$confirm_disband" == "y" || "$confirm_disband" == "Y" ]]; then
                        rm -f /root/.velox_fleet_nodes.txt
                        # 只删咱们自己生成的兵符，绝对不动用户的 id_rsa
                        rm -f ~/.ssh/velox_fleet_rsa ~/.ssh/velox_fleet_rsa.pub
                        echo -e "${green}✅ 舰队名单与专属密钥已彻底粉碎，本机已恢复平民身份！${plain}"
                    else
                        echo -e "${yellow}操作已取消。${plain}"
                    fi
                    ;;
                0) break ;;
                *) echo -e "\n${red}❌ 无效输入。${plain}" ;;
            esac
            
            if [[ "$fleet_choice" != "0" ]]; then
                echo ""
                read -p "👉 按【回车键】继续..."
            fi
        done
        ;;
     U|u)
        echo -e "\n${red}=======================================================${plain}"
        echo -e "${red}                ⚠️ 终极卸载与物理粉碎程序                ${plain}"
        echo -e "${red}=======================================================${plain}"
        echo -e "${yellow}💡 提示：此操作将彻底拔除 Velox 面板及其在系统底层留下的所有痕迹。${plain}"
        echo -e "${green}🛡️  放心：您的代理节点 (X-UI/Sing-box) 和 Acme 域名证书将原封不动保留！${plain}\n"
        
        read -p "👉 确定要彻底卸载本面板并【焦土化抹除】所有底层修改吗？(y/n): " confirm_uninstall
        if [[ "$confirm_uninstall" == "y" || "$confirm_uninstall" == "Y" ]]; then
            echo -e "\n${cyan}🚀 正在启动全功率焦土卸载引擎...${plain}"

            # 1. 拆除核心面板与旧版报警组件
            echo -n "1. 正在清理面板本体与关联报警脚本... "
            rm -f /usr/local/bin/velox
            rm -f /usr/local/bin/ssh_tg_alert.sh
            rm -f /usr/local/bin/tg_boot_alert.sh
            sed -i '/ssh_tg_alert.sh/d' /etc/profile
            sed -i '/ssh_tg_alert.sh/d' /etc/bash.bashrc
            systemctl disable --now tg_boot_alert.service >/dev/null 2>&1
            rm -f /etc/systemd/system/tg_boot_alert.service
            systemctl daemon-reload
            echo -e "[${green}已彻底抹除${plain}]"

            # 2. 拆除 Bash 机枪塔
            echo -n "2. 正在物理粉碎 Bash 防爆破机枪塔与击毙日志... "
            systemctl stop velox-defender >/dev/null 2>&1
            systemctl disable velox-defender >/dev/null 2>&1
            rm -f /usr/local/bin/velox-defender.sh
            rm -f /etc/systemd/system/velox-defender.service
            rm -f /tmp/velox_ip_counts.txt
            rm -f /var/log/velox-defender.log
            systemctl daemon-reload
            echo -e "[${green}已彻底抹除${plain}]"

            # 3. 销毁星际舰队兵符
            echo -n "3. 正在销毁星际舰队跨机互信兵符与点名册... "
            rm -f /root/.velox_fleet_nodes.txt
            rm -f ~/.ssh/velox_fleet_rsa ~/.ssh/velox_fleet_rsa.pub
            echo -e "[${green}已彻底抹除${plain}]"

            # 4. 恢复网络底层默认参数 (包含 TCP/UDP 与 9号 BBR)
            echo -n "4. 正在抹除底层网络调优 (TCP/UDP/BBR) 并恢复出厂状态... "
            sed -i '/net.core.rmem_max/d' /etc/sysctl.conf
            sed -i '/net.core.wmem_max/d' /etc/sysctl.conf
            sed -i '/net.ipv4.tcp_rmem/d' /etc/sysctl.conf
            sed -i '/net.ipv4.tcp_wmem/d' /etc/sysctl.conf
            sed -i '/net.ipv4.udp_rmem_min/d' /etc/sysctl.conf
            sed -i '/net.ipv4.udp_wmem_min/d' /etc/sysctl.conf
            
            # 👇 这两行是专门给 9号 BBR 准备的物理粉碎 👇
            sed -i '/net.core.default_qdisc/d' /etc/sysctl.conf
            sed -i '/net.ipv4.tcp_congestion_control/d' /etc/sysctl.conf
            
            # 强行切回出厂默认的 cubic 拥塞控制算法
            sysctl -w net.ipv4.tcp_congestion_control=cubic >/dev/null 2>&1
            sysctl -p > /dev/null 2>&1
            
            DEFAULT_IF=$(ip route get 8.8.8.8 2>/dev/null | awk '{print $5}' | head -n 1)
            [ -n "$DEFAULT_IF" ] && tc qdisc del dev $DEFAULT_IF root >/dev/null 2>&1
            echo -e "[${green}已彻底抹除${plain}]"

            # 5. 清除虚拟内存 (Swap) 释放硬盘
            echo -n "5. 正在检查并清除自定义 Swap 虚拟内存... "
            if grep -q "swapfile" /etc/fstab; then
                swapoff /swapfile >/dev/null 2>&1
                rm -f /swapfile
                sed -i '/swapfile/d' /etc/fstab
                echo -e "[${green}已抹除并释放硬盘空间${plain}]"
            else
                echo -e "[${cyan}未发现 Swap，已跳过${plain}]"
            fi

            # 6. 洗白主机名
            echo -n "6. 正在将 VPS 主机名强行洗白恢复出厂... "
            hostnamectl set-hostname "localhost" >/dev/null 2>&1
            echo -e "[${green}已恢复为 localhost${plain}]"

            # 7. 清理可疑的定时任务残留
            if crontab -l 2>/dev/null | grep -q "api.telegram.org"; then
                echo -n "7. 正在清理旧版 Telegram 报警定时任务... "
                crontab -l 2>/dev/null | grep -v "api.telegram.org" | crontab -
                echo -e "[${green}已彻底抹除${plain}]"
            fi

            # 8. Fail2Ban 强拆询问
            if command -v fail2ban-client >/dev/null 2>&1; then
                echo -e "\n${yellow}⚠️ 检测到系统中安装了 Fail2Ban 工业级防御装甲。${plain}"
                read -p "👉 是否一并【彻底强拆】Fail2Ban？(y/n): " remove_f2b
                if [[ "$remove_f2b" == "y" || "$remove_f2b" == "Y" ]]; then
                    echo -n "正在全网追剿 Fail2Ban 及其依赖残留... "
                    systemctl stop fail2ban >/dev/null 2>&1
                    systemctl disable fail2ban >/dev/null 2>&1
                    if command -v apt-get >/dev/null 2>&1; then
                        apt-get remove --purge fail2ban -y >/dev/null 2>&1
                        apt-get autoremove -y >/dev/null 2>&1
                    elif command -v yum >/dev/null 2>&1; then
                        yum remove fail2ban -y >/dev/null 2>&1
                    elif command -v dnf >/dev/null 2>&1; then
                        dnf remove fail2ban -y >/dev/null 2>&1
                    fi
                    rm -rf /etc/fail2ban
                    echo -e "[${green}已彻底抹除${plain}]"
                else
                    echo -e "${cyan}已跳过 Fail2Ban 卸载，系统防盗门继续服役。${plain}"
                fi
            fi

            echo -e "\n${green}🎉 卸载完毕！Velox 面板已事了拂衣去，您的系统已恢复至极其纯净的【出厂状态】！${plain}"
            echo -e "${purple}江湖再见，祝您折腾愉快！🚀${plain}\n"
            exit
        else
            echo -e "\n${yellow}已取消卸载，即将返回主菜单...${plain}"
            sleep 1
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
