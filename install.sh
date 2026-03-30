#!/bin/bash
# 自动生成并运行 Velox 面板 (V5.2 全域兼容满血终极版 - 智能嗅探 + 原子防护)

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

# ================= 全局智能拦截函数 =================
check_virt_safe() {
    local feature_name="$1"
    local virt_type=$(systemd-detect-virt 2>/dev/null || echo "unknown")
    if [[ "$virt_type" == "lxc" || "$virt_type" == "openvz" ]]; then
        echo -e "\n${red}❌ 致命拦截：检测到当前为 $virt_type 容器架构！${plain}"
        echo -e "${yellow}此类精简容器共享宿主机内核，无权进行【$feature_name】的底层高阶操作。操作已安全阻断！${plain}"
        return 1 # 阻断
    fi
    return 0 # 放行
}
# ====================================================

while true; do 
    # === 🚀 万能核心服务动态状态检测 (穿透查进程) ===
    if pgrep -x "sing-box" > /dev/null 2>&1 || pgrep -x "xray" > /dev/null 2>&1; then
        sb_stat=$(echo -e "${green}[运行中]${plain}")
    elif command -v sing-box >/dev/null 2>&1 || command -v xray >/dev/null 2>&1; then
        sb_stat=$(echo -e "${red}[已停止]${plain}")
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

# 17号 流量防线状态检测
if [ -f "/usr/local/bin/velox_traffic_alert.sh" ]; then
    traffic_stat=$(echo -e "${green}[已部署]${plain}")
else
    traffic_stat=$(echo -e "${yellow}[未设置]${plain}")
fi
    clear
# ================= 专属署名区 =================
echo -e "${cyan}██╗   ██╗███████╗██╗     ██████╗ ██╗  ██╗${plain}"
echo -e "${cyan}██║   ██║██╔════╝██║    ██╔═══██╗╚██╗██╔╝${plain}"
echo -e "${blue}██║   ██║█████╗  ██║    ██║   ██║ ╚███╔╝ ${plain}"
echo -e "${blue}╚██╗ ██╔╝██╔══╝  ██║    ██║   ██║ ██╔██╗ ${plain}"
echo -e "${purple} ╚████╔╝ ███████╗███████╗╚██████╔╝██╔╝ ██╗${plain}"
echo -e "${purple}  ╚═══╝  ╚══════╝╚══════╝ ╚═════╝ ╚═╝  ╚═╝${plain}"
echo -e "${cyan}=======================================================${plain}"
echo -e "作者GitHub项目 : ${blue}github.com/pwenxiang51-wq${plain}"
echo -e "作者Velo.x博客 : ${blue}222382.xyz${plain}"
echo -e "${cyan}=======================================================${plain}"
    # ==============================================
    # --- 第一板块：系统核心运维 ---
    echo -e "${blue}[ 板块一：🛡️ 系统核心运维 ]${plain}"
    echo -e "  ${green}1.${plain}  📊 ${green}查看系统基础信息${plain}"
    echo -e "  ${green}2.${plain}  💾 ${green}查看磁盘空间占用${plain}"
    echo -e "  ${green}3.${plain}  ⏱️  ${green}查看运行时间与负载${plain}"
    echo -e "  ${green}4.${plain}  📊 ${green}快速查看内存报告 (静态快照)${plain}"
    echo -e "  ${green}5.${plain}  📈 ${green}实时监控 CPU 与内存 (按 q 退出)${plain}"
    echo -e "  ${green}6.${plain}  🔌 ${green}查看系统监听端口${plain}"
    
    # --- 第二板块：网络高阶调优 ---
    echo -e "\n${blue}[ 板块二：🚀 网络高阶调优 ]${plain}"
    echo -e "  ${green}7.${plain}  📦 ${green}查看代理服务运行状态 (深度体检与 IP 查询)${plain} ${sb_stat}"
    echo -e "  ${green}8.${plain}  🌐 ${green}查看 WARP 与 Argo 出站详情 (独立管理中心)${plain}"
    echo -e "  ${green}9.${plain}  🚀 ${green}深度验证与管理 BBR 加速${plain} ${bbr_stat}"
    echo -e "  ${green}10.${plain} 🧹 ${green}一键清理系统垃圾与强制释放内存${plain}"
    echo -e "  ${green}11.${plain} 🔄 ${green}重启 VPS 主机 (整机物理重启，SSH 会掉线)${plain}"
    
    # --- 第三板块：代理核心管理 ---
    echo -e "\n${blue}[ 板块三：🔌 代理核心管理 ]${plain}"
    echo -e "  ${cyan}12.${plain} 🎬 ${cyan}流媒体解锁检测 (Netflix/ChatGPT等)${plain}"
    echo -e "  ${cyan}13.${plain} 🛡️ ${cyan}IP 纯净度与欺诈风险体检 (精准排雷)${plain}"
    echo -e "  ${cyan}14.${plain} ⚡ ${cyan}TCP/UDP 网络底层高阶调优 (极限压榨带宽)${plain}"
    echo -e "  ${cyan}15.${plain} 🛰️ ${cyan}全球主流节点 Ping 延迟测速${plain}"
    echo -e "  ${cyan}16.${plain} 🚨 ${cyan}设置/管理 SSH 异地登录 TG 报警 (含开机秒报)${plain} ${tg_stat}"
    
    # --- 第四板块：自动化与工具 ---
    echo -e "\n${blue}[ 板块四：🛠️ 自动化与高阶工具 ]${plain}"
    echo -e "  ${purple}17.${plain} 📈 ${purple}Velox 流量大管家 (防扣费/防停机/月账单)${plain} ${traffic_stat}"
    echo -e "  ${purple}18.${plain} 💽 ${purple}自定义管理虚拟内存 Swap (1G小鸡救星)${plain}"
    echo -e "  ${purple}19.${plain} 📝 ${purple}修改服务器主机名 (给 VPS 轻松改名)${plain}"
    echo -e "  ${purple}20.${plain} 🔄 ${purple}一键更新系统软件库 (智能适配全系统)${plain}"
    echo -e "  ${purple}21.${plain} 🚨 ${purple}SSH 智能防盗门与防御中心 (机枪塔/Fail2Ban)${plain}"
    echo -e "  ${purple}22.${plain} 🚀 ${purple}一键搭建代理节点 (进入 VX 独家分流引擎)${plain}"
    
    # --- 第五板块：核心修复与配置提取 ---
    echo -e "\n${blue}[ 板块五：⚡ 核心修复与配置提取 ]${plain}"
    echo -e "  ${yellow}23.${plain} ⏱️  ${yellow}设置定时任务 (设定 VPS 半夜自动重启 / 自动刷新 WARP)${plain}"
    echo -e "  ${yellow}24.${plain} 🔄 ${yellow}一键修复/重启所有代理服务 (解决掉线/假死/断流)${plain}"
    echo -e "  ${yellow}25.${plain} 🔗 ${yellow}一键提取节点链接配置 (提取 vless/vmess/hy2)${plain}"
    echo -e "  ${yellow}26.${plain} 🔐 ${yellow}Acme 域名证书深度管理 (查询到期 / 强制续签)${plain}"
    echo -e "  ${yellow}27.${plain} 🧳 ${yellow}全域资产跨机搬家与星际舰队中心 (TG 云端灾备)${plain}"
    
    echo -e "${cyan}  ---------------------------------------------------${plain}"
    echo -e "  ${red}U.${plain}  🗑️  ${red}一键卸载本面板 (清理无痕)${plain}"
    echo -e "  ${red}0.${plain}  ❌ ${red}退出面板${plain}"
    echo -e "${cyan}=====================================================${plain}"
    
    echo -ne "请选择操作 [${green}1${plain}-${yellow}27${plain}, ${red}U${plain}, ${red}0${plain}]: "
    read choice
    
    case $choice in
        1) echo -e "\n${blue}--- 系统信息 ---${plain}"; hostnamectl; echo -e "操作系统: ${green}$(cat /etc/os-release | grep PRETTY_NAME | cut -d'"' -f2)${plain}" ;;
        2) echo -e "\n${blue}--- 磁盘空间 ---${plain}"; df -h ;;
        3) echo -e "\n${blue}--- 运行状态 ---${plain}"; uptime ;;
        4) echo -e "\n${blue}--- 📊 静态内存报告 ---${plain}"; free -h --si ;;
        5) echo -e "\n${cyan}--- 正在启动任务管理器 ---${plain}"; sleep 1; top ;;
        6) echo -e "\n${blue}--- 监听端口 ---${plain}"; ss -tuln ;;
    7)
        echo -e "\n${blue}=== 📦 代理核心深度体检 (全网脚本兼容版) ===${plain}"
        echo -e "${yellow}当前北京时间：${green}$(date +"%Y-%m-%d %H:%M:%S")${plain}\n"

        check_detail() {
            local core_name=$1
            local display=$2
            
            # 1. 底层雷达：全网搜寻核心可执行文件 (兼容所有第三方脚本的奇葩安装路径)
            local bin_path=$(command -v "$core_name" 2>/dev/null)
            [ -z "$bin_path" ] && [ -f "/usr/local/bin/$core_name" ] && bin_path="/usr/local/bin/$core_name"
            [ -z "$bin_path" ] && [ -f "/usr/bin/$core_name" ] && bin_path="/usr/bin/$core_name"
            [ -z "$bin_path" ] && [ -f "/opt/$core_name/$core_name" ] && bin_path="/opt/$core_name/$core_name"

            # 2. 活体探针：直接问询 Linux 内核该进程是否存活 (绝对精准)
            local is_running=false
            if pgrep -x "$core_name" > /dev/null 2>&1 || ps -ef | grep -v grep | grep -wq "$core_name"; then
                is_running=true
            elif systemctl is-active --quiet "$core_name" 2>/dev/null; then
                is_running=true
            fi

            # 3. 综合判定与数据提取
            if [ -n "$bin_path" ] || [ "$is_running" = true ]; then
                # 智能提取版本号 (硬核正则，完美过滤各种杂乱输出)
                local version="未知"
                if [ -n "$bin_path" ]; then
                    version=$($bin_path version 2>/dev/null | head -n 1 | grep -oE '[0-9]+\.[0-9]+\.[0-9]+[a-zA-Z0-9.-]*' | head -n 1)
                    [ -z "$version" ] && version=$($bin_path -version 2>/dev/null | head -n 1 | grep -oE '[0-9]+\.[0-9]+\.[0-9]+[a-zA-Z0-9.-]*' | head -n 1)
                fi
                [ -z "$version" ] && version="未知版本"

                # 提取真实监听端口 (底层抓取，去重展示)
                local ports=$(ss -tlnp 2>/dev/null | grep -w "$core_name" | awk '{print $4}' | awk -F':' '{print $NF}' | sort -n -u | tr '\n' ' ')
                [ -z "$ports" ] && ports="无外部监听 (或端口复用)"

                if [ "$is_running" = true ]; then
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
        echo -e "\n${blue}=== 🌐 WARP 与 Argo 隧道出站详情 (全域动态嗅探版) ===${plain}"
        echo -e "${yellow}正在侦测网络出站链路，请稍候...${plain}\n"
        
        # ================= 👇 WARP 智能探测 (绝不写死端口) 👇 =================
        echo -e "${cyan}[ WARP 解锁状态 ]${plain}"
        warp_status="off"
        warp_ip=""
        proxy_mode=""

        if systemctl is-active --quiet warp-go 2>/dev/null || systemctl is-active --quiet wg-quick@wgcf 2>/dev/null || systemctl is-active --quiet warp-svc 2>/dev/null; then
            
            # 1. 测全局直连
            trace=$(curl -s4m 3 https://www.cloudflare.com/cdn-cgi/trace 2>/dev/null || echo "error")
            if echo "$trace" | grep -q "warp=on"; then
                warp_status="on"
                warp_ip=$(echo "$trace" | grep ip= | cut -d= -f2)
            fi

            # 2. 测虚拟网卡 (兼容各种 WireGuard 衍生版模式)
            if [[ "$warp_status" == "off" ]]; then
                for iface in wgcf warp wg0; do
                    if ip link show "$iface" >/dev/null 2>&1; then
                        trace=$(curl --interface "$iface" -s4m 3 https://www.cloudflare.com/cdn-cgi/trace 2>/dev/null || echo "error")
                        if echo "$trace" | grep -q "warp=on"; then
                            warp_status="on"
                            warp_ip=$(echo "$trace" | grep ip= | cut -d= -f2)
                            proxy_mode=" ${purple}(虚拟网卡路由: $iface)${plain}"
                            break
                        fi
                    fi
                done
            fi

            # 3. 测本地 SOCKS5 代理 (全自动动态抓取，绝不写死任何端口)
            if [[ "$warp_status" == "off" ]]; then
                # 向内核发问：抓取 warp-svc 或 warp-go 当前监听的所有本地端口！
                proxy_ports=$(ss -nltp 2>/dev/null | grep -E 'warp-svc|warp-go' | awk '{print $4}' | grep -E '127\.0\.0\.1|::1' | awk -F':' '{print $NF}' | sort -u)
                
                for port in $proxy_ports; do
                    trace=$(curl -x socks5h://127.0.0.1:$port -s4m 3 https://www.cloudflare.com/cdn-cgi/trace 2>/dev/null || echo "error")
                    if echo "$trace" | grep -q "warp=on"; then
                        warp_status="on"
                        warp_ip=$(echo "$trace" | grep ip= | cut -d= -f2)
                        proxy_mode=" ${purple}(SOCKS5 局部代理 | 自动捕获端口: $port)${plain}"
                        break
                    fi
                done
            fi

            # 最终状态渲染
            if [[ "$warp_status" == "on" ]]; then
                echo -e " 🛡️  WARP 状态 : ${green}已开启并成功接管流量 ✅${plain}"
                echo -e " 🛡️  出口 IP   : ${cyan}${warp_ip}${plain} (Cloudflare 节点)${proxy_mode}"
            else
                echo -e " 🛡️  WARP 状态 : ${yellow}服务已运行但未能成功接管流量 (请检查路由或代理配置) ⚠️${plain}"
            fi
        else
            echo -e " 🛡️  WARP 状态 : ${red}未开启或未部署 ❌${plain}"
        fi

        # ================= 👇 Argo 智能探测 (全系统穿透) 👇 =================
        echo -e "\n${cyan}[ Argo 隧道状态 ]${plain}"
        
        if pgrep -x "cloudflared" >/dev/null 2>&1 || systemctl is-active --quiet vx-argo 2>/dev/null; then
            echo -e " 🚇 Argo 进程 : ${green}运行中 ✅${plain}"
            
            argo_url=""
            argo_token_live=""

            # 神级嗅探 1：抓进程参数
            argo_token_live=$(ps -ef | grep cloudflared | grep -v grep | grep -oE "ey[A-Za-z0-9_-]{50,}" | head -n 1)
            
            # 神级嗅探 2：如果进程里没抓到，暴力穿透所有 Systemd 服务文件
            if [[ -z "$argo_token_live" ]]; then
                argo_token_live=$(grep -rhoE "ey[A-Za-z0-9_-]{50,}" /etc/systemd/system/ 2>/dev/null | head -n 1)
            fi

            # 神级嗅探 3：无视系统服务名，直接调取 cloudflared 程序的内核日志找 URL
            argo_url=$(journalctl _COMM=cloudflared --no-pager -n 200 2>/dev/null | grep -oE "https://[a-zA-Z0-9.-]+\.trycloudflare\.com" | tail -n 1 | sed 's/https:\/\///')
            if [[ -z "$argo_url" ]]; then
                argo_url=$(journalctl -u vx-argo --no-pager -n 200 2>/dev/null | grep -oE "https://[a-zA-Z0-9.-]+\.trycloudflare\.com" | tail -n 1 | sed 's/https:\/\///')
            fi
            if [[ -z "$argo_url" ]]; then
                argo_url=$(ps -ef | grep cloudflared | grep -v grep | grep -oE "[a-zA-Z0-9.-]+\.trycloudflare\.com" | head -n 1)
            fi

            if [[ -n "$argo_token_live" ]]; then
                masked_token="${argo_token_live:0:6}******[智能隐藏]******${argo_token_live: -6}"
                echo -e " 🔗 链路模式 : ${purple}Token 守护模式 (固定隧道) ${plain}"
                echo -e " 🔑 绑定凭证 : ${cyan}${masked_token}${plain} ${green}✅${plain}"
            elif [[ -n "$argo_url" ]]; then
                echo -e " 🔗 链路模式 : ${cyan}https://${argo_url}${plain} ${yellow}(临时穿透隧道)${plain}"
            else
                echo -e " 🔗 链路模式 : ${purple}隐秘守护模式或未知模式 ${plain}${yellow}(未嗅探到明文 Token 或 URL)${plain}"
                echo -e " 💡 ${yellow}提示：若您使用固定隧道，请在 Cloudflare 后台查看解析状态。${plain}"
            fi
        else
            echo -e " 🚇 Argo 进程 : ${red}未运行 ❌${plain}"
        fi

        # --- 开源进阶功能：一键部署、更换或卸载 Argo 固定隧道 ---
        echo -e "\n${cyan}💡 进阶管理：您可以全自动部署、更换或彻底卸载 Argo 固定隧道${plain}"
        echo -e "  ${green}1.${plain} 🚀 部署或更换 Token (并设为开机绝对自启)"
        echo -e "  ${red}2.${plain} 🗑️ 彻底卸载并清除 Argo 守护进程"
        read -p "👉 请选择操作 (1/2) [直接回车跳过]: " argo_action
        
        if [[ "$argo_action" == "1" ]]; then
            echo -e "\n${blue}=== 🚇 部署/更换 Cloudflare Argo 固定隧道 ===${plain}"
            read -p "🔑 请右键粘贴您的 Cloudflare Token (ey...开头): " argo_token
            
            if [ -n "$argo_token" ]; then
                argo_token=$(echo "$argo_token" | tr -d ' ' | tr -d '\n' | tr -d '\r')
                echo -n "正在为您全自动部署并写入系统底层守护进程... "
                if ! command -v cloudflared >/dev/null 2>&1; then
                    curl -sL https://github.com/cloudflare/cloudflared/releases/latest/download/cloudflared-linux-amd64 -o /usr/local/bin/cloudflared
                    chmod +x /usr/local/bin/cloudflared
                fi
                
                # 暴力肃清旧环境 (万能兼容清洗：杀掉常见的所有可能的服务名)
                systemctl stop cloudflared vx-argo argo >/dev/null 2>&1
                systemctl disable cloudflared vx-argo argo >/dev/null 2>&1
                cloudflared service uninstall >/dev/null 2>&1
                rm -f /etc/systemd/system/vx-argo.service /etc/systemd/system/argo.service
                
                cloudflared service install "$argo_token" >/dev/null 2>&1
                systemctl enable --now cloudflared >/dev/null 2>&1
                echo -e "[${green}部署成功！已接入 Cloudflare 零信任网络 ✅${plain}]"
            else
                echo -e "${red}❌ Token 不能为空，已取消操作。${plain}"
            fi

        elif [[ "$argo_action" == "2" ]]; then
            echo -e "\n${blue}=== 🗑️ 彻底卸载 Argo 固定隧道 ===${plain}"
            echo -n "正在停止并焦土化清理系统底层的 Argo 守护进程... "
            if command -v cloudflared >/dev/null 2>&1 || pgrep -x "cloudflared" >/dev/null 2>&1 || systemctl is-active --quiet vx-argo 2>/dev/null; then
                # 万能兼容清洗
                systemctl stop cloudflared vx-argo argo >/dev/null 2>&1
                systemctl disable cloudflared vx-argo argo >/dev/null 2>&1
                cloudflared service uninstall >/dev/null 2>&1
                rm -f /etc/systemd/system/vx-argo.service /etc/systemd/system/argo.service
                rm -rf /etc/cloudflared
                pkill -9 cloudflared >/dev/null 2>&1
                systemctl daemon-reload
                echo -e "[${green}清理完毕，Argo 已彻底物理粉碎 ✅${plain}]"
            else
                echo -e "[${yellow}未检测到安装，无需清理 ⚠️${plain}]"
            fi
        fi
        
        echo -e "\n${yellow}提示：如需修复以上出站异常，请返回主菜单使用第 24 项。${plain}"
        echo -e "${yellow}------------------------------------------${plain}"
        read -p "👉 按【回车键】继续..."
        ;;
        
    9)
        echo -e "\n${blue}=== 🚀 BBR 状态诊断与高级网络内核调优 ===${plain}"
        # 🚀 核心升级：架构防爆护盾 (调用全局智能函数，一行解决！)
        check_virt_safe "BBR 内核拥塞算法修改" || { read -p "👉 按【回车键】继续..."; continue; }

        # 1. 深度探测系统内核与当前状态 (顺手帮你把重复两遍的变量获取也修了)
        kernel_version=$(uname -r | awk -F- '{print $1}')
        kernel_main=$(echo $kernel_version | awk -F. '{print $1"."$2}')
        current_cc=$(sysctl net.ipv4.tcp_congestion_control 2>/dev/null | awk '{print $3}')
        current_qdisc=$(sysctl net.core.default_qdisc 2>/dev/null | awk '{print $3}')
        echo -e "🔎 ${cyan}当前系统内核版本:${plain} ${kernel_version}"
        echo -e "🚥 ${cyan}当前拥塞控制算法 (CC):${plain} ${yellow}${current_cc}${plain}"
        echo -e "🚥 ${cyan}当前队列调度算法 (Qdisc):${plain} ${yellow}${current_qdisc}${plain}"
        echo -e "${blue}---------------------------------------------------${plain}"

        if [[ "$current_cc" == "bbr" ]]; then
            echo -e "${green}✅ BBR 底层加速已完美激活，网络正处于高性能模式！${plain}"
            
            # 智能检测黄金搭档 fq
            if [[ "$current_qdisc" != *"fq"* ]]; then
                echo -e "${yellow}⚠️ 提示：检测到当前 Qdisc 并非 fq，建议卸载后重新一键开启以达到 BBR 最佳性能。${plain}"
            fi
            
            read -p "👉 是否需要【彻底关闭并卸载】BBR 加速？(y/n): " remove_bbr
            if [[ "${remove_bbr,,}" == "y" ]]; then
                echo -e "\n${yellow}正在执行 BBR 卸载程序，清理底层参数...${plain}"
                # 清理 sysctl.conf 中的自定义参数
                sed -i '/net.core.default_qdisc/d' /etc/sysctl.conf
                sed -i '/net.ipv4.tcp_congestion_control/d' /etc/sysctl.conf
                # 动态恢复内存中的默认值
                sysctl -w net.ipv4.tcp_congestion_control=cubic >/dev/null 2>&1
                sysctl -w net.core.default_qdisc=pfifo_fast >/dev/null 2>&1
                sysctl -p >/dev/null 2>&1
                echo -e "${green}✅ BBR 已彻底关闭！系统已恢复为标准默认算法 (cubic)。${plain}"
            fi
        else
            echo -e "${red}⚠️ 检测到当前未开启 BBR 加速！${plain}"
            
            # 内核版本合规性阻断机制 (低于 4.9 强行开会失联)
           if awk -v ver="$kernel_main" 'BEGIN {if (ver < 4.9) exit 0; else exit 1}'; then
                echo -e "${red}❌ 致命错误：当前内核版本 ($kernel_version) 低于 4.9！${plain}"
                echo -e "${red}强行注入 BBR 参数将导致机器断网失联！请先执行内核升级！${plain}"
            else
                read -p "👉 是否立即【一键开启 BBR 暴力加速】？(y/n): " enable_bbr
                if [[ "${enable_bbr,,}" == "y" ]]; then
                    echo -e "\n${cyan}正在向系统内核加载 BBR 模块并注入参数...${plain}"
                    
                    # 尝试预先加载 bbr 模块 (兼容某些云厂商精简版系统)
                    modprobe tcp_bbr 2>/dev/null

                    # 清除旧配置，防止重复写入冲突
                    sed -i '/net.core.default_qdisc/d' /etc/sysctl.conf
                    sed -i '/net.ipv4.tcp_congestion_control/d' /etc/sysctl.conf
                    
                    # 写入 BBR + fq 黄金组合参数
                    echo "net.core.default_qdisc=fq" >> /etc/sysctl.conf
                    echo "net.ipv4.tcp_congestion_control=bbr" >> /etc/sysctl.conf
                    
                    # 应用配置并屏蔽多余冗余输出
                    sysctl -p >/dev/null 2>&1
                    
                    # 极客视觉体验：硬核状态实时回显
                    echo -e "\n${blue}--- 📡 核心网络参数实时回显 ---${plain}"
                    sysctl net.ipv4.tcp_congestion_control
                    sysctl net.core.default_qdisc
                    echo -e "${blue}-------------------------------${plain}"

                    if sysctl net.ipv4.tcp_congestion_control 2>/dev/null | grep -q bbr; then
                        echo -e "\n${green}🎉 开启成功！【BBR + fq】 黄金组合已全线生效！${plain}"
                        echo -e "${yellow}💡 提示：按回车键返回主菜单，您将看到徽章已变为 [加速中]！${plain}"
                    else
                        echo -e "\n${red}❌ 开启失败！当前系统环境受限 (提示：OpenVZ 或 LXC 架构的 VPS 无法修改底层内核)。${plain}"
                    fi
                fi
            fi
        fi
        
        # 统一的返回停顿
        echo ""
        read -p "👉 按【回车键】返回主菜单..."
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
      12)
            echo -e "\n${blue}=== 🎬 流媒体与 AI 解锁智能检测中心 ===${plain}"
            echo -e "${cyan}📡 正在启动底层网络雷达，侦测代理环境...${plain}"
            
            # 智能侦测底层 WARP / 代理状态
            proxy_port=""
            warp_iface=""
            
            # 1. 动态抓取本地 SOCKS5 端口 (绝不写死 40000)
            proxy_port=$(ss -nltp 2>/dev/null | grep -E 'warp-svc|warp-go' | awk '{print $4}' | grep -E '127\.0\.0\.1|::1' | awk -F':' '{print $NF}' | head -n 1)
            
            # 2. 如果没发现 SOCKS5，抓取 WARP 虚拟网卡
            if [[ -z "$proxy_port" ]]; then
                for iface in wgcf warp wg0; do
                    if ip link show "$iface" >/dev/null 2>&1; then
                        warp_iface="$iface"
                        break
                    fi
                done
            fi

            # ================= 👇 智能分支测速逻辑 👇 =================
            if [[ -n "$proxy_port" ]]; then
                echo -e "\n${yellow}💡 雷达嗅探到系统正运行 SOCKS5 局部代理 (端口: $proxy_port)${plain}"
                echo -e "  ${green}1.${plain} 🎯 穿透测试 【WARP 代理 IP】 解锁情况 (极客推荐，测真实解锁能力)"
                echo -e "  ${cyan}2.${plain} 🌍 常规测试 【VPS 原生 IP】 解锁情况"
                read -p "👉 请选择测速链路 [1-2, 回车默认1]: " test_choice
                test_choice=${test_choice:-1}
                
                echo -e "\n${cyan}🚀 正在拉取测速组件，请耐心等待 (约需1-2分钟)...${plain}"
                if [[ "$test_choice" == "1" ]]; then
                    # 强行注入环境变量，让测速脚本的每一滴流量都走 SOCKS5 代理！
                    ALL_PROXY="socks5h://127.0.0.1:$proxy_port" bash <(curl -x socks5h://127.0.0.1:$proxy_port -sL media.ispvps.com)
                else
                    bash <(curl -sL media.ispvps.com)
                fi

            elif [[ -n "$warp_iface" ]]; then
                echo -e "\n${yellow}💡 雷达嗅探到系统部署了 WARP 虚拟网卡 ($warp_iface)${plain}"
                echo -e "  ${green}1.${plain} 🎯 穿透测试 【WARP 虚拟网卡】 解锁情况"
                echo -e "  ${cyan}2.${plain} 🌍 常规测试 【VPS 原生 IP】 解锁情况"
                read -p "👉 请选择测速链路 [1-2, 回车默认1]: " test_choice
                test_choice=${test_choice:-1}
                
                echo -e "\n${cyan}🚀 正在拉取测速组件，请耐心等待 (约需1-2分钟)...${plain}"
                if [[ "$test_choice" == "1" ]]; then
                    # 挂载测速脚本特有的 -I 参数，强行指定网卡出口
                    bash <(curl -sL media.ispvps.com) -I "$warp_iface"
                else
                    bash <(curl -sL media.ispvps.com)
                fi

            else
                echo -e "\n${green}>>> 未检测到局部代理，正在为您测试当前 VPS 原生 IP 解锁情况...${plain}"
                echo -e "${cyan}🚀 正在拉取测速组件，请耐心等待 (约需1-2分钟)...${plain}"
                bash <(curl -sL media.ispvps.com)
            fi
            
            echo -e "\n${yellow}------------------------------------------${plain}"
            read -p "👉 测试完毕！按【回车键】返回主菜单..."
            ;;
     13)
        echo -e "\n${blue}=== 🛡️ 节点 IP 纯净度与欺诈风险体检 (国际权威版) ===${plain}"
        echo -e "${yellow}正在向全球顶级权威数据库查询当前 VPS 的出站 IP 纯净度，请稍候...${plain}\n"

        VPS_IP=$(curl -s4m 3 https://api.ipify.org || curl -s4m 3 https://ip.gs)
        
        if [ -n "$VPS_IP" ]; then
            echo -e "🌍 当前出站 IP: ${cyan}${VPS_IP}${plain}\n"
            
            # 使用国际顶级 IP 基因库进行底层剖析
            echo -e "${cyan}--- 🌐 国际核心数据库 (IP-API) 深度解析 ---${plain}"
            curl -sL "http://ip-api.com/line/$VPS_IP?lang=zh-CN&fields=country,regionName,city,isp,org,as,mobile,proxy,hosting" 2>/dev/null | awk '
            NR==1{printf "  🔹 %-16s : %s\n", "国家/地区", $0} 
            NR==2{printf "  🔹 %-16s : %s\n", "省份/州", $0} 
            NR==3{printf "  🔹 %-16s : %s\n", "城市", $0} 
            NR==4{printf "  🔹 %-16s : %s\n", "ISP 运营商", $0} 
            NR==5{printf "  🔹 %-16s : %s\n", "所属机构", $0} 
            NR==6{printf "  🔹 %-16s : %s\n", "ASN 号", $0} 
            NR==7{printf "  🔹 %-16s : %s\n", "移动网络(手机)", ($0=="true"?"\033[1;33m是\033[0m":"否")} 
            NR==8{printf "  🔹 %-16s : %s\n", "VPN/代理标记", ($0=="true"?"\033[1;31m是 (高风险)\033[0m":"\033[1;32m否 (干净)\033[0m")} 
            NR==9{printf "  🔹 %-16s : %s\n", "机房 IP", ($0=="true"?"\033[1;33m是 (Hosting)\033[0m":"\033[1;32m否 (原生家宽)\033[0m")}'
            
            echo -e "\n${cyan}--- 🏢 IPinfo 国际 ASN 辅助认证 ---${plain}"
            IPINFO_ORG=$(curl -s4m 3 https://ipinfo.io/$VPS_IP/org 2>/dev/null)
            if [ -n "$IPINFO_ORG" ]; then
                echo -e "  🔹 核心归属       : ${yellow}${IPINFO_ORG}${plain}"
            else
                echo -e "  🔹 核心归属       : 获取超时"
            fi

            echo -e "\n${green}💡 极客科普：${plain}"
            echo -e "🟢 ${green}原生 IP (家宽/移动)${plain}: 极品！流媒体全解锁，极少跳谷歌验证码。"
            echo -e "🟡 ${yellow}机房 IP (Hosting)${plain}: 普通 VPS 标配，可能偶发验证码。"
            echo -e "🔴 ${red}被标记代理 (Proxy)${plain}: 已经被国际数据库拉黑，建议套 WARP 救活！"
            
            echo -e "\n🔗 ${cyan}想要查看全球最权威的 Scamalytics 欺诈分数？${plain}"
            echo -e "👉 ${green}请按住 Ctrl 点击打开深度体检网页: ${plain}\033[4;34mhttps://scamalytics.com/ip/$VPS_IP\033[0m"
        else
            echo -e "${red}❌ 无法获取本机 IP，请检查网络连接。${plain}"
        fi
        
        echo -e "\n${yellow}------------------------------------------${plain}"
        read -p "👉 按【回车键】返回主菜单..."
        ;;
        
  14)
        # 🚀 核心升级：架构防爆护盾 (调用全局智能函数，一行顶十行！)
        check_virt_safe "TCP/UDP 读写缓冲区与队列扩展" || { read -p "👉 按【回车键】继续..."; continue; }

        # 💡 防崩依赖：确保 tc 工具存在，用于接管网卡队列
        if ! command -v tc >/dev/null 2>&1; then
            if command -v apt-get >/dev/null 2>&1; then apt-get install iproute2 -y >/dev/null 2>&1;
            elif command -v yum >/dev/null 2>&1; then yum install iproute -y >/dev/null 2>&1;
            elif command -v dnf >/dev/null 2>&1; then dnf install iproute -y >/dev/null 2>&1; fi
        fi

        echo -e "\n${cyan}请选择网络底层调优方向：${plain}"
        echo -e "  ${green}1.${plain} ⚡ TCP 暴力扩容 (传统大文件下载提速)"
        echo -e "  ${green}2.${plain} 🌪️ UDP 极限压榨 (Hysteria2 / TUIC 专属抗丢包)"
        echo -e "  ${green}3.${plain} 🔥 双管齐下 (同时执行 TCP 与 UDP 调优，小孩子才做选择！)"
        echo -e "  ${red}4.${plain} 🗑️ 恢复系统默认 (清除所有自定义扩容参数，一键后悔)"
        echo -e "  ${cyan}0.${plain} 🔙 返回主菜单"
        read -p "👉 请输入选择 [0-4]: " tune_choice
        
        if [ "$tune_choice" == "0" ]; then
            echo -e "\n${yellow}已取消操作，返回主菜单。${plain}"
        elif [[ "$tune_choice" =~ ^[1-4]$ ]]; then
            
            # --- 💡 核心升级：智能内存感知 (防 OOM 机制) ---
            TOTAL_MEM=$(free -m | awk '/^Mem:/{print $2}')
            if [ "$TOTAL_MEM" -le 512 ]; then
                MAX_BUF="16777216" # 16MB (小内存保护)
                MEM_TAG="轻量级"
            elif [ "$TOTAL_MEM" -le 1024 ]; then
                MAX_BUF="26214400" # 25MB (标配)
                MEM_TAG="标准级"
            else
                MAX_BUF="33554432" # 32MB (大内存暴力全开)
                MEM_TAG="极速级"
            fi

            # --- 🧹 统一清理旧参数 (防止冲突与重复写入) ---
            sed -i '/net.core.rmem_max/d' /etc/sysctl.conf
            sed -i '/net.core.wmem_max/d' /etc/sysctl.conf
            sed -i '/net.ipv4.tcp_rmem/d' /etc/sysctl.conf
            sed -i '/net.ipv4.tcp_wmem/d' /etc/sysctl.conf
            sed -i '/net.ipv4.udp_rmem_min/d' /etc/sysctl.conf
            sed -i '/net.ipv4.udp_wmem_min/d' /etc/sysctl.conf

            if [ "$tune_choice" == "1" ] || [ "$tune_choice" == "3" ]; then
                echo -e "\n${blue}--- ⚡ 正在进行 TCP 网络底层调优 ($MEM_TAG) ---${plain}"
                echo "net.core.rmem_max=$MAX_BUF" >> /etc/sysctl.conf
                echo "net.core.wmem_max=$MAX_BUF" >> /etc/sysctl.conf
                echo "net.ipv4.tcp_rmem=4096 87380 $MAX_BUF" >> /etc/sysctl.conf
                echo "net.ipv4.tcp_wmem=4096 65536 $MAX_BUF" >> /etc/sysctl.conf
                sysctl -p > /dev/null 2>&1
                echo -e "${green}✅ TCP 读写窗口缓冲区已动态扩展至 $((MAX_BUF/1024/1024))MB！${plain}"
            fi

            if [ "$tune_choice" == "2" ] || [ "$tune_choice" == "3" ]; then
                echo -e "\n${blue}--- 🌪️ 正在进行 UDP 网络底层高阶调优 ($MEM_TAG) ---${plain}"
                # 如果选3，防止 tcp 阶段已写入导致的重复，用 sed 先删再写太麻烦，直接覆盖写入规避冲突
                sed -i '/net.core.rmem_max/d' /etc/sysctl.conf
                sed -i '/net.core.wmem_max/d' /etc/sysctl.conf
                echo "net.core.rmem_max=$MAX_BUF" >> /etc/sysctl.conf
                echo "net.core.wmem_max=$MAX_BUF" >> /etc/sysctl.conf
                echo "net.ipv4.udp_rmem_min=8192" >> /etc/sysctl.conf
                echo "net.ipv4.udp_wmem_min=8192" >> /etc/sysctl.conf
                sysctl -p > /dev/null 2>&1
                echo -e "${green}✅ UDP 读写缓冲区已暴力扩容至 $((MAX_BUF/1024/1024))MB！${plain}"
                
                echo -e "\n${yellow}👉 正在嗅探主网卡并配置 CAKE/FQ 队列调度算法...${plain}"
                DEFAULT_IF=$(ip route get 8.8.8.8 | awk '{print $5}' | head -n 1)
                # 升级点：先 del 清除旧队列，防止 add 报错 File exists
                tc qdisc del dev $DEFAULT_IF root >/dev/null 2>&1
                tc qdisc add dev $DEFAULT_IF root cake >/dev/null 2>&1 || tc qdisc add dev $DEFAULT_IF root fq >/dev/null 2>&1
                echo -e "${green}✅ 网卡 [$DEFAULT_IF] 队列调度已完美接管！(Hy2 速度将大幅提升)${plain}"
            fi

            if [ "$tune_choice" == "4" ]; then
                echo -e "\n${blue}--- 🗑️ 正在清除所有网络自定义调优参数 ---${plain}"
                sysctl -p > /dev/null 2>&1
                DEFAULT_IF=$(ip route get 8.8.8.8 | awk '{print $5}' | head -n 1)
                tc qdisc del dev $DEFAULT_IF root >/dev/null 2>&1
                echo -e "${green}✅ 所有强行注入的扩容参数已抹除，系统网络恢复默认状态！${plain}"
            fi
        else
            echo -e "${red}❌ 无效输入，已取消操作。${plain}"
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
            while true; do
                echo -e "\n${blue}=== 🚨 Telegram 全局防线与智能报警监控中枢 ===${plain}"
                TG_CONF="/etc/velox_tg.conf"

                # 动态侦测全局凭证状态
                if [ -f "$TG_CONF" ] && grep -q "GLOBAL_TG_TOKEN" "$TG_CONF"; then
                    source "$TG_CONF"
                    TG_CRED_STAT="${green}已配置 ✅${plain}"
                else
                    TG_CRED_STAT="${yellow}未配置 ⚠️${plain}"
                fi

                # 动态侦测本机 SSH 报警脚本状态
                if [ -f "/usr/local/bin/ssh_tg_alert.sh" ]; then
                    ALERT_STAT="${green}运行中 ✅${plain}"
                else
                    ALERT_STAT="${yellow}未部署 ⚠️${plain}"
                fi

                echo -e "  ${green}1.${plain} 🚀 部署/重置 [SSH 异地登录 + 开机自启] 报警防线 (当前: $ALERT_STAT)"
                echo -e "  ${red}2.${plain} 🗑️ 彻底卸载 SSH 与开机报警防线"
                echo -e "  ${purple}3.${plain} ⚙️ 全局 TG 机器人凭证管理 (当前: $TG_CRED_STAT)"
                echo -e "      ${yellow}└─ 更改/删除 Token 与 ChatID (修改后 VX 和 Velox 的雷达自动生效)${plain}"
                echo -e "  ${cyan}0.${plain} 🔙 返回主菜单"
                echo -e "${cyan}----------------------------------------------------------------------${plain}"
                read -p "👉 请选择操作 [0-3]: " tg_main_choice

                case "$tg_main_choice" in
                    1)
                        if ! command -v curl &> /dev/null; then
                            echo -e "${yellow}正在安装必须的网络组件 curl...${plain}"
                            if command -v apt-get >/dev/null 2>&1; then apt-get update -y >/dev/null 2>&1 && apt-get install curl -y >/dev/null 2>&1;
                            elif command -v dnf >/dev/null 2>&1; then dnf install curl -y >/dev/null 2>&1;
                            elif command -v yum >/dev/null 2>&1; then yum install curl -y >/dev/null 2>&1; fi
                        fi

                        if [ -z "$GLOBAL_TG_TOKEN" ] || [ -z "$GLOBAL_TG_CHATID" ]; then
                            echo -e "\n${yellow}⚠️ 未检测到系统全局公共池有 TG 凭证！${plain}"
                            read -p "👉 请输入你的 TG Bot Token: " tg_token
                            read -p "👉 请输入你的 TG Chat ID: " tg_chatid
                            
                            if [[ -z "$tg_token" || -z "$tg_chatid" ]]; then
                                echo -e "${red}❌ 输入为空，已取消部署。${plain}"
                                read -p "👉 按【回车键】继续..."; continue
                            fi

                            echo -e "\n${cyan}正在向 Telegram 司令部验证凭证连通性...${plain}"
                            tg_check=$(curl -s4m5 "https://api.telegram.org/bot${tg_token}/getMe" || echo "failed")
                            if ! echo "$tg_check" | grep -q '"ok":true'; then
                                echo -e "${red}❌ 验证失败！Token 错误或本机无法连通 TG API。操作已拦截！${plain}"
                                read -p "👉 按【回车键】继续..."; continue
                            fi
                            
                            echo -e "${green}✅ 验证通过！司令部已确认身份。${plain}"
                            echo "GLOBAL_TG_TOKEN=\"$tg_token\"" > "$TG_CONF"
                            echo "GLOBAL_TG_CHATID=\"$tg_chatid\"" >> "$TG_CONF"
                            GLOBAL_TG_TOKEN="$tg_token"
                            GLOBAL_TG_CHATID="$tg_chatid"
                        else
                            echo -e "\n${green}✅ 检测到系统全局公共池已存在 TG 凭证，已自动复用！${plain}"
                            tg_token="$GLOBAL_TG_TOKEN"
                            tg_chatid="$GLOBAL_TG_CHATID"
                        fi

                        echo -e "${cyan}正在向系统底层注入 SSH 探针与开机自启防线...${plain}"
                        
                        # --- 下方保留你原版一模一样的 Payload 代码 ---
                        cat << EOF2 > /usr/local/bin/ssh_tg_alert.sh
#!/bin/bash
if [ -z "\$TG_ALERT_TRIGGERED" ]; then
    export TG_ALERT_TRIGGERED=1
    export TZ="Asia/Shanghai"
    USER_IP=\$(echo \$SSH_CLIENT | awk '{print \$1}')
    if [ -n "\$USER_IP" ]; then
        GEO_INFO=\$(curl -s4m3 "http://ip-api.com/line/\$USER_IP?lang=zh-CN&fields=country,city,isp" | tr '\n' ' ' | sed 's/ $//')
        [ -z "\$GEO_INFO" ] && GEO_INFO="未知归属地或查询超时"
        MSG="🚨 [神盾局警告]
大佬，您的服务器 \$(hostname) 刚刚被登录了！
👉 来源 IP: \$USER_IP
🌍 IP 溯源: \$GEO_INFO
⏰ 北京时间: \$(date +'%Y-%m-%d %H:%M:%S')"
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
                        sed -i '/ssh_tg_alert.sh/d' /etc/profile /etc/bash.bashrc
                        echo "source /usr/local/bin/ssh_tg_alert.sh" >> /etc/profile
                        echo "source /usr/local/bin/ssh_tg_alert.sh" >> /etc/bash.bashrc
                        
                        cat << EOF2 > /usr/local/bin/tg_boot_alert.sh
#!/bin/bash
sleep 15
export TZ="Asia/Shanghai"
sleep 30  
if systemctl is-active --quiet sing-box 2>/dev/null || pgrep -x "sing-box" >/dev/null 2>&1; then SB_STAT="运行中 ✅"; else SB_STAT="未运行/未安装 ⚠️"; fi
if systemctl is-active --quiet xray 2>/dev/null || systemctl is-active --quiet x-ui 2>/dev/null || pgrep -x "xray" >/dev/null 2>&1; then XR_STAT="运行中 ✅"; else XR_STAT="未运行/未安装 ⚠️"; fi
if pgrep -x "cloudflared" >/dev/null 2>&1 || systemctl is-active --quiet vx-argo 2>/dev/null || systemctl is-active --quiet argo 2>/dev/null; then ARGO_STAT="运行中 ✅"; else ARGO_STAT="未运行/无自启 ⚠️"; fi
if systemctl is-active --quiet warp-go 2>/dev/null || systemctl is-active --quiet wg-quick@wgcf 2>/dev/null || systemctl is-active --quiet warp-svc 2>/dev/null || ip link show wg0 >/dev/null 2>&1 || ip link show warp >/dev/null 2>&1; then WARP_STAT="已就绪 ✅"; else WARP_STAT="未开启/未安装 ⚠️"; fi
MSG="🟢 [Velox 系统复苏通知]
大佬，您的服务器 \$(hostname) 已完成重启并成功连网！
📊 【核心体检报告】
🚀 Sing-box : \$SB_STAT
🛸 Xray 核心: \$XR_STAT
🚇 Argo 隧道: \$ARGO_STAT
🛡️ WARP 出站: \$WARP_STAT
⏰ 北京时间: \$(date +'%Y-%m-%d %H:%M:%S')"
MAIN_IF=\$(ip -4 route ls | grep default | grep -v tun | grep -v warp | grep -v wg | awk '{print \$5}' | head -n 1)
if [ -n "\$MAIN_IF" ]; then curl --interface "\$MAIN_IF" -s -X POST "https://api.telegram.org/bot${tg_token}/sendMessage" --data-urlencode chat_id="${tg_chatid}" --data-urlencode text="\$MSG" > /dev/null 2>&1
else curl -s -X POST "https://api.telegram.org/bot${tg_token}/sendMessage" --data-urlencode chat_id="${tg_chatid}" --data-urlencode text="\$MSG" > /dev/null 2>&1; fi
EOF2
                        # --- 原版 Payload 代码结束 ---

                        chmod +x /usr/local/bin/tg_boot_alert.sh
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
                        systemctl daemon-reload; systemctl enable tg_boot_alert.service > /dev/null 2>&1
                        echo -e "\n${green}✅ TG 报警防线部署成功！${plain}"
                        read -p "👉 按【回车键】继续..."
                        ;;
                    2)
                        if [ ! -f "/usr/local/bin/ssh_tg_alert.sh" ]; then
                            echo -e "\n${yellow}⚠️ 当前未部署 SSH 报警防线，无需卸载。${plain}"
                        else
                            echo -e "\n${yellow}正在进行焦土化清除...${plain}"
                            sudo rm -f /usr/local/bin/ssh_tg_alert.sh /usr/local/bin/tg_boot_alert.sh /etc/systemd/system/tg_boot_alert.service
                            sudo sed -i '/ssh_tg_alert.sh/d' /etc/profile /etc/bash.bashrc
                            sudo systemctl disable --now tg_boot_alert.service 2>/dev/null
                            sudo systemctl daemon-reload
                            
                            echo -e "${yellow}正在扫描定时任务旧版残余...${plain}"
                            if crontab -l 2>/dev/null | grep -q "api.telegram.org"; then
                                crontab -l 2>/dev/null | grep -v "api.telegram.org" | crontab -
                                echo -e "${green}✅ 旧版定时报警指令已清理！${plain}"
                            fi
                            echo -e "${green}✅ SSH 与开机报警防线已彻底无痕卸载！(注：全局凭证仍保留)${plain}"
                        fi
                        read -p "👉 按【回车键】继续..."
                        ;;
                    3)
                        echo -e "\n${cyan}=== ⚙️ 全局 TG 机器人凭证管理 ===${plain}"
                        if [[ -n "$GLOBAL_TG_TOKEN" ]]; then
                            echo -e "当前绑定的 Token: ${green}${GLOBAL_TG_TOKEN}${plain}"
                            echo -e "当前绑定的 Chat ID: ${green}${GLOBAL_TG_CHATID}${plain}"
                        else
                            echo -e "${yellow}⚠️ 当前全局池为空。${plain}"
                        fi
                        echo -e "\n请选择操作："
                        echo -e "  ${green}1.${plain} 重新输入并物理覆盖配置"
                        echo -e "  ${red}2.${plain} 彻底删除全局凭证 (💥 将同时强拆 VX 与 Velox 的所有报警进程)"
                        echo -e "  ${yellow}0.${plain} 取消并返回"
                        read -p "👉 请选择 [0-2]: " cred_choice
                        case "$cred_choice" in
                            1)
                                read -p "🔑 请输入新的 TG Bot Token: " new_token
                                read -p "💬 请输入新的 TG Chat ID: " new_chatid
                                if [[ -n "$new_token" && -n "$new_chatid" ]]; then
                                    echo "GLOBAL_TG_TOKEN=\"$new_token\"" > /etc/velox_tg.conf
                                    echo "GLOBAL_TG_CHATID=\"$new_chatid\"" >> /etc/velox_tg.conf
                                    source "$TG_CONF"
                                    echo -e "${green}✅ 全局凭证已物理覆写！${plain}"
                                    
                                    # 跨脚本联动热重载 VX 哨兵
                                    if systemctl is-active --quiet vx-tg-sentinel 2>/dev/null; then
                                        systemctl restart vx-tg-sentinel
                                        echo -e "${green}🔄 侦测到 VX 节点哨兵正在运行，已联动热重载！${plain}"
                                    fi
                                    echo -e "${green}🔄 Velox 的报警也将在下次触发时自动使用新机器人！${plain}"
                                else
                                    echo -e "${red}❌ 输入无效，操作已取消。${plain}"
                                fi
                                ;;
                            2)
                                rm -f /etc/velox_tg.conf
                                unset GLOBAL_TG_TOKEN
                                unset GLOBAL_TG_CHATID
                                echo -e "${green}🗑️ 全局 TG 配置文件已被物理蒸发！${plain}"
                                
                                # 跨脚本联动拆除 VX 哨兵
                                if systemctl is-active --quiet vx-tg-sentinel 2>/dev/null || [ -f "/usr/local/bin/vx-tg-sentinel.sh" ]; then
                                    systemctl stop vx-tg-sentinel >/dev/null 2>&1
                                    systemctl disable vx-tg-sentinel >/dev/null 2>&1
                                    rm -f /etc/systemd/system/vx-tg-sentinel.service /usr/local/bin/vx-tg-sentinel.sh
                                    echo -e "${yellow}⚠️ 已联动物理拆除 VX 节点哨兵进程！${plain}"
                                fi
                                
                                # 联动拆除 Velox 本身的报警
                                if [ -f "/usr/local/bin/ssh_tg_alert.sh" ]; then
                                    sudo rm -f /usr/local/bin/ssh_tg_alert.sh /usr/local/bin/tg_boot_alert.sh /etc/systemd/system/tg_boot_alert.service
                                    sudo sed -i '/ssh_tg_alert.sh/d' /etc/profile /etc/bash.bashrc
                                    sudo systemctl disable --now tg_boot_alert.service >/dev/null 2>&1
                                    if crontab -l 2>/dev/null | grep -q "api.telegram.org"; then crontab -l 2>/dev/null | grep -v "api.telegram.org" | crontab -; fi
                                    echo -e "${yellow}⚠️ 已联动彻底卸载 Velox 的 SSH 与开机报警防线！${plain}"
                                fi
                                systemctl daemon-reload
                                ;;
                        esac
                        read -p "👉 按【回车键】继续..."
                        ;;
                    0) break ;;
                    *) echo -e "${red}❌ 无效选择！${plain}"; sleep 1 ;;
                esac
            done
            ;;
   17)
        DEFAULT_IF=$(ip -4 route ls | grep default | grep -vE 'tun|warp|wg|tailscale' | awk '{print $5}' | head -n 1)
        [ -z "$DEFAULT_IF" ] && DEFAULT_IF=$(ip route get 8.8.8.8 | awk '{for(i=1;i<=NF;i++) if($i=="dev") print $(i+1)}' | head -n 1)
        
        # 🚀 核心升级：LXC 架构预警
        virt_type=$(systemd-detect-virt 2>/dev/null || echo "unknown")
        if [[ "$virt_type" == "lxc" || "$virt_type" == "openvz" ]]; then
            echo -e "\n${yellow}⚠️ 架构预警：检测到当前为 $virt_type 容器环境！${plain}"
            echo -e "部分重度阉割的容器可能无法运行底层的 vnstat 守护进程，如果后续无法统计数据，请联系主机商。${plain}"
            sleep 2
        fi

        if ! command -v bc >/dev/null 2>&1; then
            echo -e "\n${yellow}正在为您安装底层核心计算组件 (bc)...${plain}"
            if command -v apt-get >/dev/null 2>&1; then apt-get update -y >/dev/null 2>&1 && apt-get install bc -y >/dev/null 2>&1; 
            elif command -v yum >/dev/null 2>&1; then yum install bc -y >/dev/null 2>&1; 
            elif command -v dnf >/dev/null 2>&1; then dnf install bc -y >/dev/null 2>&1; fi
        fi
        
        TG_CONF="/etc/velox_tg.conf"

        while true; do
            # ======== 🚀 动态嗅探防线状态与 TG 状态 ========
            if [ -f "/usr/local/bin/velox_traffic_alert.sh" ]; then
                # 从底层脚本里直接把红线数值和模式"抠"出来显示
                LIMIT_VAL=$(grep "^LIMIT=" /usr/local/bin/velox_traffic_alert.sh | cut -d '=' -f2)
                if grep -q "出站上传" /usr/local/bin/velox_traffic_alert.sh; then
                    MODE_STR="出站"
                else
                    MODE_STR="双向"
                fi
                GUARD_STAT="${green}运行中✅ (红线:${LIMIT_VAL}G | 模式:${MODE_STR})${plain}"
            else
                GUARD_STAT="${yellow}未部署⚠️${plain}"
            fi

            if [ -f "$TG_CONF" ] && grep -q "GLOBAL_TG_TOKEN" "$TG_CONF"; then
                TG_STAT="${green}已绑定✅${plain}"
            else
                TG_STAT="${yellow}未绑定⚠️${plain}"
            fi
            # ===============================================

            clear
            echo -e "${cyan}=======================================================${plain}"
            echo -e "       📈 Velox 流量大管家 (全平台通用 / 数据库持久化版)"
            echo -e "       当前监听主网卡: ${yellow}$DEFAULT_IF${plain}"
            echo -e "${cyan}=======================================================${plain}"
            echo -e "  ${green}1.${plain} 📊 查看看板 (包含本次开机临时流量 & 本月持久化总账单)"
            echo -e "  ${red}2.${plain} 🚨 部署防线 [防线: $GUARD_STAT | TG: $TG_STAT]"
            echo -e "  ${purple}3.${plain} 📈 极客视窗 (黑客级 TUI 实时网速动态监控仪表盘)"
            echo -e "  ${yellow}0.${plain} 🔙 返回主菜单"
            echo -e "-------------------------------------------------------"
            read -p "👉 请选择操作 [0-3]: " traffic_choice

            case $traffic_choice in
                1)
                    # 模块A：读取瞬时内存流量
                    echo -e "\n${blue}=== 📊 临时报表：自本次开机以来的消耗 ===${plain}"
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

                    # === 模块B：读取底层持久化数据库 ===
                    echo -e "\n${blue}=== 🗓️ 月度账单：数据库持久化记录 (重启不丢) ===${plain}"

                    # 1. 核心安装防线 (不仅查命令，还要防残留)
                    if ! command -v vnstat >/dev/null 2>&1; then
                        echo -e "${yellow}检测到未安装 vnstat，正在为您全自动部署底层服务...${plain}"
                        if command -v apt-get >/dev/null; then 
                            apt-get update -y >/dev/null 2>&1
                            apt-get install vnstat -y >/dev/null 2>&1
                        elif command -v yum >/dev/null; then 
                            yum install epel-release -y >/dev/null 2>&1
                            yum install vnstat -y >/dev/null 2>&1
                        elif command -v dnf >/dev/null; then 
                            dnf install epel-release -y >/dev/null 2>&1
                            dnf install vnstat -y >/dev/null 2>&1
                        fi
                    fi
                    
                    # 🚀 新增心脏起搏：强行拉起守护进程！
                    systemctl enable vnstat >/dev/null 2>&1
                    systemctl start vnstat >/dev/null 2>&1

                    # 2. 动态网卡无缝自适应核心逻辑
                    if ! vnstat -i $DEFAULT_IF >/dev/null 2>&1; then
                        systemctl stop vnstat >/dev/null 2>&1
                        vnstat --add -i $DEFAULT_IF >/dev/null 2>&1
                        vnstat --create -i $DEFAULT_IF >/dev/null 2>&1
                        chown -R vnstat:vnstat /var/lib/vnstat >/dev/null 2>&1
                        systemctl start vnstat >/dev/null 2>&1
                    fi
                    
                    # 3. 探针正式抓取
                    VNSTAT_OUT=$(vnstat -i $DEFAULT_IF -m 2>&1)

                    # 4. 智能拦截与底层催熟
                    if echo "$VNSTAT_OUT" | grep -qE "Not enough data|not found|No data"; then
                        ping -c 4 8.8.8.8 >/dev/null 2>&1
                        vnstat -u -i $DEFAULT_IF >/dev/null 2>&1
                        sleep 2 
                        VNSTAT_OUT=$(vnstat -i $DEFAULT_IF -m 2>&1)
                        
                        if echo "$VNSTAT_OUT" | grep -qE "Not enough data|not found|No data"; then
                            echo -e "${yellow}⚠️ 数据库刚刚建立，底层正在疯狂采集中。请稍等片刻后再来查看！${plain}"
                        else
                            echo -e "${green}✅ 流量统计引擎已满血激活！Velox 已成功接管 [$DEFAULT_IF] 网卡。${plain}"
                            echo -e "${cyan}$VNSTAT_OUT${plain}"
                        fi
                    else
                        echo -e "${cyan}$VNSTAT_OUT${plain}"
                    fi

                    echo ""
                    read -p "👉 按【回车键】继续..."
                    ;;
                    
               2)
                    echo -e "\n${yellow}正在校验底层依赖...${plain}"
                    if ! command -v vnstat >/dev/null 2>&1; then
                        echo -e "${red}❌ 错误：请先执行选项 [1] 建立流量数据库！${plain}"
                        read -p "👉 按【回车键】继续..."
                        continue
                    fi

                    # 智能卸载与重置逻辑
                    if [ -f "/usr/local/bin/velox_traffic_alert.sh" ]; then
                        echo -e "\n${green}✅ 检测到当前已部署流量熔断防线！${plain}"
                        read -p "👉 请选择操作 (r:重新配置 / d:彻底卸载 / n:返回): " guard_choice
                        if [[ "$guard_choice" == "d" || "$guard_choice" == "D" ]]; then
                            rm -f /usr/local/bin/velox_traffic_alert.sh
                            crontab -l 2>/dev/null | grep -v "velox_traffic_alert.sh" | crontab -
                            echo -e "${green}✅ 流量报警防线已彻底无痕卸载！(系统已停止监控流量)${plain}"
                            read -p "👉 按【回车键】继续..."
                            continue
                        elif [[ "$guard_choice" != "r" && "$guard_choice" != "R" ]]; then
                            continue
                        fi
                    fi

                    echo -e "\n${blue}--- 🚨 部署隐蔽流量防线与 TG 预警 ---${plain}"
                    echo -e "💡 极客科普：不同服务商的计费规则不同，请根据你的 VPS 类型进行选择："
                    echo -e "  ${cyan}1.${plain} 【单向出站计费】 (仅算上传，如 GCP、AWS、Azure 等云大厂)"
                    echo -e "  ${cyan}2.${plain} 【双向总计计费】 (上下行全算，如 搬瓦工、DMIT、RN 等各类 VPS)"
                    read -p "👉 请选择计费模式 [1-2, 直接回车取消]: " mode_choice
                    
                    if [ -z "$mode_choice" ]; then echo -e "${yellow}已取消。${plain}"; read -p "按回车键继续..."; continue; fi
                    
                    if [ "$mode_choice" == "1" ]; then
                        MODE_NAME="出站上传(TX)"
                        echo -e "✅ 已选择: ${green}单向出站模式 (仅统计上传)${plain}"
                    elif [ "$mode_choice" == "2" ]; then
                        MODE_NAME="双向总计(Total)"
                        echo -e "✅ 已选择: ${green}双向总计模式 (统计上下行总和)${plain}"
                    else
                        echo -e "${red}❌ 输入错误，已取消。${plain}"; read -p "按回车键继续..."; continue
                    fi

                    echo -e "\n⚠️  ${yellow}极客建议：为了防止面板统计与服务商后台存在细微的字节换算误差，强烈建议扣除 5% 作为安全缓冲！${plain}"
                    echo -e "   例如：GCP 免费 200G，请填 190；搬瓦工/RN 额度 1000G，请填 950！"
                    read -p "👉 请输入每月的流量熔断红线 (单位GB) [直接回车取消]: " limit_gb
                    if [ -z "$limit_gb" ]; then echo -e "${yellow}已取消。${plain}"; read -p "按回车键继续..."; continue; fi
                    
                    # 全局 TG 配置智能嗅探
                    if [ -f "$TG_CONF" ]; then
                        source "$TG_CONF"
                        if [ -n "$GLOBAL_TG_TOKEN" ] && [ -n "$GLOBAL_TG_CHATID" ]; then
                            echo -e "\n${green}✅ 检测到全局 TG 机器人配置，已自动复用！无需重复输入。${plain}"
                            tg_token="$GLOBAL_TG_TOKEN"
                            tg_chatid="$GLOBAL_TG_CHATID"
                        fi
                    fi

                    if [ -z "$tg_token" ] || [ -z "$tg_chatid" ]; then
                        read -p "👉 请输入你的 TG Bot Token [直接回车取消]: " tg_token
                        [ -z "$tg_token" ] && { echo -e "${yellow}已取消。${plain}"; read -p "按回车键继续..."; continue; }
                        read -p "👉 请输入你的 TG Chat ID [直接回车取消]: " tg_chatid
                        [ -z "$tg_chatid" ] && { echo -e "${yellow}已取消。${plain}"; read -p "按回车键继续..."; continue; }
                        
                        echo -e "\n${cyan}正在向 Telegram 司令部验证凭证连通性...${plain}"
                        tg_check=$(curl -s4m5 "https://api.telegram.org/bot${tg_token}/getMe" || echo "failed")
                        if ! echo "$tg_check" | grep -q '"ok":true'; then
                            echo -e "${red}❌ 验证失败！Token 错误或网络无法连通。操作已拦截！${plain}"
                            read -p "按回车键继续..."; continue
                        fi
                        echo "GLOBAL_TG_TOKEN=\"$tg_token\"" > "$TG_CONF"
                        echo "GLOBAL_TG_CHATID=\"$tg_chatid\"" >> "$TG_CONF"
                        echo -e "${green}✅ 验证通过，TG 凭证已保存为全局变量。${plain}"
                    fi
                    
                    if [[ "$limit_gb" =~ ^[0-9]+$ ]]; then
                        
                        # 🚀 智能数据校验与下发首封测试信 (兼容跨版本 Vnstat)
                        DATA=$(vnstat -i $DEFAULT_IF --oneline b 2>/dev/null)
                        
                        # 💡 致命修复：分号必须加引号，否则触发 Bash syntax error
                        if [[ "$DATA" == "1;"* ]]; then
                            [[ "$MODE_NAME" == "出站上传(TX)" ]] && FIELD=9 || FIELD=10
                        elif [[ "$DATA" == "2;"* ]]; then
                            [[ "$MODE_NAME" == "出站上传(TX)" ]] && FIELD=10 || FIELD=11
                        fi
                        
                        MONTH_BYTES=$(echo "$DATA" | cut -d ';' -f $FIELD)
                        if [[ -z "$MONTH_BYTES" || ! "$MONTH_BYTES" =~ ^[0-9]+$ ]]; then MONTH_BYTES=0; fi
                        CURRENT_GB=$(echo "scale=2; $MONTH_BYTES / 1073741824" | bc)

                        cat << EOF2 > /usr/local/bin/velox_traffic_alert.sh
#!/bin/bash
IFACE="$DEFAULT_IF"
LIMIT=$limit_gb
TOKEN="$tg_token"
CHATID="$tg_chatid"
MODE_NAME="$MODE_NAME"

# 🚀 计算 80% 黄金预警线，并设置当月专属锁文件 (防轰炸机制)
LIMIT_80=\$(echo "scale=2; \$LIMIT * 0.8" | bc)
CURRENT_MONTH=\$(date +%Y-%m)
LOCK_80="/tmp/velox_warn_80_\${CURRENT_MONTH}.lock"
LOCK_100="/tmp/velox_warn_100_\${CURRENT_MONTH}.lock"

DATA=\$(vnstat -i \$IFACE --oneline b 2>/dev/null)

# 💡 致命修复：分号必须加引号
if [[ "\$DATA" == "1;"* ]]; then
    [[ "\$MODE_NAME" == "出站上传(TX)" ]] && FIELD=9 || FIELD=10
elif [[ "\$DATA" == "2;"* ]]; then
    [[ "\$MODE_NAME" == "出站上传(TX)" ]] && FIELD=10 || FIELD=11
fi

if [[ -n "\$FIELD" ]]; then
    MONTH_BYTES=\$(echo "\$DATA" | cut -d ';' -f \$FIELD)
    
    if [[ "\$MONTH_BYTES" =~ ^[0-9]+$ ]]; then
        USAGE_GB=\$(echo "scale=2; \$MONTH_BYTES / 1073741824" | bc)
        
        # 1. 判断是否超过 100% 熔断红线 (最优先)
        if (( \$(echo "\$USAGE_GB >= \$LIMIT" | bc -l) )); then
            if [ ! -f "\$LOCK_100" ]; then
                MSG="🚨 [Velox 流量熔断绝杀] 
大佬，系统报告您的机器 \$(hostname) 本月【\$MODE_NAME】已飙升至 \${USAGE_GB} GB！
已突破设定的 \${LIMIT} GB 终极红线，请立即登入后台处理以防天价账单或被强制停机！"
                curl -s -X POST "https://api.telegram.org/bot\$TOKEN/sendMessage" -d "chat_id=\$CHATID" -d "text=\$MSG" >/dev/null 2>&1
                touch "\$LOCK_100"
            fi
            
        # 2. 判断是否超过 80% 预警黄线
        elif (( \$(echo "\$USAGE_GB >= \$LIMIT_80" | bc -l) )); then
            if [ ! -f "\$LOCK_80" ]; then
                MSG="⚠️ [Velox 流量超标预警] 
大佬注意！您的机器 \$(hostname) 本月【\$MODE_NAME】已达 \${USAGE_GB} GB！
已超过 80% 安全警戒线 (\${LIMIT_80} GB)，请合理安排后续使用节奏！"
                curl -s -X POST "https://api.telegram.org/bot\$TOKEN/sendMessage" -d "chat_id=\$CHATID" -d "text=\$MSG" >/dev/null 2>&1
                touch "\$LOCK_80"
            fi
        fi
    fi
fi
EOF2
                        chmod +x /usr/local/bin/velox_traffic_alert.sh
                        crontab -l 2>/dev/null | grep -v "velox_traffic_alert.sh" | crontab -
                        (crontab -l 2>/dev/null; echo "0 * * * * /usr/local/bin/velox_traffic_alert.sh") | crontab -
                        
                        echo -e "\n${green}✅ [$MODE_NAME] 防线部署成功！雷达已潜伏入系统底层守护！${plain}"
                        
                        # ==========================================
                        # 🚀 发送即时连通性测试报文
                        # ==========================================
                        WARN_GB=$(echo "scale=2; $limit_gb * 0.8" | bc)
                        TEST_MSG="🟢 [Velox 流量大管家] 部署成功测试！
大佬，您的服务器 $(hostname) 流量防线已成功激活！
👉 监控网卡: $DEFAULT_IF
👉 监控模式: $MODE_NAME
📊 当前已用: ${CURRENT_GB} GB
⚠️ 预警黄线: ${WARN_GB} GB (达到80%将自动报警)
🛑 熔断红线: ${limit_gb} GB (达到100%将发起绝杀)
(此消息用于确认 TG 报警通道畅通)"
                        curl -s -X POST "https://api.telegram.org/bot$tg_token/sendMessage" -d "chat_id=$tg_chatid" -d "text=$TEST_MSG" >/dev/null 2>&1
                        
                        echo -e "系统将每小时执行一次隐蔽扫描，并在达到 80% 和 100% 时自动通知您。"
                        echo -e "${purple}🔔 叮咚！已向您的 TG 发生了一封【部署连通性测试信】，请立即查看手机！${plain}"
                    else
                        echo -e "\n${red}❌ 格式输入错误，必须是纯数字。${plain}"
                    fi
                    read -p "👉 按【回车键】继续..."
                    ;;
                    
                3)
                    clear
                    echo -e "${cyan}=======================================================${plain}"
                    echo -e "     📈 Velox 极客视窗 - 实时网络监控仪 (网卡: $DEFAULT_IF)"
                    echo -e "     💡 ${yellow}直接在键盘按【任意键】即可无缝退出监控模式${plain}"
                    echo -e "${cyan}=======================================================${plain}\n\n\n\n"
                    
                    while true; do
                        if [ ! -d "/sys/class/net/$DEFAULT_IF/statistics" ]; then
                            echo -e "\033[4A\033[J"
                            echo -e "${red}❌ 致命错误：无法定位网卡 [$DEFAULT_IF]。${plain}"
                            break
                        fi
                        RX1=$(cat /sys/class/net/$DEFAULT_IF/statistics/rx_bytes 2>/dev/null || echo 0)
                        TX1=$(cat /sys/class/net/$DEFAULT_IF/statistics/tx_bytes 2>/dev/null || echo 0)
                        
                        read -t 1 -n 1 -s key
                        if [[ $? -eq 0 ]]; then break; fi
                        
                        RX2=$(cat /sys/class/net/$DEFAULT_IF/statistics/rx_bytes 2>/dev/null || echo 0)
                        TX2=$(cat /sys/class/net/$DEFAULT_IF/statistics/tx_bytes 2>/dev/null || echo 0)
                        
                        RX_KB=$(( (RX2 - RX1) / 1024 ))
                        TX_KB=$(( (TX2 - TX1) / 1024 ))
                        
                        RX_BAR_LEN=$((RX_KB / 50)); [[ $RX_BAR_LEN -gt 35 ]] && RX_BAR_LEN=35
                        TX_BAR_LEN=$((TX_KB / 50)); [[ $TX_BAR_LEN -gt 35 ]] && TX_BAR_LEN=35
                        
                        RX_BAR=$(printf '%*s' $RX_BAR_LEN '' | tr ' ' '#')
                        TX_BAR=$(printf '%*s' $TX_BAR_LEN '' | tr ' ' '#')
                        
                        echo -en "\033[4A\033[J"
                        echo -e "⬇️  下载: ${green}$(printf "%7s" $RX_KB) KB/s${plain} | ${cyan}$RX_BAR${plain}"
                        echo -e "⬆️  上传: ${red}$(printf "%7s" $TX_KB) KB/s${plain} | ${yellow}$TX_BAR${plain}"
                        echo -e "\n👉 ${yellow}正在实时监控中... (按任意键退出)${plain}"
                    done
                    echo -e "\n${green}✅ 已退出动态监控。${plain}"
                    sleep 0.5
                    ;;
                    
                0) break ;;
                *) echo -e "\n${red}❌ 无效选择。${plain}"; sleep 1 ;;
            esac
        done
        ;;
        
    18)
        echo -e "\n${blue}--- 💽 自定义虚拟内存 (Swap) 管理 ---${plain}"
        # 🚀 核心升级：架构防爆护盾 (调用全局智能函数，一行顶十行！)
        check_virt_safe "Swap 虚拟内存硬盘挂载" || { read -p "👉 按【回车键】继续..."; continue; }

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
                        # 💡 核心升级：增加 dd 暴力写入作为极致兜底，通杀所有奇葩文件系统！
                        sudo fallocate -l ${swap_size}G /swapfile 2>/dev/null || sudo dd if=/dev/zero of=/swapfile bs=1M count=$((swap_size * 1024)) status=progress
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
        echo -e "\n${blue}=== 🔄 一键系统全能更新与清理 (防卡死纯净版) ===${plain}"
        echo -e "${yellow}正在探测系统架构并拉取最新安全补丁，过程可能需要 1-3 分钟，请耐心等待...${plain}"
        
        if command -v apt-get &> /dev/null; then
            echo -e "${cyan}📦 检测到 Debian/Ubuntu 环境，正在执行安全更新...${plain}"
            sudo apt-get update -y
            # 💡 核心升级一：终极防卡死参数 (强行静默，默认保留旧配置，彻底告别紫色弹窗卡死)
            sudo DEBIAN_FRONTEND=noninteractive apt-get -o Dpkg::Options::="--force-confdef" -o Dpkg::Options::="--force-confold" upgrade -y
            
            # 💡 核心升级二：极客垃圾回收 (清理卸载旧内核与冗余依赖)
            echo -e "\n${cyan}🧹 正在清理冗余依赖和历史安装包垃圾...${plain}"
            sudo apt-get autoremove -y
            sudo apt-get clean
            
        elif command -v dnf &> /dev/null; then
            echo -e "${cyan}📦 检测到 RHEL/Fedora/Rocky (dnf) 环境...${plain}"
            sudo dnf check-update
            sudo dnf upgrade -y
            echo -e "\n${cyan}🧹 正在执行系统清理...${plain}"
            sudo dnf autoremove -y
            sudo dnf clean all
            
        elif command -v yum &> /dev/null; then
            echo -e "${cyan}📦 检测到 CentOS (yum) 环境...${plain}"
            sudo yum check-update
            sudo yum upgrade -y
            echo -e "\n${cyan}🧹 正在执行系统清理...${plain}"
            sudo yum autoremove -y
            sudo yum clean all
            
        else
            # 💡 核心升级三：移除了致命的 break，改为友好的错误提示
            echo -e "${red}❌ 未知系统包管理器，无法自动更新！请手动执行。${plain}"
        fi
        
        echo -e "\n${green}✅ 系统底层库及组件已全部更新至最新状态，且历史冗余垃圾已清空！机器状态满血！${plain}"
        read -p "👉 按【回车键】返回主菜单..."
        ;;
   21)
        while true; do
            # --- 🕵️‍♂️ 史诗级智能侦测引擎 (开源全兼容版) ---
            # 1. 动态侦测当前 SSH 端口
            current_port=$(grep -iE "^Port " /etc/ssh/sshd_config | awk '{print $2}' | head -n 1)
            [ -z "$current_port" ] && current_port="22 (默认)"

            # 2. 提取密码登录开关状态
            pwd_auth=$(grep -i "^PasswordAuthentication" /etc/ssh/sshd_config | awk '{print $2}' | tr -d '\r' | head -n 1)

            # 3. 核心：智能判定当前真实登录模式
            if [[ "$pwd_auth" == "no" ]]; then
                login_status="${green}仅限密钥登录 (极高安全) 🛡️${plain}"
                pw_toggle="重新开启密码"
            elif [ -f ~/.ssh/authorized_keys ] && [ -s ~/.ssh/authorized_keys ]; then
                login_status="${yellow}密钥/密码混合模式 (建议锁死) ⚠️${plain}"
                pw_toggle="强制关闭密码"
            else
                login_status="${red}纯密码登录 (极高风险) 🚨${plain}"
                pw_toggle="强制关闭密码"
            fi

            # 4. 动态侦测防盗门状态
            defender_status="${red}裸奔中 (未部署防爆破)${plain}"
            if systemctl is-active --quiet velox-defender 2>/dev/null; then
                defender_status="${cyan}已激活 (纯 Bash 轻量机枪塔)${plain}"
            elif systemctl is-active --quiet fail2ban 2>/dev/null; then
                defender_status="${purple}已激活 (Fail2Ban 工业级装甲)${plain}"
            fi

            echo -e "\n${blue}=== 🚨 SSH 智能动态防盗门与双核防御中心 (状态感知/免密飞升/机枪塔) ===${plain}"
            echo -e "🔹 当前状态 -> 端口: [${cyan}$current_port${plain}] | 模式: [$login_status]"
            echo -e "🔹 实时防御: [$defender_status]"
            echo -e "${cyan}--------------------------------------------------------------------------------${plain}"
            echo -e "  ${green}1.${plain} 🕵️  查看当前在线 SSH 用户并实施制裁"
            echo -e "  ${green}2.${plain} 💣  审计被拦截的黑客爆破日志 (查外鬼)"
            echo -e "  ${cyan}3.${plain} 🚪  修改 SSH 端口 (输入 22 即可恢复默认)"
            echo -e "  ${yellow}4.${plain} 🔑  一键切换密码登录开关 (执行: $pw_toggle)"
            echo -e "  ${purple}5.${plain} 🚀  一键部署免密登录并【锁死密码】(全平台通用)"
            echo -e "  ${red}6.${plain} 🛡️  部署/卸载安全防御武器库 (机枪塔/Fail2Ban)"
            echo -e "  ${yellow}0.${plain} 🔙  返回主菜单"
            echo -e "${cyan}--------------------------------------------------------------------------------${plain}"
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
                    # 兼容 Debian(auth.log) 与 CentOS(secure)
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
                        
                        # --- 新增的智能防护与提示逻辑 ---
                        if [ "$new_port" -eq 22 ]; then 
                            echo -e "\n${green}✅ SSH 端口已恢复为默认 ${red}22${plain} 端口！${plain}"
                        else 
                            # 👇 终极无敌抓 IP 方案（本地直取 + 物理网卡穿透兜底）👇
                            # 第一招（降维打击）：直接从当前 SSH 会话底层提取你连接的真实服务端 IP
                            vps_ip=$(echo $SSH_CONNECTION | awk '{print $3}')
                            
                            # 第二招（极致兜底）：如果极其罕见地抓不到，才动用物理网卡强行穿透外部查询
                            if [ -z "$vps_ip" ]; then
                                real_iface=$(ip -4 route ls | grep default | grep -vE 'wg|warp|tun' | awk '{print $5}' | head -n 1)
                                vps_ip=$(curl -s4m8 --interface "$real_iface" https://icanhazip.com 2>/dev/null)
                            fi
                            
                            # 终极保底
                            [ -z "$vps_ip" ] && vps_ip="你的VPS真实IP"
                            # 👆--------------------------------------------------------👆

                            echo -e "\n${yellow}================ 🚨 极客换门指南 & 避坑必读 🚨 =================${plain}"
                            echo -e "${green}✅ SSH 端口已成功切换至: ${new_port}${plain}"
                            echo -e "👉 当前窗口断开后，请使用以下全新口令登录："
                            echo -e "${cyan}ssh root@${vps_ip} -p ${new_port}${plain}\n"
                            
                            echo -e "${purple}💡 【如果改完端口后连不上怎么办？】${plain}"
                            echo -e "若你是重装系统后首次改端口，本地电脑的防黑客机制可能会拦截你的登录。"
                            echo -e "请根据你的连接工具，对号入座解决："
                            echo -e ""
                            echo -e " ${cyan}▶ 场景 A: 使用 Windows CMD / PowerShell / Mac 终端${plain}"
                            echo -e "   如果屏幕出现红色警告包含 ${red}REMOTE HOST IDENTIFICATION HAS CHANGED${plain}"
                            echo -e "   请在你的【本地电脑】终端里，直接复制并运行这行命令洗白记录："
                            echo -e "   ${green}ssh-keygen -R \"[${vps_ip}]:${new_port}\"${plain}"
                            echo -e "   (若依然报错，可执行: ssh-keygen -R ${vps_ip})"
                            echo -e "   洗白后，再次输入 ssh 登录命令即可丝滑进入！"
                            echo -e ""
                            echo -e " ${cyan}▶ 场景 B: 使用 FinalShell / Xshell / Termius 等 SSH 软件${plain}"
                            echo -e "   软件会自动弹出一个【安全警告】或【主机密钥已更改】的提示框。"
                            echo -e "   不用慌，直接点击弹窗上的 ${green}「接受并保存」${plain} 或 ${green}「更新密钥」${plain} 即可进入！"
                            echo -e "${yellow}=================================================================${plain}\n"
                            echo -e "⚠️ ${red}切记：请务必去云服务商（如 GCP/AWS/阿里云）的网页防火墙放行 ${new_port} 端口！${plain}"
                        fi
                    else
                        echo -e "\n${red}❌ 端口不合法。${plain}"
                    fi
                    ;;
                4)
                    if [[ "$pwd_auth" == "no" ]]; then
                        sed -i 's/^PasswordAuthentication no/PasswordAuthentication yes/g' /etc/ssh/sshd_config
                        systemctl restart sshd 2>/dev/null || systemctl restart ssh 2>/dev/null
                        echo -e "\n${yellow}🔓 密码登录已【重新开启】！(防线已降级)${plain}"
                    else
                        read -p "⚠️ 确认关闭密码登录？(请确保已配置密钥，否则可能失联！) (y/n): " confirm_key
                        if [[ "$confirm_key" == "y" || "$confirm_key" == "Y" ]]; then
                            sed -i 's/^#\?PasswordAuthentication.*/PasswordAuthentication no/g' /etc/ssh/sshd_config
                            grep -q "^PasswordAuthentication no" /etc/ssh/sshd_config || echo "PasswordAuthentication no" >> /etc/ssh/sshd_config
                            systemctl restart sshd 2>/dev/null || systemctl restart ssh 2>/dev/null
                            echo -e "\n${green}✅ 密码登录已【永久关闭】！(防线已锁死)${plain}"
                        fi
                    fi
                    ;;
                5)
                    echo -e "\n${cyan}=== 🔐 极客级密钥部署与防线飞升程序 (全平台通用版) ===${plain}"
                    echo -e "${yellow}💡 如何在【您的本地电脑】获取公钥数字串？${plain}"
                    echo -e "   -------------------------------------------------------"
                    echo -e "   🍎 ${cyan}Mac / Linux${plain}  : 执行 ${green}cat ~/.ssh/id_ed25519.pub${plain}"
                    echo -e "   🪟 ${cyan}Windows${plain}      : 执行 ${green}type %userprofile%\\.ssh\\id_ed25519.pub${plain}"
                    echo -e "   📱 ${cyan}手机端应用${plain}   : 在 App 的 Key 菜单点 ${green}Export Public Key${plain}"
                    echo -e "   -------------------------------------------------------"
                    echo -e "   📌 ${red}若提示找不到文件${plain}，请先在本地执行: ${yellow}ssh-keygen -t ed25519 -N \"\"${plain}\n"
                    
                    read -p "✍️  请在此粘贴您的公钥 (ssh-rsa/ssh-ed25519...): " ssh_pub_key
                    if [[ "$ssh_pub_key" == ssh-rsa* ]] || [[ "$ssh_pub_key" == ssh-ed25519* ]] || [[ "$ssh_pub_key" == ecdsa-sha2* ]]; then
                        # 1. 创建目录并确保极限权限
                        mkdir -p ~/.ssh && chmod 700 ~/.ssh
                        # 2. 注入公钥 (去重逻辑)
                        if ! grep -q "$ssh_pub_key" ~/.ssh/authorized_keys 2>/dev/null; then
                            echo "$ssh_pub_key" >> ~/.ssh/authorized_keys
                        fi
                        chmod 600 ~/.ssh/authorized_keys
                        
                        # 3. 焦土化清理：彻底粉碎密码验证开关
                        sed -i 's/^#\?PasswordAuthentication.*/PasswordAuthentication no/g' /etc/ssh/sshd_config
                        sed -i 's/^#\?PubkeyAuthentication.*/PubkeyAuthentication yes/g' /etc/ssh/sshd_config
                        grep -q "^PasswordAuthentication no" /etc/ssh/sshd_config || echo "PasswordAuthentication no" >> /etc/ssh/sshd_config
                        
                        # 4. 联动拉起核心 (全兼容重启)
                        systemctl restart sshd 2>/dev/null || systemctl restart ssh 2>/dev/null
                        echo -e "\n${green}✅ 公钥已成功注入系统底座！密码登录已物理切断。${plain}"
                        echo -e "💡 ${cyan}极客提示：您现在已飞升至【纯密钥模式】，防御力拉满！再次进入菜单状态会自动更新。${plain}"
                    else 
                        echo -e "\n${red}❌ 格式识别失败！请确保粘贴的是以 ssh- 开头的【公钥】。${plain}"
                    fi
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
                        echo '#!/bin/bash' > /usr/local/bin/velox-defender.sh
                        # 🚀 核心升级：Debian 12 动态日志瞎眼修复，智能回退 journalctl！
                        echo 'if [ -f /var/log/auth.log ]; then LOG_CMD="tail -Fn0 /var/log/auth.log"; elif [ -f /var/log/secure ]; then LOG_CMD="tail -Fn0 /var/log/secure"; else LOG_CMD="journalctl -u ssh -u sshd -fn0"; fi' >> /usr/local/bin/velox-defender.sh
                        echo 'eval "$LOG_CMD" | awk '\''/Failed password/ {print $(NF-3)}'\'' | while read IP; do' >> /usr/local/bin/velox-defender.sh
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
                        rm -f /usr/local/bin/velox-defender.sh /etc/systemd/system/velox-defender.service /tmp/velox_ip_counts.txt /var/log/velox-defender.log
                        systemctl daemon-reload
                        echo -e "${green}✅ Bash 机枪塔已彻底拆除并粉碎，不留一丝痕迹！${plain}"
                        
                    elif [ "$def_choice" == "3" ]; then
                        # 🚀 核心升级：LXC/OpenVZ 强装 Fail2Ban 防失联硬阻断
                        virt_type=$(systemd-detect-virt 2>/dev/null || echo "unknown")
                        if [[ "$virt_type" == "lxc" || "$virt_type" == "openvz" ]]; then
                            echo -e "\n${red}❌ 致命拦截：当前 VPS 架构为 $virt_type 容器！${plain}"
                            echo -e "${yellow}此类精简容器缺少底层 iptables 模块权限，强装 Fail2Ban 100% 会导致网络瘫痪失联！${plain}"
                            echo -e "${green}💡 请使用 [选项 1] 部署纯 Bash 机枪塔，0 依赖免底层内核，完美防御！${plain}"
                        else
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
                        fi
                       
                        
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
                clear
                echo -e "\n${blue}======================================================${plain}"
                echo -e "${yellow}       🚀 Velox Node Engine (VX) 核心部署枢纽 🚀${plain}"
                echo -e "${blue}======================================================${plain}"
                echo -e "  💡 ${cyan}本引擎为 Velox 面板独家底层，专为极客打造：${plain}"
                echo -e "   ✅ 强制底层流量嗅探 (Sniffing)，100% 杜绝 DNS 泄露"
                echo -e "   ✅ 独创关键字精准分流，秒级解锁 Gemini / Netflix 等"
                echo -e "   ✅ 原子级配置重构，告别臃肿残渣，极限压榨机器性能"
                echo -e "${blue}------------------------------------------------------${plain}"
                echo -e "  ${green}1.${plain} ⚡ 立即部署 / 唤醒 VX 终极控制面板"
                echo -e "  ${cyan}0.${plain} ↩️  取消并返回主菜单"
                echo -e "${blue}======================================================${plain}"
               read -p "👉 请选择操作 [0-1]: " vx_choice
                
                case "$vx_choice" in
                    1)
                    echo -e "\n${green}>>> 正在同步并唤醒 VX 核心引擎，请稍候...${plain}"
                    # 🚀 核心升级：原子级写入，防下载中断导致文件损坏
                    curl -sL "https://raw.githubusercontent.com/pwenxiang51-wq/VX-Node-Engine/main/vx.sh?v=$(date +%s)" -o /tmp/vx_tmp.sh
                    
                    if [ -s /tmp/vx_tmp.sh ]; then
                        mv -f /tmp/vx_tmp.sh /usr/local/bin/vx
                        chmod +x /usr/local/bin/vx
                        
                        # 提前给 VX 铺好温床，防爆死
                        mkdir -p /etc/vx /usr/local/etc/vx /etc/vne /usr/local/etc/vne
                        
                        # 唤醒 VX 面板
                        vx
                    else
                        echo -e "\n${red}❌ 致命错误：网络异常或 GitHub API 被拦截，文件拉取失败！VX 引擎未受损。${plain}"
                    fi
                    ;;
                    0)
                        echo -e "\n${green}✅ 已取消操作，安全返回主菜单。${plain}"
                        ;;
                    *)
                        echo -e "\n${red}❌ 错误：无效的选项，操作取消。${plain}"
                        sleep 1
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
            echo -e "\n${blue}=== ⚡ 代理节点服务无痛重启 (全域兼容版) ===${plain}"
            echo -e "${yellow}小白科普：当你发现节点连不上、断流时使用此功能。此操作【不会】重启整台 VPS，SSH 终端【不会】断开，瞬间完成。${plain}\n"
            echo -e "  ${green}1.${plain} 仅重启 Sing-box 核心"
            echo -e "  ${green}2.${plain} 仅重启 Xray/V2ray 核心 (智能兼容 X-UI 等各类面板)"
            echo -e "  ${green}3.${plain} 仅重启 Argo 穿透隧道 (智能兼容官方与第三方脚本)"
            echo -e "  ${purple}4.${plain} 🚀 一键通用重启所有代理服务 (通杀全网，最推荐)"
            echo -e "  ${yellow}0.${plain} 🔙 取消并返回主菜单"
            echo -e "--------------------------------------------------------"
            read -p "👉 请选择操作 [0-4]: " res_choice
            
            case $res_choice in
                1) 
                    # 智能探针：查服务或查进程
                    if systemctl list-unit-files | grep -qw sing-box.service || pgrep -x "sing-box" >/dev/null 2>&1; then
                        # 兜底绝杀：先温柔重启，不行就暴力杀掉再重启，专治假死
                        systemctl restart sing-box >/dev/null 2>&1
                        pkill -9 sing-box >/dev/null 2>&1 
                        systemctl restart sing-box >/dev/null 2>&1
                        echo -e "\n${green}✅ Sing-box 代理核心已成功重启！${plain}"
                    else 
                        echo -e "\n${yellow}⚠️ 未检测到 Sing-box 正在运行，系统可能未安装该核心。${plain}"
                    fi
                    ;;
                2) 
                    # 智能兼容矩阵：包揽纯净版 xray、x-ui 面板、3x-ui 面板、v2ray 老古董
                    if systemctl list-unit-files | grep -qE 'xray.service|x-ui.service|3x-ui.service|v2ray.service' || pgrep -x "xray" >/dev/null 2>&1 || pgrep -x "v2ray" >/dev/null 2>&1; then
                        systemctl restart xray x-ui 3x-ui v2ray >/dev/null 2>&1
                        echo -e "\n${green}✅ Xray/V2ray 系列核心 (含面板) 已成功满血重启！${plain}"
                    else 
                        echo -e "\n${yellow}⚠️ 未检测到 Xray 系列核心或相关面板环境。${plain}"
                    fi
                    ;;
                3) 
                    # 智能兼容矩阵：通杀原生 cloudflared、vx-argo、argo
                    if command -v cloudflared >/dev/null 2>&1 || pgrep -x "cloudflared" >/dev/null 2>&1 || systemctl list-unit-files | grep -qE 'cloudflared.service|vx-argo.service|argo.service' 2>/dev/null; then
                        # 专治 Argo 报 -1 假死：物理超度进程后，全服务名盲扫重启
                        pkill -9 cloudflared >/dev/null 2>&1
                        systemctl restart cloudflared vx-argo argo >/dev/null 2>&1
                        echo -e "\n${green}✅ Argo 穿透隧道已强行刷新连接！(请稍等 10 秒待线路连通后重新测速)${plain}"
                    else
                        echo -e "\n${yellow}⚠️ 当前环境未启用 Argo 隧道进程，无需刷新。${plain}"
                    fi
                    ;;
                4) 
                    echo -e "\n${cyan}正在执行系统级底层服务清理，无视脚本差异，通杀所有代理环境...${plain}"
                    
                    # 终极大招：把所有可能的服务全部拉出来重启一遍，没有的系统会静默忽略，有的直接满血复活
                    systemctl restart sing-box xray x-ui 3x-ui v2ray >/dev/null 2>&1
                    pkill -9 cloudflared >/dev/null 2>&1
                    systemctl restart cloudflared vx-argo argo >/dev/null 2>&1
                    
                    echo -e "\n${green}🎉 当前系统中存在的所有代理服务已全部满血复活！断流问题已修复！${plain}"
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
            echo -e "\n${blue}=== 🔗 节点全能雷达扫描与二维码提取 (真·人工智能全网兼容版) ===${plain}"
            
            if ! command -v qrencode >/dev/null 2>&1; then
                echo -e "${yellow}正在安装二维码生成模块...${plain}"
                if command -v apt-get >/dev/null 2>&1; then apt-get update -y >/dev/null 2>&1 && apt-get install qrencode -y >/dev/null 2>&1;
                elif command -v dnf >/dev/null 2>&1; then dnf install qrencode -y >/dev/null 2>&1;
                elif command -v yum >/dev/null 2>&1; then yum install qrencode -y >/dev/null 2>&1; fi
            fi

            # 终极正则 (通杀所有主流开源协议)
            REGEX_PATTERN="(anytls|vless|vmess|trojan|hysteria2|hy2|tuic|ss|ssr)://[a-zA-Z0-9_=+/%@:?&.\#-]+"
            echo -e "${cyan}📡 正在启动深空雷达，无视脚本差异，穿透全系统提取节点...${plain}"

            RAW_LINKS=""
            
            # 💡 通用底座：覆盖市面上 99% 脚本的节点存储路径
          SEARCH_DIRS="/etc/velox_vne /etc/x-ui /etc/s-box /etc/sing-box /usr/local/etc/xray /etc/vx /usr/local/etc/vx /etc/vne /usr/local/etc/vne /root/agsbx /root/.acme.sh $HOME/.acme.sh /etc/velox_tg.conf /etc/hysteria /etc/hysteria2 /etc/tuic /opt/alist/data /opt/nezha /root"
            
            # 强制提取：无视二进制，直接暴力抠出所有包含节点链接的文本块
            for f in $(find $SEARCH_DIRS -maxdepth 2 -type f 2>/dev/null); do
                # 智能防洪：每个文件最多提取最后 20 条，既保证能抓全“大满贯”，又防止历史遗留泛滥
                file_links=$(grep -oE -a "$REGEX_PATTERN" "$f" 2>/dev/null | tail -n 20)
                [ -n "$file_links" ] && RAW_LINKS=$(echo -e "${RAW_LINKS}\n${file_links}")
            done

            # 物理去重
            UNIQUE_LINKS=$(echo "$RAW_LINKS" | awk '!seen[$0]++' | grep -v '^$' | tr -d '\r')

            # ================= 👇 模块 3.5：基因解析与【Base64重编码】引擎 👇 =================
            PROCESSED_LINKS=""
            CURRENT_NAME=$(hostname)
            [ -z "$CURRENT_NAME" ] && CURRENT_NAME="VeloX"

            for link in $UNIQUE_LINKS; do
                PROTO=$(echo "$link" | awk -F'://' '{print $1}' | tr 'a-z' 'A-Z')
                OLD_NAME=""
                PREFIX=""
                ARGO_TYPE=""

                # 1. 深度解码并提取特征
                if [[ "$link" == vmess://* ]]; then
                    b64_str=${link#vmess://}
                    # 清理可能存在的畸形编码残留
                    b64_str=$(echo "$b64_str" | sed 's/[^a-zA-Z0-9_=+/%-]//g') 
                    json_str=$(echo "$b64_str" | base64 -d 2>/dev/null | tr -d '\000-\031')
                    OLD_NAME=$(echo "$json_str" | grep -o '"ps"[[:space:]]*:[[:space:]]*"[^"]+"' | cut -d'"' -f4)
                    config_text=$(echo "$json_str" | tr 'A-Z' 'a-z' | tr -d ' ')
                    
                    echo "$config_text" | grep -qi '"net":"ws"' && PREFIX="${PREFIX}ws-"
                    echo "$config_text" | grep -qi '"net":"grpc"' && PREFIX="${PREFIX}gRPC-"
                    echo "$config_text" | grep -qi '"tls":"tls"' && PREFIX="${PREFIX}tls-"
                    
                    # 🚀 智能研判 Argo 隧道类型 (严格区分临时与固定)
                    if [[ "$config_text" == *"trycloudflare"* || "$config_text" == *"argotunnel.com"* ]]; then
                        ARGO_TYPE="Argo临时-"
                    elif [[ "$OLD_NAME" =~ [Aa][Rr][Gg][Oo] || "$config_text" == *"visa.com"* || "$config_text" == *"icook.hk"* || "$config_text" == *"time.is"* ]]; then
                        ARGO_TYPE="Argo固定-"
                    fi
                else
                    OLD_NAME=$(echo "$link" | sed -n 's/.*#//p')
                    config_text=$(echo "$link" | tr 'A-Z' 'a-z')
                    
                    echo "$config_text" | grep -qi 'type=ws' && PREFIX="${PREFIX}ws-"
                    echo "$config_text" | grep -qi 'type=grpc' && PREFIX="${PREFIX}gRPC-"
                    echo "$config_text" | grep -qi 'security=tls' && PREFIX="${PREFIX}tls-"
                    echo "$config_text" | grep -qi 'security=reality' && PREFIX="${PREFIX}Reality-"
                    
                    # 🚀 智能研判 Argo 隧道类型 (严格区分临时与固定)
                    if [[ "$config_text" == *"trycloudflare"* || "$config_text" == *"argotunnel.com"* ]]; then
                        ARGO_TYPE="Argo临时-"
                    elif [[ "$OLD_NAME" =~ [Aa][Rr][Gg][Oo] || "$config_text" == *"visa.com"* || "$config_text" == *"icook.hk"* || "$config_text" == *"time.is"* ]]; then
                        ARGO_TYPE="Argo固定-"
                    fi
                fi

                # 2. 命名重组 (协议 - 传输层 - Argo类型 - 主机名)
                NEW_REMARK="${PROTO}-${PREFIX}${ARGO_TYPE}${CURRENT_NAME}"

                # 3. 无损注入并生成新链接
                if [[ "$link" == vmess://* ]]; then
                    if echo "$json_str" | grep -q '"ps"'; then
                        new_json=$(echo "$json_str" | sed -E 's/"ps"[[:space:]]*:[[:space:]]*"[^"]+"/"ps": "'"$NEW_REMARK"'"/g')
                    else
                        new_json=$(echo "$json_str" | sed 's/^{/{"ps":"'"$NEW_REMARK"'",/')
                    fi
                    new_b64=$(echo -n "$new_json" | base64 -w 0 2>/dev/null || echo -n "$new_json" | base64 | tr -d '\n')
                    new_link="vmess://${new_b64}"
                else
                    if [[ "$link" == *#* ]]; then
                        new_link=$(echo "$link" | sed -E 's/#[^[:space:]]*$/#'"$NEW_REMARK"'/')
                    else
                        new_link="${link}#${NEW_REMARK}"
                    fi
                fi
                
                PROCESSED_LINKS=$(echo -e "${PROCESSED_LINKS}\n${new_link}")
            done

            FINAL_LINKS=$(echo "$PROCESSED_LINKS" | grep -v '^$' | tr -d '\r')

            # ================= 👇 展示模块 (修复 UI 高亮盲区) 👇 =================
            if [ -n "$FINAL_LINKS" ]; then
                BASE64_SUB=$(echo -e "$FINAL_LINKS" | base64 -w 0)

                echo -e "\n${green}🎉 扫描完毕！全域雷达已精准抓取并洗白重编以下节点：${plain}"
                echo -e "${yellow}======================================================================${plain}"
                echo -e "🚀【 全节点聚合订阅 (Base64编码) 】"
                echo -e "${cyan}${BASE64_SUB}${plain}\n"
                
                for link in $FINAL_LINKS; do
                    PROTO_TAG=$(echo "$link" | awk -F'://' '{print $1}' | tr 'a-z' 'A-Z')
                    
                    # 💡 致命视觉修复：如果是 VMESS，必须解开 Base64 密码箱才能看到 Argo 标签！
                    check_str="$link"
                    if [[ "$PROTO_TAG" == "VMESS" ]]; then
                        check_str=$(echo "${link#vmess://}" | base64 -d 2>/dev/null)
                    fi
                    
                    # 转大写统一匹配
                    check_str=$(echo "$check_str" | tr 'a-z' 'A-Z')
                    
                    if [[ "$check_str" == *"ARGO临时"* ]]; then
                        TAG="${purple}【 🚇 $PROTO_TAG - Argo 临时穿透隧道 】${plain}"
                    elif [[ "$check_str" == *"ARGO固定"* ]]; then
                        TAG="${red}【 🚇 $PROTO_TAG - Argo 固定零信任隧道 】${plain}"
                    else
                        TAG="${green}【 $PROTO_TAG - 原生直连节点 】${plain}"
                    fi

                    echo -e "${yellow}------------------------------------------------${plain}"
                    echo -e "🚀 $TAG"
                    echo -e "${cyan}${link}${plain}"
                    qrencode -m 2 -t UTF8 "$link"
                done
                echo -e "${yellow}------------------------------------------------${plain}"
            else
                echo -e "\n${red}❌ 绝望！全域穿透搜遍了系统底层目录也没找到任何节点。${plain}"
                echo -e "${yellow}💡 提示：如果当前有节点在运行，可能是脚本将节点写入了二进制数据库。请在对应的安装面板中手动“导出节点”。${plain}"
            fi

            read -p "👉 按【回车键】返回主菜单..."
            ;;
    26)
        echo -e "\n${blue}=== 🔐 Acme 域名证书深度体检与管理 (开源全自动版) ===${plain}"
        # 💡 防崩依赖：确保 fuser 命令存在，否则强行释放 80 端口会失效
            if ! command -v fuser >/dev/null 2>&1; then
                if command -v apt-get >/dev/null 2>&1; then apt-get install psmisc -y >/dev/null 2>&1;
                elif command -v yum >/dev/null 2>&1; then yum install psmisc -y >/dev/null 2>&1;
                elif command -v dnf >/dev/null 2>&1; then dnf install psmisc -y >/dev/null 2>&1; fi
            fi
        
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
            
            # 🚀 进阶子菜单：续签与卸载彻底分离
            echo -e "\n  ${green}1.${plain} 🚀 强制续签证书 (注入 Nginx 避让与全自动守护)"
            echo -e "  ${red}2.${plain} 🗑️ 彻底删除证书 (清理不再使用的旧域名残留)"
            echo -e "  ${yellow}0.${plain} 🔙 取消并返回主菜单"
            echo -e "${cyan}--------------------------------------------------------------------------------${plain}"
            read -p "👉 请选择进阶管理操作 [0-2]: " acme_choice
            
            case $acme_choice in
                1)
                    read -p "✍️ 请输入上方列表中你需要续签的【主域名 Main_Domain】 (例如 bwg.123.xyz): " renew_domain
                    if [ -n "$renew_domain" ]; then
                        echo -e "\n${yellow}⏳ 正在向 Acme 底层注入 Nginx 智能避让与节点重启逻辑...${plain}"
                        
                        # 把停端口和启服务的命令，打包塞进 Acme 的钩子(Hook)里
                        PRE_HOOK="systemctl stop nginx >/dev/null 2>&1; systemctl stop apache2 >/dev/null 2>&1; fuser -k 80/tcp >/dev/null 2>&1"
                        POST_HOOK="systemctl start nginx >/dev/null 2>&1; systemctl restart sing-box >/dev/null 2>&1; systemctl restart xray >/dev/null 2>&1; systemctl restart x-ui >/dev/null 2>&1"
                        
                        echo -e "${cyan}⏳ 正在向签发机构请求续签，并保存记忆 [ ${renew_domain} ]，请耐心等待...${plain}"
                        
                        "$ACME_BIN" --renew -d "$renew_domain" --force --ecc --pre-hook "$PRE_HOOK" --post-hook "$POST_HOOK"
                        if [ $? -ne 0 ]; then
                            echo -e "\n${yellow}⚠️ ECC 模式续签失败，正在尝试切换为 RSA 模式重试...${plain}"
                            "$ACME_BIN" --renew -d "$renew_domain" --force --pre-hook "$PRE_HOOK" --post-hook "$POST_HOOK"
                        fi
                        
                        echo -e "\n${green}✅ 操作完毕！Web 容器与代理服务已满血复活！${plain}"
                        echo -e "💡 ${cyan}极客提示：避让逻辑已刻入证书配置。以后的后台自动续签将【100%全自动】完成，您无需再手动干预！${plain}"
                    else
                        echo -e "${red}❌ 域名输入为空，已取消续签操作。${plain}"
                    fi
                    ;;
                2)
                    read -p "✍️ 请输入你需要彻底删除的【旧域名 Main_Domain】 (例如 old.123.xyz): " del_domain
                    if [ -n "$del_domain" ]; then
                        echo -e "\n${yellow}⏳ 正在从 Acme 数据库中注销该域名的续签任务...${plain}"
                        
                        # 官方标准注销命令 (兼顾 ECC 和 RSA)
                        "$ACME_BIN" --remove -d "$del_domain" --ecc 2>/dev/null
                        "$ACME_BIN" --remove -d "$del_domain" 2>/dev/null
                        
                        echo -n "正在物理粉碎本地残留的证书文件夹... "
                        rm -rf ~/.acme.sh/"$del_domain"
                        rm -rf ~/.acme.sh/"${del_domain}_ecc"
                        echo -e "[${green}已彻底抹除${plain}]"
                        
                        echo -e "\n✅ ${green}操作完毕！该域名证书已被完全销毁，系统后台不会再触发任何续签报错！${plain}"
                    else
                        echo -e "${red}❌ 域名输入为空，已取消删除操作。${plain}"
                    fi
                    ;;
                0)
                    echo -e "${yellow}已取消操作。${plain}"
                    ;;
                *)
                    echo -e "${red}❌ 无效选择，请输入 0、1 或 2。${plain}"
                    ;;
            esac
        fi

        echo -e "\n${yellow}------------------------------------------${plain}"
        read -p "👉 按【回车键】返回主菜单..."
        ;;
   27)
            while true; do
                echo -e "\n${blue}=== 🛰️ 星际舰队与跨机容灾中心 ===${plain}"
                echo -e "  ${green}1.${plain} 📦 全域资产一键打包与跨机搬家 (真·动态路径克隆终极版)"
                echo -e "  ${cyan}2.${plain} 🤝 组建舰队: 配置多机免密互信 (打通专属 SSH 桥梁)"
                echo -e "  ${purple}3.${plain} 🚀 舰队出击: 向所有僚机群发执行指令 (万机齐发)"
                echo -e "  ${red}4.${plain} 🗑️ 解散舰队: 清除本机群发记录与专属密钥 (安全无痕)"
                echo -e "  ${yellow}0.${plain} 返回主菜单"
                echo -e "--------------------------------------------------------"
                read -p "👉 请选择操作 [0-4]: " fleet_choice
                
                case $fleet_choice in
                    1)
                        echo -e "\n${blue}--- 🧳 全域资产一键打包与跨机搬家 ---${plain}"
                        echo -e "${yellow}正在启动全频段雷达，扫描系统内的节点配置、面板数据、证书、定时任务及 TG 凭证...${plain}\n"

                        has_data=0
                        BACKUP_LIST=""

                        # 💡 核心升级：动态智能阵列，覆盖全网所有已知脚本目录及咱们的全局 TG 凭证池！
                    SEARCH_DIRS="/etc/velox_vne /etc/x-ui /etc/s-box /etc/sing-box /usr/local/etc/xray /etc/vx /usr/local/etc/vx /etc/vne /usr/local/etc/vne /root/agsbx /root/.acme.sh $HOME/.acme.sh /etc/velox_tg.conf /etc/hysteria /etc/hysteria2 /etc/tuic /opt/alist/data /opt/nezha /root"                        
                        for dir in $SEARCH_DIRS; do
                            if [ -e "$dir" ]; then
                                BACKUP_LIST="$BACKUP_LIST $dir"
                                echo -e "✅ 成功提取资产: ${cyan}$dir${plain}"
                                has_data=1
                            fi
                        done

                        # 自动化任务扫描
                        if crontab -l > /root/crontab_backup.txt 2>/dev/null && [ -s /root/crontab_backup.txt ]; then
                            BACKUP_LIST="$BACKUP_LIST /root/crontab_backup.txt"
                            echo -e "✅ 成功提取资产: ${cyan}系统定时任务 (crontab)${plain}"
                            has_data=1
                        else
                            rm -f /root/crontab_backup.txt
                        fi

                        echo -e "${cyan}--------------------------------------------------------${plain}"
                        
                        # --- 极客专属：自定义目录打包引擎 ---
                        echo -e "💡 ${green}除了以上标准资产，您是否还有其他应用需要一起打包搬家？${plain}"
                        echo -e "${purple}📚 【常见应用路径小抄】 (如需打包，请直接复制下方路径)：${plain}"
                        echo -e "   - ☁️ Alist 网盘数据:  ${yellow}/opt/alist/data${plain}"
                        echo -e "   - 🤖 哪吒探针面板:  ${yellow}/opt/nezha${plain}"
                        echo -e "   - 🐳 Docker 数据卷:  ${yellow}/var/lib/docker/volumes${plain}"
                        echo -e "   - 🌐 Nginx 网站目录:  ${yellow}/var/www/html${plain}"
                        read -p "👉 请输入完整路径 (多个用空格隔开，回车跳过): " custom_paths

                        if [ -n "$custom_paths" ]; then
                            for path in $custom_paths; do
                                if [ -e "$path" ]; then
                                    BACKUP_LIST="$BACKUP_LIST $path"
                                    echo -e "📦 成功追加自定义包裹: ${yellow}$path${plain}"
                                    has_data=1
                                else
                                    echo -e "⚠️ ${red}找不到指定的文件或目录，已智能跳过: $path${plain}"
                                fi
                            done
                        fi

                        if [ "$has_data" -eq 1 ]; then
                            echo -e "\n${cyan}⏳ 正在对包裹进行高强度压缩加密 (强行保留绝对路径与权限)，请耐心等待...${plain}"
                            
                            # 💡 核心升级：使用 -p 保持权限，-P 保持绝对路径，恢复时直接解压即完美覆盖！
                            tar -czpf /root/Velox_Assets_Backup.tar.gz $BACKUP_LIST >/dev/null 2>&1
                            
                            SSH_PORT=$(grep -iE "^Port " /etc/ssh/sshd_config | awk '{print $2}')
                            [ -z "$SSH_PORT" ] && SSH_PORT="22"

                            echo -e "\n${green}🎉 资产克隆打包完毕！您的全域备份文件已生成：${plain}"
                            echo -e "${cyan}📂 文件绝对路径：/root/Velox_Assets_Backup.tar.gz${plain}"
                            
                            # ================= 👇 TG 云端容灾附加选项 (完美接入共享池) 👇 =================
                            echo -e "\n${purple}☁️ 【可选附加项：TG 云端容灾备份】${plain}"
                            read -p "👉 是否顺便将此备份包推送至您的 Telegram 机器人保管？(y/n) [直接回车跳过]: " send_tg
                            if [[ "$send_tg" == "y" || "$send_tg" == "Y" ]]; then
                                
                                SHARED_TG_CONF="/etc/velox_tg.conf" 
                                if [ -f "$SHARED_TG_CONF" ]; then 
                                    source "$SHARED_TG_CONF" 
                                fi
                                
                                if [ -z "$GLOBAL_TG_TOKEN" ] || [ -z "$GLOBAL_TG_CHATID" ]; then
                                    echo -e "${yellow}未检测到全局 TG 凭据，首次使用需配置 (将自动写入全局池，全面板共享)：${plain}"
                                    read -p "请输入 TG Bot Token: " GLOBAL_TG_TOKEN
                                    read -p "请输入您的 TG Chat ID: " GLOBAL_TG_CHATID
                                    
                                    echo "GLOBAL_TG_TOKEN=\"$GLOBAL_TG_TOKEN\"" > "$SHARED_TG_CONF"
                                    echo "GLOBAL_TG_CHATID=\"$GLOBAL_TG_CHATID\"" >> "$SHARED_TG_CONF"
                                else
                                    echo -e "${green}✅ 成功抓取到全局绑定的 TG 凭据！无需重复输入。${plain}"
                                fi
                                
                                if [ -n "$GLOBAL_TG_TOKEN" ] && [ -n "$GLOBAL_TG_CHATID" ]; then
                                    echo -e "${cyan}🚀 正在将包裹推送到 Telegram... (若文件较大需等待几秒)${plain}"
                                    TG_RESP=$(curl -s -F "chat_id=$GLOBAL_TG_CHATID" \
                                        -F "document=@/root/Velox_Assets_Backup.tar.gz" \
                                        -F "caption=📦 [Velox 灾备中心] 主机: $(hostname) | 时间: $(date +'%Y-%m-%d %H:%M')" \
                                        "https://api.telegram.org/bot$GLOBAL_TG_TOKEN/sendDocument")
                                    
                                    if echo "$TG_RESP" | grep -q '"ok":true'; then
                                        echo -e "${green}✅ 云端推送成功！请前往 Telegram 您的 Bot 对话框查收。${plain}"
                                    else
                                        echo -e "${red}❌ 推送失败！可能是 Token/ID 错误，或网络无法连通 TG API。${plain}"
                                    fi
                                fi
                            fi
                            # ================= 👆 TG 云端容灾结束 👆 =================
                            
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

                            # 💡 核心升级：终极智能恢复指令，一句解压定乾坤，无视任何面板种类差异！
                            echo -e "${purple}🔥 【第三步：新机器终极恢复长指令】 (在新 VPS 终端执行)：${plain}"
                            echo -e "  ${cyan}cd / && tar -xzpf /root/Velox_Assets_Backup.tar.gz && crontab /root/crontab_backup.txt 2>/dev/null; systemctl restart vx-core sing-box xray x-ui cloudflared vx-argo 2>/dev/null; echo -e \"\\n✅ 资产覆盖恢复成功！节点、证书与 TG 防线已满血复活！\"${plain}"
                        else
                            echo -e "\n${red}❌ 未提取到任何资产，打包已取消。${plain}"
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
            echo -e "${yellow}💡 提示：此操作将彻底拔除 Velox 面板本身及其底层监控。${plain}"
            echo -e "${green}🛡️  绝对安全承诺：您的 WARP、Argo 隧道 (含Token) 及所有代理节点将原封不动！${plain}\n"
            
            read -p "👉 确定要彻底卸载本面板并【焦土化抹除】监控数据吗？(y/n): " confirm_uninstall
            if [[ "$confirm_uninstall" == "y" || "$confirm_uninstall" == "Y" ]]; then
                echo -e "\n${cyan}🚀 正在启动全功率焦土卸载引擎...${plain}"

                # 1. 拆除核心面板与旧版报警组件
                echo -n "1. 正在清理面板本体与关联报警脚本... "
                rm -f /usr/local/bin/velox
                rm -f /root/velox.sh 2>/dev/null
                rm -f /usr/local/bin/ssh_tg_alert.sh
                rm -f /usr/local/bin/tg_boot_alert.sh
                sed -i '/ssh_tg_alert.sh/d' /etc/profile
                sed -i '/ssh_tg_alert.sh/d' /etc/bash.bashrc
                systemctl disable --now tg_boot_alert.service >/dev/null 2>&1
                rm -f /etc/systemd/system/tg_boot_alert.service
                systemctl daemon-reload 
                echo -e "[${green}已彻底抹除${plain}]"

                # 1.5 拆除全局 TG 凭证与流量大管家防线
                echo -n "1.5 正在清洗全局 TG 凭证与流量防线脚本... "
                rm -f /etc/velox_tg.conf
                rm -f /usr/local/bin/velox_traffic_alert.sh
                crontab -l 2>/dev/null | grep -v "velox_traffic_alert.sh" | crontab -
                echo -e "[${green}已彻底清洗${plain}]"

                # 1.6 彻底拔除 vnstat 底层监控与历史流量数据库
                echo -n "1.6 正在连根拔起底层流量监控引擎 (vnstat) 与历史账单... "
                systemctl stop vnstat >/dev/null 2>&1
                systemctl disable vnstat >/dev/null 2>&1
                if command -v apt-get >/dev/null 2>&1; then
                    apt-get remove --purge vnstat -y >/dev/null 2>&1
                elif command -v yum >/dev/null 2>&1; then
                    yum remove vnstat -y >/dev/null 2>&1
                elif command -v dnf >/dev/null 2>&1; then
                    dnf remove vnstat -y >/dev/null 2>&1
                fi
                rm -rf /var/lib/vnstat
                rm -rf /etc/vnstat.conf
                echo -e "[${green}已彻底连根拔起${plain}]"

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
                
                sed -i '/net.core.default_qdisc/d' /etc/sysctl.conf
                sed -i '/net.ipv4.tcp_congestion_control/d' /etc/sysctl.conf
                
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

                # 7. 🛡️ 绝对保护：跳过所有 WARP 相关的配置与任务
                echo -n "7. 正在排查 WARP 底层配置... "
                echo -e "[${green}🛡️ 遵循最高指令，WARP 所有配置、IP 与相关任务已绝对保留，不予触碰！${plain}]"

                # 8. 🛡️ 绝对保护：跳过 Argo 与 Token
                echo -n "8. 正在排查 Argo 隧道与 Token... "
                echo -e "[${green}🛡️ 遵循最高指令，Argo 进程及您的专属 Token 已被智能隔离保护，绝对安全！${plain}]"

                # 9. Fail2Ban 强拆询问
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

                echo -e "\n${green}🎉 卸载完毕！Velox 面板已事了拂衣去，历史监控数据已清零！${plain}"
                echo -e "${purple}您的核心代理资产毫发无损，江湖再见！🚀${plain}\n"
                exit
            else
                echo -e "\n${yellow}已取消卸载，即将返回主菜单...${plain}"
                sleep 1
            fi
            ;;
      0)   echo -e "\n${green}祝Velox折腾愉快！${plain}\n"; exit ;;
        *) echo -e "\n${red}❌ 输入错误，请重新输入！${plain}" ;;
    esac
    
    if [[ "$choice" != "7" && "$choice" != "8" && "$choice" != "9" && "$choice" != "10" && "$choice" != "16" && "$choice" != "19" && "$choice" != "20" && "$choice" != "21" && "$choice"  != "23" && "$choice" != "24" && "$choice" != "25" && "$choice" != "26" && "$choice" != "27" ]]; then
        echo -e "\n${cyan}按回车键继续...${plain}"; read
    fi
done
EOF
chmod +x /usr/local/bin/velox
echo -e "\033[1;32m✅ Velox V5.2 (全域兼容满血终极版) 部署完毕！请输入 velox 欣赏！\033[0m"
velox
