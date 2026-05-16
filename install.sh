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

if command -v apt-get >/dev/null 2>&1; then
    PKG_INSTALL="apt-get install -yqq"
    PKG_REMOVE="apt-get remove --purge -yqq"
    PKG_CLEAN="apt-get autoremove -yqq && apt-get clean"
elif command -v yum >/dev/null 2>&1; then
    PKG_INSTALL="yum install -yq"
    PKG_REMOVE="yum remove -yq"
    PKG_CLEAN="yum autoremove -yq && yum clean all"
else
    echo -e "${red}❌ 致命拦截：仅支持 Ubuntu/Debian/CentOS 系，当前异端系统拒绝执行！${plain}"
    exit 1
fi

require_deps() {
    local missing=()
    for pkg in "$@"; do
        # 智能判定：如果命令不存在，才加入缺失清单
        if ! command -v "$pkg" >/dev/null 2>&1; then
            missing+=("$pkg")
        fi
    done
    
    # 提前返回逻辑 (Early Return)
    if [ ${#missing[@]} -eq 0 ]; then return 0; fi
    
    echo -e "${yellow}⚙️ 正在向底层注入缺失装甲: ${missing[*]}...${plain}"
    $PKG_INSTALL "${missing[@]}" >/dev/null 2>&1
}

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

# 16号 流量大管家状态检测
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
echo -e "   👨‍💻 作者GitHub项目 : ${blue}github.com/pwenxiang51-wq${plain}"
echo -e "   📝 作者Velo.x博客 : ${blue}222382.xyz${plain}"
echo -e "   ✈️ 作者Telegram   : ${blue}@Velox95${plain}"
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
    echo -e "  ${cyan}15.${plain} 🚨 ${cyan}设置/管理 SSH 异地登录 TG 报警 (含开机秒报)${plain} ${tg_stat}"
    
    # --- 第四板块：系统防御与自动化运维 ---
    echo -e "\n${blue}[ 板块四：⚙️ 系统防御与自动化运维 ]${plain}"
    echo -e "  ${purple}16.${plain} 📈 ${purple}Velox 流量大管家 (防扣费/防停机/月账单)${plain} ${traffic_stat}"
    echo -e "  ${purple}17.${plain} 💽 ${purple}自定义管理虚拟内存 Swap (1G小鸡救星)${plain}"
    echo -e "  ${purple}18.${plain} 📝 ${purple}修改服务器主机名 (给 VPS 轻松改名)${plain}"
    echo -e "  ${purple}19.${plain} 🔄 ${purple}一键更新系统软件库 (智能适配全系统)${plain}"
    echo -e "  ${purple}20.${plain} 🚨 ${purple}SSH 智能防盗门与防御中心 (机枪塔/Fail2Ban)${plain}" ${f2b_stat}"
   
    # --- 第五板块：全域高维容灾与资产审计 ---
    echo -e "\n${blue}[ 板块五：📡 全域高维容灾与资产审计 ]${plain}"
    echo -e "  ${yellow}21.${plain} ⏱️  ${yellow}时空调度中心 (设定 VPS 半夜自动重启 / 自动刷新 WARP)${plain}"
    echo -e "  ${yellow}22.${plain} 🔐 ${yellow}Acme 证书管理 (硬核全自动避让 / 到期查询 / 强制续签)${plain}"
    echo -e "  ${yellow}23.${plain} 🧳 ${yellow}模块化资产备份 (精准按需克隆 / 星际舰队 / TG 云端容灾)${plain}"
    echo -e "  ${yellow}24.${plain} 🔍 ${yellow}全域资产雷达 (多维内核级 Socket 嗅探 / 隐藏进程爆破)${plain}"
    
    echo -e "${cyan}  ---------------------------------------------------${plain}"
    echo -e "  ${red}U.${plain}  🗑️  ${red}一键卸载本面板 (清理无痕)${plain}"
    echo -e "  ${red}0.${plain}  ❌ ${red}退出面板${plain}"
    echo -e "${cyan}=====================================================${plain}"
    
    echo -ne "请选择操作 [${green}1${plain}-${yellow}24${plain}, ${red}U${plain}, ${red}0${plain}]: "
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
        echo -e "\n${blue}=== 🌐 WARP 与 Argo 隧道出站详情 (基因级侦测装甲) ===${plain}"
        echo -e "${yellow}正在调用底层雷达侦测网络出站链路，请稍候...${plain}\n"
        
        # ================= 👇 WARP 智能探测 (防假死毫秒级探测) 👇 =================
        echo -e "${cyan}[ WARP 解锁状态 ]${plain}"
        warp_status="off"
        warp_ip=""
        proxy_mode=""

        if systemctl is-active --quiet warp-go 2>/dev/null || systemctl is-active --quiet wg-quick@wgcf 2>/dev/null || systemctl is-active --quiet warp-svc 2>/dev/null; then
            
            # 1. 测全局直连 (加 timeout 防止死锁假死)
            trace=$(timeout 3 curl -s4 https://www.cloudflare.com/cdn-cgi/trace 2>/dev/null || echo "error")
            if echo "$trace" | grep -q "warp=on"; then
                warp_status="on"
                warp_ip=$(echo "$trace" | grep ip= | cut -d= -f2)
            fi

            # 2. 测虚拟网卡 (WG 衍生版)
            if [[ "$warp_status" == "off" ]]; then
                for iface in wgcf warp wg0; do
                    if ip link show "$iface" >/dev/null 2>&1; then
                        trace=$(timeout 3 curl --interface "$iface" -s4 https://www.cloudflare.com/cdn-cgi/trace 2>/dev/null || echo "error")
                        if echo "$trace" | grep -q "warp=on"; then
                            warp_status="on"
                            warp_ip=$(echo "$trace" | grep ip= | cut -d= -f2)
                            proxy_mode=" ${purple}(虚拟网卡路由: $iface)${plain}"
                            break
                        fi
                    fi
                done
            fi

            # 3. 测本地 SOCKS5 代理 (全自动动态抓取，绝不写死端口)
            if [[ "$warp_status" == "off" ]]; then
                proxy_ports=$(ss -nltp 2>/dev/null | grep -E 'warp-svc|warp-go' | awk '{print $4}' | grep -E '127\.0\.0\.1|::1' | awk -F':' '{print $NF}' | sort -u)
                for port in $proxy_ports; do
                    trace=$(timeout 3 curl -x socks5h://127.0.0.1:$port -s4 https://www.cloudflare.com/cdn-cgi/trace 2>/dev/null || echo "error")
                    if echo "$trace" | grep -q "warp=on"; then
                        warp_status="on"
                        warp_ip=$(echo "$trace" | grep ip= | cut -d= -f2)
                        proxy_mode=" ${purple}(SOCKS5 局部代理 | 自动捕获端口: $port)${plain}"
                        break
                    fi
                done
            fi

            if [[ "$warp_status" == "on" ]]; then
                echo -e " 🛡️  WARP 状态 : ${green}已开启并成功接管流量 ✅${plain}"
                echo -e " 🛡️  出口 IP   : ${cyan}${warp_ip}${plain} (Cloudflare 节点)${proxy_mode}"
            else
                echo -e " 🛡️  WARP 状态 : ${yellow}服务已运行但未能成功接管流量 (请检查路由或代理配置) ⚠️${plain}"
            fi
        else
            echo -e " 🛡️  WARP 状态 : ${red}未开启或未部署 ❌${plain}"
        fi

        # ================= 👇 Argo 智能探测 (系统内核级穿透) 👇 =================
        echo -e "\n${cyan}[ Argo 隧道状态 ]${plain}"
        
        # 提取活跃的 Argo 服务名
        ACTIVE_ARGO_SVC=""
        for svc in cloudflared velox-argo argo; do
            if systemctl is-active --quiet "$svc" 2>/dev/null; then ACTIVE_ARGO_SVC="$svc"; break; fi
        done

        if [ -n "$ACTIVE_ARGO_SVC" ] || pgrep -x "cloudflared" >/dev/null 2>&1; then
            echo -e " 🚇 Argo 进程 : ${green}满血运行中 ✅${plain}"
            
            # 神级嗅探 1：直接查杀本地实体配置文件 (最稳固的防线)
            if [ -f "/etc/cloudflared/config.yml" ] && grep -q "tunnel:" "/etc/cloudflared/config.yml"; then
                tunnel_id=$(grep "tunnel:" /etc/cloudflared/config.yml | awk '{print $2}' | tr -d '"' | tr -d "'")
                echo -e " 🔗 链路模式 : ${purple}本地配置守护模式 (高级固定隧道)${plain}"
                echo -e " 🆔 隧道 UUID : ${cyan}${tunnel_id}${plain} ${green}✅${plain}"
            else
                # 神级嗅探 2：无视日志，直接让 Systemd 交出启动参数里的 Token
                argo_token_live=""
                if [ -n "$ACTIVE_ARGO_SVC" ]; then
                    argo_token_live=$(systemctl cat "$ACTIVE_ARGO_SVC" 2>/dev/null | grep -oE 'ey[A-Za-z0-9_-]{50,}' | head -n 1)
                fi
                [ -z "$argo_token_live" ] && argo_token_live=$(ps -ef | grep cloudflared | grep -v grep | grep -oE "ey[A-Za-z0-9_-]{50,}" | head -n 1)

                if [ -n "$argo_token_live" ]; then
                    masked_token="${argo_token_live:0:6}******[系统级智能打码]******${argo_token_live: -6}"
                    echo -e " 🔗 链路模式 : ${purple}Token 守护模式 (固定隧道)${plain}"
                    echo -e " 🔑 绑定凭证 : ${cyan}${masked_token}${plain} ${green}✅${plain}"
                else
                    # 神级嗅探 3：确认是临时穿透隧道，精准捕获 URL
                    argo_url=$(journalctl _COMM=cloudflared --no-pager -n 100 2>/dev/null | grep -oE "https://[a-zA-Z0-9.-]+\.trycloudflare\.com" | tail -n 1 | sed 's/https:\/\///')
                    [ -z "$argo_url" ] && [ -n "$ACTIVE_ARGO_SVC" ] && argo_url=$(journalctl -u "$ACTIVE_ARGO_SVC" --no-pager -n 100 2>/dev/null | grep -oE "https://[a-zA-Z0-9.-]+\.trycloudflare\.com" | tail -n 1 | sed 's/https:\/\///')
                    
                    if [ -n "$argo_url" ]; then
                        echo -e " 🔗 链路模式 : ${cyan}https://${argo_url}${plain} ${yellow}(临时穿透隧道)${plain}"
                    else
                        echo -e " 🔗 链路模式 : ${purple}隐秘守护模式或未知状态 ${plain}${yellow}(未嗅探到明文 Token 或 URL)${plain}"
                        echo -e " 💡 ${yellow}极客提示：若您使用固定隧道，请前往 Cloudflare Zero Trust 后台查看解析状态。${plain}"
                    fi
                fi
            fi
        else
            echo -e " 🚇 Argo 进程 : ${red}未运行 ❌${plain}"
        fi

        # --- 开源进阶功能：一键部署、更换或彻底物理粉碎 Argo ---
        echo -e "\n${cyan}💡 进阶管理：您可以全自动部署、更换或彻底卸载 Argo 固定隧道${plain}"
        echo -e "  ${green}1.${plain} 🚀 部署或更换 Token (并设为开机绝对自启)"
        echo -e "  ${red}2.${plain} 🗑️ 彻底卸载并清除 Argo 守护进程 (焦土化清理)"
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
                
                # 暴力肃清旧环境 (无视服务名差异，全域扫荡)
                systemctl stop cloudflared argo velox-argo >/dev/null 2>&1
                systemctl disable cloudflared argo velox-argo >/dev/null 2>&1
                cloudflared service uninstall >/dev/null 2>&1
                rm -f /etc/systemd/system/argo.service /etc/systemd/system/velox-argo.service
                
                cloudflared service install "$argo_token" >/dev/null 2>&1
                systemctl enable --now cloudflared >/dev/null 2>&1
                echo -e "[${green}部署成功！已满血接入 Cloudflare 零信任网络 ✅${plain}]"
            else
                echo -e "${red}❌ Token 不能为空，已取消操作。${plain}"
            fi

        elif [[ "$argo_action" == "2" ]]; then
            echo -e "\n${blue}=== 🗑️ 彻底卸载 Argo 固定隧道 ===${plain}"
            echo -n "正在停止并焦土化清理系统底层的 Argo 守护进程... "
            
            ACTIVE_ARGO_SVC=""
            for svc in cloudflared velox-argo argo; do
                if systemctl is-active --quiet "$svc" 2>/dev/null; then ACTIVE_ARGO_SVC="$svc"; break; fi
            done

            if [ -n "$ACTIVE_ARGO_SVC" ] || command -v cloudflared >/dev/null 2>&1 || pgrep -x "cloudflared" >/dev/null 2>&1; then
                systemctl stop cloudflared argo velox-argo >/dev/null 2>&1
                systemctl disable cloudflared argo velox-argo >/dev/null 2>&1
                cloudflared service uninstall >/dev/null 2>&1
                rm -f /etc/systemd/system/argo.service /etc/systemd/system/velox-argo.service
                rm -rf /etc/cloudflared
                pkill -9 cloudflared >/dev/null 2>&1
                systemctl daemon-reload
                echo -e "[${green}清理完毕，Argo 已彻底物理粉碎 ✅${plain}]"
            else
                echo -e "[${yellow}未检测到安装，无需清理 ⚠️${plain}]"
            fi
        fi
        
        echo -e "\n${yellow}提示：如需修复以上出站异常，请返回主菜单使用第 23 或 24 项。${plain}"
        echo -e "${yellow}------------------------------------------${plain}"
        read -p "👉 按【回车键】继续..."
        ;;
        
    9)
        echo -e "\n${blue}=== 🚀 BBR 状态诊断与高级网络内核调优 (Ubuntu 模块化装甲版) ===${plain}"
        # 🚀 核心升级：架构防爆护盾 
        check_virt_safe "BBR 内核拥塞算法修改" || { read -p "👉 按【回车键】继续..."; continue; }

        # 1. 深度探测系统内核与当前状态
        kernel_version=$(uname -r | awk -F- '{print $1}')
        kernel_main=$(echo $kernel_version | awk -F. '{print $1"."$2}')
        current_cc=$(sysctl net.ipv4.tcp_congestion_control 2>/dev/null | awk '{print $3}')
        current_qdisc=$(sysctl net.core.default_qdisc 2>/dev/null | awk '{print $3}')
        echo -e "🔎 ${cyan}当前系统内核版本:${plain} ${kernel_version}"
        echo -e "🚥 ${cyan}当前拥塞控制算法 (CC):${plain} ${yellow}${current_cc}${plain}"
        echo -e "🚥 ${cyan}当前队列调度算法 (Qdisc):${plain} ${yellow}${current_qdisc}${plain}"
        echo -e "${blue}---------------------------------------------------${plain}"

        # 定义 Velox 专属内核配置文件路径 (极客模块化管理)
        BBR_CONF="/etc/sysctl.d/99-velox-bbr.conf"

        if [[ "$current_cc" == "bbr" ]]; then
            echo -e "${green}✅ BBR 底层加速已完美激活，网络正处于高性能模式！${plain}"
            
            if [[ "$current_qdisc" != *"fq"* ]]; then
                echo -e "${yellow}⚠️ 提示：检测到当前 Qdisc 并非 fq，建议卸载后重新一键开启以达到 BBR 最佳性能。${plain}"
            fi
            
            read -p "👉 是否需要【彻底关闭并无痕卸载】BBR 加速？(y/n): " remove_bbr
            if [[ "${remove_bbr,,}" == "y" ]]; then
                echo -e "\n${yellow}正在执行 BBR 卸载程序，物理粉碎独立配置...${plain}"
                
                # 模块化卸载：直接删文件，绝不污染主配置
                rm -f "$BBR_CONF"
                
                # 动态恢复内存中的默认值
                sysctl -w net.ipv4.tcp_congestion_control=cubic >/dev/null 2>&1
                sysctl -w net.core.default_qdisc=fq_codel >/dev/null 2>&1
                sysctl --system >/dev/null 2>&1
                echo -e "${green}✅ BBR 已彻底无痕关闭！系统已恢复为 Ubuntu 标准算法。${plain}"
            fi
        else
            echo -e "${red}⚠️ 检测到当前未开启 BBR 加速！${plain}"
            
            # 内核版本兜底防线
            if awk -v ver="$kernel_main" 'BEGIN {if (ver < 4.9) exit 0; else exit 1}'; then
                echo -e "${red}❌ 致命错误：当前内核版本 ($kernel_version) 低于 4.9！${plain}"
                echo -e "${red}强行注入 BBR 参数将导致机器断网失联！请先升级 Ubuntu 内核！${plain}"
            else
                read -p "👉 是否立即【一键开启 BBR 暴力加速】？(y/n): " enable_bbr
                if [[ "${enable_bbr,,}" == "y" ]]; then
                    echo -e "\n${cyan}正在向系统内核加载 BBR 模块并建立独立防线...${plain}"
                    
                    # 强行拉起模块
                    modprobe tcp_bbr 2>/dev/null
                    echo "tcp_bbr" > /etc/modules-load.d/velox-bbr.conf

                    # 模块化注入：生成 Velox 专属配置文件
                    cat << EOF > "$BBR_CONF"
# Velox VPS Panel - BBR Tuning
net.core.default_qdisc=fq
net.ipv4.tcp_congestion_control=bbr
EOF
                    
                    # 应用所有 sysctl.d 目录下的配置
                    sysctl --system >/dev/null 2>&1
                    
                    # 极客视觉体验：硬核状态实时回显
                    echo -e "\n${blue}--- 📡 核心网络参数实时回显 ---${plain}"
                    sysctl net.ipv4.tcp_congestion_control
                    sysctl net.core.default_qdisc
                    echo -e "${blue}-------------------------------${plain}"

                    if sysctl net.ipv4.tcp_congestion_control 2>/dev/null | grep -q bbr; then
                        echo -e "\n${green}🎉 开启成功！【BBR + fq】 黄金组合已全线生效！${plain}"
                    else
                        echo -e "\n${red}❌ 开启失败！当前系统环境受限 (提示：容器架构无法修改底层内核)。${plain}"
                        rm -f "$BBR_CONF" /etc/modules-load.d/velox-bbr.conf
                    fi
                fi
            fi
        fi
        
        # 统一的返回停顿
        echo ""
        read -p "👉 按【回车键】返回主菜单..."
        ;;
   10)
        echo -e "\n${blue}=== 🧹 焦土化系统清理与内存强制释放 ===${plain}"
        echo -e "${yellow}正在执行深度大扫除，清理底层无用依赖与碎片...${plain}\n"

        # 绝杀 1：触发全局包管理器清理大招 (依赖咱们刚写的智能路由)
        echo -n " 🗑️  1. 剥离无用依赖与内核包... "
        $PKG_CLEAN >/dev/null 2>&1
        echo -e "[${green}物理清理完毕 ✅${plain}]"

        # 绝杀 2：系统日志瘦身 (防爆盘机制，强制只保留最近 3 天的日志)
        echo -n " 📝  2. 焦土化清理 Systemd 历史日志... "
        if command -v journalctl >/dev/null 2>&1; then
            journalctl --vacuum-time=3d >/dev/null 2>&1
            journalctl --vacuum-size=100M >/dev/null 2>&1
        fi
        echo -e "[${green}日志瘦身完毕 ✅${plain}]"

        # 绝杀 3：强行物理释放内存 (Drop Caches)
        echo -n " ⚡  3. 物理拔管强制释放缓存内存... "
        sync; echo 3 > /proc/sys/vm/drop_caches
        echo -e "[${green}内存满血复苏 ✅${plain}]"

        echo -e "\n${green}🎉 机器已剥离所有多余脂肪，进入极致干练状态！${plain}"
        echo -e "${blue}---------------------------------------------------${plain}"
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
        
        require_deps curl
        
        proxy_port=$(ss -nltp 2>/dev/null | grep -E 'warp-svc|warp-go' | awk '{print $4}' | grep -E '127\.0\.0\.1|::1' | awk -F':' '{print $NF}' | head -n 1)
        warp_iface=""
        if [[ -z "$proxy_port" ]]; then
            for iface in wgcf warp wg0; do
                if ip link show "$iface" >/dev/null 2>&1; then warp_iface="$iface"; break; fi
            done
        fi

        if [[ -n "$proxy_port" ]]; then
            echo -e "\n${yellow}💡 雷达嗅探到系统正运行 SOCKS5 局部代理 (端口: $proxy_port)${plain}"
            echo -e "  ${green}1.${plain} 🎯 穿透测试 【代理 IP】 解锁情况 (极客推荐)"
            echo -e "  ${cyan}2.${plain} 🌍 常规测试 【VPS 原生 IP】 解锁情况"
            read -p "👉 请选择测速链路 [1-2, 回车默认1]: " test_choice
            
            echo -e "\n${cyan}🚀 正在拉取测速组件，请耐心等待...${plain}"
            if [[ "${test_choice:-1}" == "1" ]]; then
                ALL_PROXY="socks5h://127.0.0.1:$proxy_port" bash <(curl -x socks5h://127.0.0.1:$proxy_port -sL media.ispvps.com)
            else
                bash <(curl -sL media.ispvps.com)
            fi

        elif [[ -n "$warp_iface" ]]; then
            echo -e "\n${yellow}💡 雷达嗅探到系统部署了 WARP 虚拟网卡 ($warp_iface)${plain}"
            echo -e "  ${green}1.${plain} 🎯 穿透测试 【WARP 虚拟网卡】 解锁情况"
            echo -e "  ${cyan}2.${plain} 🌍 常规测试 【VPS 原生 IP】 解锁情况"
            read -p "👉 请选择测速链路 [1-2, 回车默认1]: " test_choice
            
            echo -e "\n${cyan}🚀 正在拉取测速组件，请耐心等待...${plain}"
            if [[ "${test_choice:-1}" == "1" ]]; then
                bash <(curl -sL media.ispvps.com) -I "$warp_iface"
            else
                bash <(curl -sL media.ispvps.com)
            fi
        else
            echo -e "\n${green}>>> 未检测到局部代理，正在为您测试当前 VPS 原生 IP 解锁情况...${plain}"
            echo -e "${cyan}🚀 正在拉取测速组件，请耐心等待...${plain}"
            bash <(curl -sL media.ispvps.com)
        fi
        
        echo -e "\n${yellow}------------------------------------------${plain}"
        read -p "👉 测试完毕！按【回车键】返回主菜单..."
        ;;
        
    13)
        echo -e "\n${blue}=== 🛡️ 节点 IP 纯净度与欺诈风险体检 ===${plain}"
        echo -e "${yellow}正在向全球顶级权威数据库查询出站 IP 纯净度...${plain}\n"

        # 核心升级：强行注入 jq 实施精准基因提取
        require_deps curl jq

        VPS_IP=$(curl -s4m 3 https://api.ipify.org || curl -s4m 3 https://ip.gs)
        
        if [ -n "$VPS_IP" ]; then
            echo -e "🌍 当前出站 IP: ${cyan}${VPS_IP}${plain}\n"
            echo -e "${cyan}--- 🌐 国际核心数据库 (IP-API) 深度解析 ---${plain}"
            
            # 使用 jq 精准解析 JSON，绝不因字段顺序改变而炸膛
            JSON_DATA=$(curl -sL "http://ip-api.com/json/$VPS_IP?lang=zh-CN&fields=country,regionName,city,isp,org,as,mobile,proxy,hosting" 2>/dev/null)
            
            if echo "$JSON_DATA" | jq -e . >/dev/null 2>&1; then
                echo -e "  🔹 国家/地区      : $(echo "$JSON_DATA" | jq -r '.country')"
                echo -e "  🔹 省份/州        : $(echo "$JSON_DATA" | jq -r '.regionName')"
                echo -e "  🔹 城市           : $(echo "$JSON_DATA" | jq -r '.city')"
                echo -e "  🔹 ISP 运营商     : $(echo "$JSON_DATA" | jq -r '.isp')"
                echo -e "  🔹 所属机构       : $(echo "$JSON_DATA" | jq -r '.org')"
                echo -e "  🔹 ASN 号         : $(echo "$JSON_DATA" | jq -r '.as')"
                
                is_mobile=$(echo "$JSON_DATA" | jq -r '.mobile')
                is_proxy=$(echo "$JSON_DATA" | jq -r '.proxy')
                is_hosting=$(echo "$JSON_DATA" | jq -r '.hosting')
                
                echo -e "  🔹 移动网络(手机) : $( [ "$is_mobile" == "true" ] && echo "\033[1;33m是\033[0m" || echo "否" )"
                echo -e "  🔹 VPN/代理标记   : $( [ "$is_proxy" == "true" ] && echo "\033[1;31m是 (高风险)\033[0m" || echo "\033[1;32m否 (干净)\033[0m" )"
                echo -e "  🔹 机房 IP        : $( [ "$is_hosting" == "true" ] && echo "\033[1;33m是 (Hosting)\033[0m" || echo "\033[1;32m否 (原生家宽)\033[0m" )"
            else
                echo -e "${red}❌ API 响应异常或解析失败。${plain}"
            fi
            
            echo -e "\n${cyan}--- 🏢 IPinfo 国际 ASN 辅助认证 ---${plain}"
            IPINFO_ORG=$(curl -s4m 3 https://ipinfo.io/$VPS_IP/org 2>/dev/null)
            echo -e "  🔹 核心归属       : ${yellow}${IPINFO_ORG:-获取超时}${plain}"

            echo -e "\n${green}💡 极客科普：${plain}"
            echo -e "🟢 ${green}原生 IP (家宽/移动)${plain}: 极品！流媒体全解锁，极少跳谷歌验证码。"
            echo -e "🟡 ${yellow}机房 IP (Hosting)${plain}: 普通云大厂 (如 GCP) 标配，可能偶发验证码。"
            echo -e "🔴 ${red}被标记代理 (Proxy)${plain}: 已经被拉黑，建议套 WARP 救活！"
            
            echo -e "\n🔗 ${cyan}查阅权威 Scamalytics 欺诈分数: ${plain}\033[4;34mhttps://scamalytics.com/ip/$VPS_IP\033[0m"
        else
            echo -e "${red}❌ 无法获取本机 IP，请检查网络连接。${plain}"
        fi
        
        echo -e "\n${yellow}------------------------------------------${plain}"
        read -p "👉 按【回车键】返回主菜单..."
        ;;
        
    14)
        check_virt_safe "TCP/UDP 读写缓冲区与队列扩展" || { read -p "👉 按【回车键】继续..."; continue; }

        # 核心升级：精准判定 tc 命令，避免安装死循环
        if ! command -v tc >/dev/null 2>&1; then
            echo -e "${yellow}⚙️ 正在向底层注入缺失装甲: iproute2...${plain}"
            $PKG_INSTALL iproute2 >/dev/null 2>&1
        fi

        echo -e "\n${cyan}请选择网络底层调优方向：${plain}"
        echo -e "  ${green}1.${plain} ⚡ TCP 暴力扩容 (传统大文件下载提速)"
        echo -e "  ${green}2.${plain} 🌪️ UDP 极限压榨 (Hysteria2/gRPC 专属抗丢包)"
        echo -e "  ${green}3.${plain} 🔥 双管齐下 (同时执行 TCP 与 UDP 调优)"
        echo -e "  ${red}4.${plain} 🗑️ 恢复系统默认 (无痕物理粉碎参数)"
        echo -e "  ${cyan}0.${plain} 🔙 返回主菜单"
        read -p "👉 请输入选择 [0-4]: " tune_choice
        
        if [ "$tune_choice" == "0" ]; then
            echo -e "\n${yellow}已取消操作，返回主菜单。${plain}"
        elif [[ "$tune_choice" =~ ^[1-4]$ ]]; then
            
            TOTAL_MEM=$(free -m | awk '/^Mem:/{print $2}')
            if [ "$TOTAL_MEM" -le 512 ]; then MAX_BUF="16777216"; MEM_TAG="轻量级"
            elif [ "$TOTAL_MEM" -le 1024 ]; then MAX_BUF="26214400"; MEM_TAG="标准级"
            else MAX_BUF="33554432"; MEM_TAG="极速级"; fi

            # 极客升级：独立模块化文件，永不污染主配置！
            VELOX_NET_CONF="/etc/sysctl.d/99-velox-network.conf"
            
            # 顺手帮你把以前搞脏的主配置清理一次（只执行一次的焦土清理）
            sed -i '/rmem_max/d; /wmem_max/d; /tcp_rmem/d; /tcp_wmem/d; /udp_rmem_min/d; /udp_wmem_min/d' /etc/sysctl.conf >/dev/null 2>&1

            if [ "$tune_choice" == "1" ] || [ "$tune_choice" == "3" ]; then
                echo -e "\n${blue}--- ⚡ 正在进行 TCP 网络底层调优 ($MEM_TAG) ---${plain}"
                cat << EOF > "$VELOX_NET_CONF"
net.core.rmem_max=$MAX_BUF
net.core.wmem_max=$MAX_BUF
net.ipv4.tcp_rmem=4096 87380 $MAX_BUF
net.ipv4.tcp_wmem=4096 65536 $MAX_BUF
EOF
                sysctl --system > /dev/null 2>&1
                echo -e "${green}✅ TCP 读写窗口缓冲区已动态扩展至 $((MAX_BUF/1024/1024))MB！${plain}"
            fi

            if [ "$tune_choice" == "2" ] || [ "$tune_choice" == "3" ]; then
                echo -e "\n${blue}--- 🌪️ 正在进行 UDP 网络底层高阶调优 ($MEM_TAG) ---${plain}"
                cat << EOF >> "$VELOX_NET_CONF"
net.ipv4.udp_rmem_min=8192
net.ipv4.udp_wmem_min=8192
EOF
                # 如果选2，补齐 core 参数
                if [ "$tune_choice" == "2" ]; then
                    echo "net.core.rmem_max=$MAX_BUF" >> "$VELOX_NET_CONF"
                    echo "net.core.wmem_max=$MAX_BUF" >> "$VELOX_NET_CONF"
                fi
                
                sysctl --system > /dev/null 2>&1
                echo -e "${green}✅ UDP 读写缓冲区已暴力扩容至 $((MAX_BUF/1024/1024))MB！${plain}"
                
                echo -e "\n${yellow}👉 正在嗅探主网卡并配置 CAKE/FQ 队列调度算法...${plain}"
                DEFAULT_IF=$(ip route get 8.8.8.8 | awk '{print $5}' | head -n 1)
                tc qdisc del dev $DEFAULT_IF root >/dev/null 2>&1
                tc qdisc add dev $DEFAULT_IF root cake >/dev/null 2>&1 || tc qdisc add dev $DEFAULT_IF root fq >/dev/null 2>&1
                echo -e "${green}✅ 网卡 [$DEFAULT_IF] 队列调度已接管！(抗丢包能力大幅提升)${plain}"
            fi

            if [ "$tune_choice" == "4" ]; then
                echo -e "\n${blue}--- 🗑️ 正在无痕粉碎自定义调优参数 ---${plain}"
                rm -f "$VELOX_NET_CONF"
                sysctl --system > /dev/null 2>&1
                DEFAULT_IF=$(ip route get 8.8.8.8 | awk '{print $5}' | head -n 1)
                tc qdisc del dev $DEFAULT_IF root >/dev/null 2>&1
                echo -e "${green}✅ 所有强行注入的扩容参数已抹除，系统网络恢复默认纯净状态！${plain}"
            fi
        else
            echo -e "${red}❌ 无效输入，已取消操作。${plain}"
        fi
        ;;
      
        15)
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

                # 动态侦测每日脉搏晨报状态
                P_CRON=$(crontab -l 2>/dev/null | grep "velox_pulse_alert.sh")
                if [ -n "$P_CRON" ]; then
                    P_TIME=$(echo "$P_CRON" | awk '{print $2}')
                    PULSE_STAT="${green}运行中 ✅ (每天 ${P_TIME}:00 播报)${plain}"
                else
                    PULSE_STAT="${yellow}未部署 ⚠️${plain}"
                fi

                # 动态侦测秒级哨兵状态
                W_CRON=$(crontab -l 2>/dev/null | grep "velox_watchdog.sh")
                if [ -n "$W_CRON" ]; then
                    WATCHDOG_STAT="${green}运行中 ✅${plain}"
                else
                    WATCHDOG_STAT="${yellow}未部署 ⚠️${plain}"
                fi

                echo -e "  ${green}1.${plain} 🚀 部署/重置 [SSH 异地登录 + 开机自启] 报警防线 (当前: $ALERT_STAT)"
                echo -e "  ${cyan}2.${plain} 📊 部署/重置 [每日节点存活体检晨报] 打卡推送 (当前: $PULSE_STAT)"
                echo -e "  ${yellow}3.${plain} ⚡ 部署/重置 [核心防猝死秒级哨兵] 实时盯防 (当前: $WATCHDOG_STAT)"
                echo -e "  ${red}4.${plain} 🗑️ 彻底卸载 SSH、开机、晨报及哨兵防线"
                echo -e "  ${purple}5.${plain} ⚙️ 全局 TG 机器人凭证管理 (当前: $TG_CRED_STAT)"
                echo -e "      ${yellow}└─ 更改/删除当前 Velox 大管家的全局防线凭证${plain}"
                echo -e "  ${cyan}0.${plain} 🔙 返回主菜单"
                echo -e "${cyan}----------------------------------------------------------------------${plain}"
                read -p "👉 请选择操作 [0-5]: " tg_main_choice

                case "$tg_main_choice" in
                    1)
                        # 核心升级 1：一行注入底层依赖
                        require_deps curl jq

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
                        fi

                        echo -e "${cyan}正在向系统底层注入 SSH 探针与开机自启防线...${plain}"
                        
                        cat << 'EOF2' > /usr/local/bin/ssh_tg_alert.sh
#!/bin/bash
source /etc/velox_tg.conf
if [ -z "$TG_ALERT_TRIGGERED" ]; then
    export TG_ALERT_TRIGGERED=1
    export TZ="Asia/Shanghai"
    USER_IP=$(echo $SSH_CLIENT | awk '{print $1}')
    if [ -n "$USER_IP" ]; then
        GEO_INFO=$(curl -s4m3 "http://ip-api.com/line/$USER_IP?lang=zh-CN&fields=country,city,isp" | tr '\n' ' ' | sed 's/ $//')
        [ -z "$GEO_INFO" ] && GEO_INFO="未知归属地或查询超时"
        MSG="🚨 <b>[神盾局警告]</b>
大佬，您的服务器 <code>$(hostname)</code> 刚刚被登录了！
👉 <b>来源 IP:</b> <code>$USER_IP</code>
🌍 <b>IP 溯源:</b> $GEO_INFO
⏰ <b>北京时间:</b> $(date +'%Y-%m-%d %H:%M:%S')"
        MAIN_IF=$(ip -4 route ls | grep default | grep -v tun | grep -v warp | grep -v wg | awk '{print $5}' | head -n 1)
        if [ -n "$MAIN_IF" ]; then
            curl --interface "$MAIN_IF" -s -X POST "https://api.telegram.org/bot${GLOBAL_TG_TOKEN}/sendMessage" --data-urlencode chat_id="${GLOBAL_TG_CHATID}" --data-urlencode text="$MSG" -d parse_mode="HTML" > /dev/null 2>&1 &
        else
            curl -s -X POST "https://api.telegram.org/bot${GLOBAL_TG_TOKEN}/sendMessage" --data-urlencode chat_id="${GLOBAL_TG_CHATID}" --data-urlencode text="$MSG" -d parse_mode="HTML" > /dev/null 2>&1 &
        fi
    fi
fi
EOF2
                        chmod +x /usr/local/bin/ssh_tg_alert.sh
                        sed -i '/ssh_tg_alert.sh/d' /etc/profile /etc/bash.bashrc
                        echo "source /usr/local/bin/ssh_tg_alert.sh" >> /etc/profile
                        echo "source /usr/local/bin/ssh_tg_alert.sh" >> /etc/bash.bashrc
                        
                        cat << 'EOF2' > /usr/local/bin/tg_boot_alert.sh
#!/bin/bash
source /etc/velox_tg.conf
sleep 15
export TZ="Asia/Shanghai"
sleep 30  
if systemctl is-active --quiet sing-box 2>/dev/null || pgrep -x "sing-box" >/dev/null 2>&1; then SB_STAT="运行中 ✅"; else SB_STAT="未运行/未安装 ⚠️"; fi
if systemctl is-active --quiet xray 2>/dev/null || systemctl is-active --quiet x-ui 2>/dev/null || pgrep -x "xray" >/dev/null 2>&1; then XR_STAT="运行中 ✅"; else XR_STAT="未运行/未安装 ⚠️"; fi
if pgrep -x "cloudflared" >/dev/null 2>&1 || systemctl is-active --quiet velox-argo 2>/dev/null || systemctl is-active --quiet argo 2>/dev/null; then ARGO_STAT="运行中 ✅"; else ARGO_STAT="未运行/无自启 ⚠️"; fi
if systemctl is-active --quiet warp-go 2>/dev/null || systemctl is-active --quiet wg-quick@wgcf 2>/dev/null || systemctl is-active --quiet warp-svc 2>/dev/null || ip link show wg0 >/dev/null 2>&1 || ip link show warp >/dev/null 2>&1; then WARP_STAT="已就绪 ✅"; else WARP_STAT="未开启/未安装 ⚠️"; fi
MSG="🟢 <b>[Velox 系统复苏通知]</b>
大佬，您的服务器 <code>$(hostname)</code> 已完成重启并成功连网！
📊 <b>【核心体检报告】</b>
🚀 Sing-box : $SB_STAT
🛸 Xray 核心: $XR_STAT
🚇 Argo 隧道: $ARGO_STAT
🛡️ WARP 出站: $WARP_STAT
⏰ 北京时间: $(date +'%Y-%m-%d %H:%M:%S')"
MAIN_IF=$(ip -4 route ls | grep default | grep -v tun | grep -v warp | grep -v wg | awk '{print $5}' | head -n 1)
if [ -n "$MAIN_IF" ]; then curl --interface "$MAIN_IF" -s -X POST "https://api.telegram.org/bot${GLOBAL_TG_TOKEN}/sendMessage" --data-urlencode chat_id="${GLOBAL_TG_CHATID}" --data-urlencode text="$MSG" -d parse_mode="HTML" > /dev/null 2>&1
else curl -s -X POST "https://api.telegram.org/bot${GLOBAL_TG_TOKEN}/sendMessage" --data-urlencode chat_id="${GLOBAL_TG_CHATID}" --data-urlencode text="$MSG" -d parse_mode="HTML" > /dev/null 2>&1; fi
EOF2
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
                        if [ -z "$GLOBAL_TG_TOKEN" ] || [ -z "$GLOBAL_TG_CHATID" ]; then
                            echo -e "\n${red}❌ 致命拦截：请先选择 [选项 5] 或 [选项 1] 配置 TG 机器人凭证！${plain}"
                            read -p "👉 按【回车键】继续..."; continue
                        fi
                        
                        echo -e "\n${yellow}💡 提示：系统已锚定北京时间，请使用 24 小时制输入。${plain}"
                        read -p "👉 请输入每日播报的小时 (如填 8 代表早上8点，填 20 代表晚上8点) [默认 8]: " p_hour
                        
                        p_hour=${p_hour:-8}
                        if ! [[ "$p_hour" =~ ^[0-9]+$ ]] || [ "$p_hour" -lt 0 ] || [ "$p_hour" -gt 23 ]; then
                            echo -e "${red}❌ 格式致命错误！只能输入 0 到 23 之间的纯数字。${plain}"
                            read -p "👉 按【回车键】继续..."; continue
                        fi
                        
                        echo -e "${cyan}正在锻造每日节点存活体检脚本...${plain}"
                        cat << 'EOF_P' > /usr/local/bin/velox_pulse_alert.sh
#!/bin/bash
source /etc/velox_tg.conf

if command -v sing-box >/dev/null 2>&1 || [ -f "/usr/local/bin/sing-box" ] || [ -f "/usr/bin/sing-box" ]; then
    pgrep -x "sing-box" >/dev/null && SB_LIVE="🟢 满血" || SB_LIVE="🔴 阵亡"
else SB_LIVE="⚪ 未安装"; fi

if command -v xray >/dev/null 2>&1 || [ -f "/usr/local/bin/xray" ] || [ -f "/usr/bin/xray" ]; then
    pgrep -x "xray" >/dev/null && XR_LIVE="🟢 满血" || XR_LIVE="🔴 阵亡"
else XR_LIVE="⚪ 未安装"; fi

IP_ADDR=$(curl -s4m3 api.ipify.org || curl -s4m3 icanhazip.com || echo "未知")
UP_TIME=$(uptime -p | sed 's/up //')
LOAD_AVG=$(cat /proc/loadavg | awk '{print $1" "$2" "$3}')
MEM_TOTAL=$(free -h | awk '/Mem:/ {print $2}' | sed 's/i//g')
MEM_USED=$(free -h | awk '/Mem:/ {print $3}' | sed 's/i//g')
MEM_PCT=$(free -m | awk '/Mem:/ {printf "%.0f", $3/$2*100}')
DISK_TOTAL=$(df -h / | awk '/\// {print $2}' | sed 's/i//g')
DISK_USED=$(df -h / | awk '/\// {print $3}' | sed 's/i//g')
DISK_PCT=$(df -h / | awk '/\// {print $5}')

MSG="📊 <b>[Velox 每日体检晨报]</b>
--------------------------------------
🖥️ <b>阵地:</b> <code>$(hostname)</code>
🌍 <b>IP:</b> <code>${IP_ADDR}</code>
⏱️ <b>存活:</b> ${UP_TIME}

🔥 <b>[系统硬件开销]</b>
⚙️ <b>负载:</b> <code>${LOAD_AVG}</code> (排队指数)
📦 <b>内存:</b> <code>${MEM_USED} / ${MEM_TOTAL} (已用 ${MEM_PCT}%)</code>
💽 <b>磁盘:</b> <code>${DISK_USED} / ${DISK_TOTAL} (已用 ${DISK_PCT})</code>

🛡️ <b>[节点核心存活状态]</b>
🚀 Sing-box : ${SB_LIVE}
🛸 Xray 核心: ${XR_LIVE}
--------------------------------------
<i>(此消息为每日例行存活打卡)</i>"
curl -s -X POST "https://api.telegram.org/bot${GLOBAL_TG_TOKEN}/sendMessage" -d "chat_id=${GLOBAL_TG_CHATID}" -d "text=$MSG" -d parse_mode="HTML" > /dev/null 2>&1
EOF_P
                        chmod +x /usr/local/bin/velox_pulse_alert.sh
                        crontab -l 2>/dev/null | grep -v "velox_pulse_alert.sh" | crontab -
                        (crontab -l 2>/dev/null; echo "0 $p_hour * * * /usr/local/bin/velox_pulse_alert.sh") | crontab -
                        echo -e "\n${green}✅ 部署成功！系统将于每天北京时间 ${p_hour}:00 定时播报节点生死报告。${plain}"
                        read -p "👉 按【回车键】继续..."
                        ;;

                    3)
                        if [ -z "$GLOBAL_TG_TOKEN" ] || [ -z "$GLOBAL_TG_CHATID" ]; then
                            echo -e "\n${red}❌ 致命拦截：请先配置 TG 机器人凭证！${plain}"
                            read -p "👉 按【回车键】继续..."; continue
                        fi
                        
                        echo -e "\n${cyan}正在向系统底层注入多核智能秒级监控探针...${plain}"
                        # 核心升级 2：全域矩阵化扫描 (动态保护 sing-box, xray, cloudflared)
                        cat << 'EOF_WATCH' > /usr/local/bin/velox_watchdog.sh
#!/bin/bash
source /etc/velox_tg.conf
declare -a CORE_TARGETS=("sing-box" "xray" "cloudflared" "velox-argo")

for PROC in "${CORE_TARGETS[@]}"; do
    # 只有系统中确实存在该实体命令，才将其纳入秒级监控雷达
    if command -v "$PROC" >/dev/null 2>&1 || [ -f "/usr/local/bin/$PROC" ] || [ -f "/usr/bin/$PROC" ]; then
        FLAG_FILE="/tmp/${PROC}_dead.flag"
        if ! pgrep -x "$PROC" > /dev/null; then
            if [ ! -f "$FLAG_FILE" ]; then
                MSG="🚨 <b>[核心阵地失守警告]</b>
--------------------------------------
🖥️ <b>阵地:</b> <code>$(hostname)</code>
⚠️ <b>状态:</b> <code>${PROC}</code> 核心已阵亡！
⏰ <b>时间:</b> $(date +'%Y-%m-%d %H:%M:%S')
--------------------------------------
<i>大佬，节点核心物理掉线，请火速上线紧急抢救！</i>"
                curl -s -X POST "https://api.telegram.org/bot${GLOBAL_TG_TOKEN}/sendMessage" -d "chat_id=${GLOBAL_TG_CHATID}" -d "text=$MSG" -d parse_mode="HTML" > /dev/null 2>&1
                touch "$FLAG_FILE"
            fi
        else
            if [ -f "$FLAG_FILE" ]; then
                MSG="🟢 <b>[核心阵地满血复活]</b>
--------------------------------------
🖥️ <b>阵地:</b> <code>$(hostname)</code>
✅ <b>状态:</b> <code>${PROC}</code> 核心已重新归队！
⏰ <b>时间:</b> $(date +'%Y-%m-%d %H:%M:%S')
--------------------------------------
<i>(雷达侦测：系统已恢复正常运作)</i>"
                curl -s -X POST "https://api.telegram.org/bot${GLOBAL_TG_TOKEN}/sendMessage" -d "chat_id=${GLOBAL_TG_CHATID}" -d "text=$MSG" -d parse_mode="HTML" > /dev/null 2>&1
                rm -f "$FLAG_FILE"
            fi
        fi
    fi
done
EOF_WATCH
                        chmod +x /usr/local/bin/velox_watchdog.sh
                        crontab -l 2>/dev/null | grep -v "velox_watchdog.sh" | crontab -
                        (crontab -l 2>/dev/null; echo "* * * * * /usr/local/bin/velox_watchdog.sh") | crontab -
                        echo -e "\n${green}✅ 部署成功！智能哨兵已开启全域扫描，自动挂载当前 VPS 上的所有核心进行保护！${plain}"
                        read -p "👉 按【回车键】继续..."
                        ;;

                    4)
                        if [ ! -f "/usr/local/bin/ssh_tg_alert.sh" ] && ! crontab -l 2>/dev/null | grep -qE "velox_pulse_alert.sh|velox_watchdog.sh"; then
                            echo -e "\n${yellow}⚠️ 当前未部署任何防线，无需卸载。${plain}"
                        else
                            echo -e "\n${yellow}正在进行焦土化清除...${plain}"
                            rm -f /usr/local/bin/ssh_tg_alert.sh /usr/local/bin/tg_boot_alert.sh /etc/systemd/system/tg_boot_alert.service /usr/local/bin/velox_pulse_alert.sh /usr/local/bin/velox_watchdog.sh /tmp/*_dead.flag
                            sed -i '/ssh_tg_alert.sh/d' /etc/profile /etc/bash.bashrc
                            systemctl disable --now tg_boot_alert.service >/dev/null 2>&1
                            systemctl daemon-reload
                            
                            echo -e "${yellow}正在扫描定时任务旧版残余...${plain}"
                            if crontab -l 2>/dev/null | grep -qE "api.telegram.org|velox_pulse_alert.sh|velox_watchdog.sh"; then
                                crontab -l 2>/dev/null | grep -vE "api.telegram.org|velox_pulse_alert.sh|velox_watchdog.sh" | crontab -
                                echo -e "${green}✅ 定时报警指令、晨报及秒级哨兵已彻底清理！${plain}"
                            fi
                            echo -e "${green}✅ 所有本地安全防线已彻底无痕卸载！(注：全局凭证仍保留)${plain}"
                        fi
                        read -p "👉 按【回车键】继续..."
                        ;;

                    5)
                        echo -e "\n${cyan}=== ⚙️ 全局 TG 机器人凭证管理 ===${plain}"
                        if [[ -n "$GLOBAL_TG_TOKEN" ]]; then
                            MASKED_TOKEN="${GLOBAL_TG_TOKEN:0:8}********${GLOBAL_TG_TOKEN: -5}"
                            MASKED_CHATID="${GLOBAL_TG_CHATID:0:3}****${GLOBAL_TG_CHATID: -2}"
                            echo -e "当前绑定的 Token: ${green}${MASKED_TOKEN}${plain}"
                            echo -e "当前绑定的 Chat ID: ${green}${MASKED_CHATID}${plain}"
                        else
                            echo -e "${yellow}⚠️ 当前全局池为空。${plain}"
                        fi
                        echo -e "\n请选择操作："
                        echo -e "  ${green}1.${plain} 重新输入并物理覆盖配置"
                        echo -e "  ${red}2.${plain} 彻底删除全局凭证 (💥 将同时强拆 Velox 的所有报警进程)"
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
                                else
                                    echo -e "${red}❌ 输入无效，操作已取消。${plain}"
                                fi
                                ;;
                            2)
                                rm -f /etc/velox_tg.conf
                                unset GLOBAL_TG_TOKEN
                                unset GLOBAL_TG_CHATID
                                echo -e "${green}🗑️ 全局 TG 配置文件已被物理蒸发！${plain}"
                                
                                if [ -f "/usr/local/bin/ssh_tg_alert.sh" ] || crontab -l 2>/dev/null | grep -qE "velox_pulse_alert.sh|velox_watchdog.sh"; then
                                    rm -f /usr/local/bin/ssh_tg_alert.sh /usr/local/bin/tg_boot_alert.sh /etc/systemd/system/tg_boot_alert.service /usr/local/bin/velox_pulse_alert.sh /usr/local/bin/velox_watchdog.sh /tmp/*_dead.flag
                                    sed -i '/ssh_tg_alert.sh/d' /etc/profile /etc/bash.bashrc
                                    systemctl disable --now tg_boot_alert.service >/dev/null 2>&1
                                    if crontab -l 2>/dev/null | grep -qE "api.telegram.org|velox_pulse_alert.sh|velox_watchdog.sh"; then
                                        crontab -l 2>/dev/null | grep -vE "api.telegram.org|velox_pulse_alert.sh|velox_watchdog.sh" | crontab -
                                    fi
                                    echo -e "${yellow}⚠️ 已联动彻底卸载 Velox 的所有本地报警防线！${plain}"
                                fi
                                systemctl daemon-reload
                                ;;
                        esac
                        read -p "👉 按【回车键】继续..."
                        ;;
                    0) break ;;
                    *) echo -e "\n${red}❌ 无效选择！${plain}"; sleep 1 ;;
                esac
            done
            ;;
   16)
        DEFAULT_IF=$(ip -4 route ls | grep default | grep -vE 'tun|warp|wg|tailscale' | awk '{print $5}' | head -n 1)
        [ -z "$DEFAULT_IF" ] && DEFAULT_IF=$(ip route get 8.8.8.8 | awk '{for(i=1;i<=NF;i++) if($i=="dev") print $(i+1)}' | head -n 1)
        
        # 🚀 核心升级：架构预警
        virt_type=$(systemd-detect-virt 2>/dev/null || echo "unknown")
        if [[ "$virt_type" == "lxc" || "$virt_type" == "openvz" ]]; then
            echo -e "\n${yellow}⚠️ 架构预警：检测到当前为 $virt_type 容器环境！${plain}"
            echo -e "部分重度阉割的容器可能无法运行底层的 vnstat 守护进程，如果后续报错，请联系主机商。${plain}"
            sleep 2
        fi

        # 🚀 核心升级：废弃老旧的 bc 外挂，强行注入 vnstat (C语言内核) 和 jq
        require_deps vnstat jq
        TG_CONF="/etc/velox_tg.conf"

        while true; do
            # ======== 🚀 动态嗅探防线状态 ========
            if [ -f "/usr/local/bin/velox_traffic_alert.sh" ]; then
                LIMIT_VAL=$(grep "^LIMIT_GB=" /usr/local/bin/velox_traffic_alert.sh | cut -d '=' -f2 | tr -d '"')
                MODE_STR=$(grep "^MODE_NAME=" /usr/local/bin/velox_traffic_alert.sh | cut -d '=' -f2 | tr -d '"')
                GUARD_STAT="${green}运行中✅ (红线:${LIMIT_VAL}G | 模式:${MODE_STR})${plain}"
            else
                GUARD_STAT="${yellow}未部署⚠️${plain}"
            fi

            if [ -f "$TG_CONF" ] && grep -q "GLOBAL_TG_TOKEN" "$TG_CONF"; then TG_STAT="${green}已绑定✅${plain}"; else TG_STAT="${yellow}未绑定⚠️${plain}"; fi

            clear
            echo -e "${cyan}=======================================================${plain}"
            echo -e "      📈 Velox 流量大管家 (C语言内核引擎 / 无缝重构版)"
            echo -e "      当前监听主网卡: ${yellow}$DEFAULT_IF${plain}"
            echo -e "${cyan}=======================================================${plain}"
            echo -e "  ${green}1.${plain} 📊 查看看板 (本次临时内存流量 & 本月持久化账单)"
            echo -e "  ${red}2.${plain} 🚨 部署防线 [防线: $GUARD_STAT | TG: $TG_STAT]"
            echo -e "  ${purple}3.${plain} 📈 极客视窗 (无闪烁 TUI 实时动态网速仪表盘)"
            echo -e "  ${yellow}0.${plain} 🔙 返回主菜单"
            echo -e "-------------------------------------------------------"
            read -p "👉 请选择操作 [0-3]: " traffic_choice

            case $traffic_choice in
                1)
                    echo -e "\n${blue}=== 📊 临时报表：自本次开机以来的消耗 ===${plain}"
                    awk '
                    BEGIN {
                        printf "%-12s | %-12s | %-12s | %-12s\n", "🌐 网卡接口", "⬇️ 下载量", "⬆️ 上传量", "🔄 流量总计"
                        printf "-------------------------------------------------------------\n"
                    }
                    NR > 2 {
                        rx = $2; tx = $10; total = rx + tx;
                        if (rx > 1073741824) {rx_str = sprintf("%.2f GB", rx/1073741824)} else if (rx > 1048576) {rx_str = sprintf("%.2f MB", rx/1048576)} else {rx_str = sprintf("%.2f KB", rx/1024)}
                        if (tx > 1073741824) {tx_str = sprintf("%.2f GB", tx/1073741824)} else if (tx > 1048576) {tx_str = sprintf("%.2f MB", tx/1048576)} else {tx_str = sprintf("%.2f KB", tx/1024)}
                        if (total > 1073741824) {total_str = sprintf("%.2f GB", total/1073741824)} else if (total > 1048576) {total_str = sprintf("%.2f MB", total/1048576)} else {total_str = sprintf("%.2f KB", total/1024)}
                        if ($1 != "lo:") {
                            printf "%-14s | %-14s | %-14s | %-14s\n", $1, rx_str, tx_str, total_str
                        }
                    }
                    ' /proc/net/dev

                    echo -e "\n${blue}=== 🗓️ 月度账单：数据库持久化记录 (重启不丢) ===${plain}"
                    systemctl enable vnstat >/dev/null 2>&1
                    systemctl start vnstat >/dev/null 2>&1

                    if ! vnstat -i $DEFAULT_IF >/dev/null 2>&1; then
                        systemctl stop vnstat >/dev/null 2>&1
                        vnstat --add -i $DEFAULT_IF >/dev/null 2>&1
                        vnstat --create -i $DEFAULT_IF >/dev/null 2>&1
                        chown -R vnstat:vnstat /var/lib/vnstat >/dev/null 2>&1
                        systemctl start vnstat >/dev/null 2>&1
                    fi
                    
                    VNSTAT_OUT=$(vnstat -i $DEFAULT_IF -m 2>&1)
                    if echo "$VNSTAT_OUT" | grep -qE "Not enough data|not found|No data"; then
                        ping -c 2 8.8.8.8 >/dev/null 2>&1
                        vnstat -u -i $DEFAULT_IF >/dev/null 2>&1
                        sleep 1 
                        VNSTAT_OUT=$(vnstat -i $DEFAULT_IF -m 2>&1)
                        if echo "$VNSTAT_OUT" | grep -qE "Not enough data|not found|No data"; then
                            echo -e "${yellow}⚠️ 数据库刚建立，底层正在疯狂采集中。请稍候查看！${plain}"
                        else
                            echo -e "${green}✅ 流量统计引擎已激活！Velox 已接管 [$DEFAULT_IF] 网卡。${plain}\n${cyan}$VNSTAT_OUT${plain}"
                        fi
                    else
                        echo -e "${cyan}$VNSTAT_OUT${plain}"
                    fi
                    echo -e "\n${yellow}💡 极客提示：若与主机商账单存在微小偏差，属于正常的物理时间差现象。${plain}"
                    read -p "👉 按【回车键】继续..."
                    ;;
                    
               2)
                    if ! command -v vnstat >/dev/null 2>&1; then
                        echo -e "\n${red}❌ 请先执行选项 [1] 激活底层流量数据库！${plain}"
                        read -p "👉 按【回车键】继续..."; continue
                    fi

                    if [ -f "/usr/local/bin/velox_traffic_alert.sh" ]; then
                        echo -e "\n${green}✅ 检测到当前已部署流量熔断防线！${plain}"
                        read -p "👉 请选择操作 (r:重新配置 / d:彻底卸载 / n:返回): " guard_choice
                        if [[ "${guard_choice,,}" == "d" ]]; then
                            rm -f /usr/local/bin/velox_traffic_alert.sh
                            crontab -l 2>/dev/null | grep -v "velox_traffic_alert.sh" | crontab -
                            echo -e "${green}✅ 流量报警防线已无痕卸载！${plain}"
                            read -p "👉 按【回车键】继续..."; continue
                        elif [[ "${guard_choice,,}" != "r" ]]; then continue; fi
                    fi

                    echo -e "\n${blue}--- 🚨 部署隐蔽流量防线与 TG 预警 ---${plain}"
                    echo -e "  ${cyan}1.${plain} 【单向出站计费】 (仅算上传，如 GCP、AWS、Azure)"
                    echo -e "  ${cyan}2.${plain} 【双向总计计费】 (上下行全算，如 搬瓦工、RN 等)"
                    read -p "👉 请选择计费模式 [1-2, 回车取消]: " mode_choice
                    
                    if [ "$mode_choice" == "1" ]; then MODE_NAME="出站上传(TX)"; echo -e "✅ 已选择: ${green}单向出站模式${plain}"
                    elif [ "$mode_choice" == "2" ]; then MODE_NAME="双向总计(Total)"; echo -e "✅ 已选择: ${green}双向总计模式${plain}"
                    else echo -e "${yellow}已取消。${plain}"; sleep 1; continue; fi

                    echo -e "\n⚠️  ${yellow}极客建议：请扣除 5% 额度作为安全缓冲 (如 1000G 填 950)！${plain}"
                    read -p "👉 请输入每月的流量熔断红线 (单位GB) [回车取消]: " limit_gb
                    if [[ ! "$limit_gb" =~ ^[0-9]+$ ]]; then echo -e "${red}❌ 格式错误，已取消。${plain}"; sleep 1; continue; fi
                    
                    if [ -f "$TG_CONF" ]; then
                        source "$TG_CONF"
                        if [ -n "$GLOBAL_TG_TOKEN" ] && [ -n "$GLOBAL_TG_CHATID" ]; then
                            echo -e "\n${green}✅ 复用全局 TG 机器人配置成功！${plain}"
                            tg_token="$GLOBAL_TG_TOKEN"; tg_chatid="$GLOBAL_TG_CHATID"
                        fi
                    fi

                    if [ -z "$tg_token" ] || [ -z "$tg_chatid" ]; then
                        read -p "👉 请输入 TG Bot Token [回车取消]: " tg_token
                        [ -z "$tg_token" ] && continue
                        read -p "👉 请输入 TG Chat ID [回车取消]: " tg_chatid
                        [ -z "$tg_chatid" ] && continue
                        
                        echo -e "\n${cyan}验证凭证连通性...${plain}"
                        if ! curl -s4m5 "https://api.telegram.org/bot${tg_token}/getMe" | grep -q '"ok":true'; then
                            echo -e "${red}❌ 验证失败！操作已拦截！${plain}"; read -p "按回车键继续..."; continue
                        fi
                        echo "GLOBAL_TG_TOKEN=\"$tg_token\"" > "$TG_CONF"
                        echo "GLOBAL_TG_CHATID=\"$tg_chatid\"" >> "$TG_CONF"
                    fi

                    echo -e "\n${cyan}正在锻造底层极客哨兵...${plain}"
                    
                    cat << EOF_ALERT > /usr/local/bin/velox_traffic_alert.sh
#!/bin/bash
source /etc/velox_tg.conf
IFACE="$DEFAULT_IF"
LIMIT_GB="$limit_gb"
MODE_NAME="$MODE_NAME"

# 🚀 极致性能：纯 awk 内核级计算，全面淘汰 bc！(无缝兼容 Vnstat V1/V2 版本)
USAGE_GB=\$(vnstat -i "\$IFACE" --oneline b 2>/dev/null | awk -F';' -v mode="\$MODE_NAME" '{
    if (\$1 == "1") { bytes = (mode == "出站上传(TX)") ? \$9 : \$10 }
    else if (\$1 == "2") { bytes = (mode == "出站上传(TX)") ? \$10 : \$11 }
    else { bytes = 0 }
    printf "%.2f", bytes / 1073741824
}')

[ -z "\$USAGE_GB" ] && exit 0

# 纯 awk 浮点比较判定 (Go 风格的隐式判断)
TRIGGER_100=\$(awk -v u="\$USAGE_GB" -v l="\$LIMIT_GB" 'BEGIN{print (u >= l) ? 1 : 0}')
TRIGGER_80=\$(awk -v u="\$USAGE_GB" -v l="\$LIMIT_GB" 'BEGIN{print (u >= l * 0.8) ? 1 : 0}')

CURRENT_MONTH=\$(date +%Y-%m)
LOCK_80="/tmp/velox_warn_80_\${CURRENT_MONTH}.lock"
LOCK_100="/tmp/velox_warn_100_\${CURRENT_MONTH}.lock"

if [ "\$TRIGGER_100" -eq 1 ]; then
    if [ ! -f "\$LOCK_100" ]; then
        MSG="🚨 <b>[Velox 流量熔断绝杀]</b>
大佬，您的机器 <code>\$(hostname)</code> 本月【\$MODE_NAME】已飙升至 <b>\${USAGE_GB} GB</b>！
已突破设定的 \${LIMIT_GB} GB 终极红线，请火速处理防止天价账单！"
        curl -s -X POST "https://api.telegram.org/bot\$GLOBAL_TG_TOKEN/sendMessage" -d "chat_id=\$GLOBAL_TG_CHATID" -d "text=\$MSG" -d parse_mode="HTML" >/dev/null 2>&1
        touch "\$LOCK_100"
    fi
elif [ "\$TRIGGER_80" -eq 1 ]; then
    if [ ! -f "\$LOCK_80" ]; then
        LIMIT_80=\$(awk -v l="\$LIMIT_GB" 'BEGIN{print l * 0.8}')
        MSG="⚠️ <b>[Velox 流量超标预警]</b>
大佬注意！您的机器 <code>\$(hostname)</code> 本月【\$MODE_NAME】已达 <b>\${USAGE_GB} GB</b>！
已触发 80% 安全警戒线 (\${LIMIT_80} GB)，请合理安排使用！"
        curl -s -X POST "https://api.telegram.org/bot\$GLOBAL_TG_TOKEN/sendMessage" -d "chat_id=\$GLOBAL_TG_CHATID" -d "text=\$MSG" -d parse_mode="HTML" >/dev/null 2>&1
        touch "\$LOCK_80"
    fi
fi
EOF_ALERT
                    chmod +x /usr/local/bin/velox_traffic_alert.sh
                    crontab -l 2>/dev/null | grep -v "velox_traffic_alert.sh" | crontab -
                    (crontab -l 2>/dev/null; echo "0 * * * * /usr/local/bin/velox_traffic_alert.sh") | crontab -
                    
                    # 🚀 发送连通性测试信
                    USAGE_GB=$(vnstat -i "$DEFAULT_IF" --oneline b 2>/dev/null | awk -F';' -v mode="$MODE_NAME" '{if($1=="1"){b=(mode=="出站上传(TX)")?$9:$10}else{b=(mode=="出站上传(TX)")?$10:$11}; printf "%.2f", b/1073741824}')
                    WARN_GB=$(awk -v l="$limit_gb" 'BEGIN{print l * 0.8}')
                    TEST_MSG="🟢 <b>[Velox 流量管家]</b> 部署测试！
服务器 <code>$(hostname)</code> 流量防线已激活！
👉 <b>监控网卡:</b> $DEFAULT_IF
👉 <b>监控模式:</b> $MODE_NAME
📊 <b>当前已用:</b> ${USAGE_GB} GB
⚠️ <b>预警黄线:</b> ${WARN_GB} GB (达到自动报警)
🛑 <b>熔断红线:</b> ${limit_gb} GB (达到发绝杀信)"
                    curl -s -X POST "https://api.telegram.org/bot$tg_token/sendMessage" -d "chat_id=$tg_chatid" -d "text=$TEST_MSG" -d parse_mode="HTML" >/dev/null 2>&1
                    
                    echo -e "\n${green}✅ [$MODE_NAME] 防线部署成功！雷达已潜伏入系统底层守护！${plain}"
                    echo -e "${purple}🔔 叮咚！已向您的 TG 发送了一封【部署连通性测试信】，请立即查看！${plain}"
                    read -p "👉 按【回车键】继续..."
                    ;;
                    
                3)
                    clear
                    echo -e "${cyan}=======================================================${plain}"
                    echo -e "     📈 Velox 极客视窗 - 无闪烁实时网络监控仪"
                    echo -e "     💡 ${yellow}直接在键盘按【任意键】即可无缝退出${plain}"
                    echo -e "${cyan}=======================================================${plain}\n\n\n"
                    
                    while true; do
                        if [ ! -d "/sys/class/net/$DEFAULT_IF/statistics" ]; then
                            echo -e "\n${red}❌ 致命错误：无法定位网卡 [$DEFAULT_IF]。${plain}"
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
                        
                        # 无闪烁刷新核心：利用 ANSI 控制符原地覆盖，消灭清屏导致的闪屏问题
                        printf "\033[4A"
                        printf "⬇️  下载: \033[1;32m%7s\033[0m KB/s | \033[1;36m%-35s\033[0m\n" "$RX_KB" "$RX_BAR"
                        printf "⬆️  上传: \033[1;31m%7s\033[0m KB/s | \033[1;33m%-35s\033[0m\n" "$TX_KB" "$TX_BAR"
                        echo -e "\n👉 \033[1;33m正在实时监控中... (按任意键退出)\033[0m\033[K"
                    done
                    echo -e "\n${green}✅ 已退出动态监控。${plain}"
                    sleep 0.5
                    ;;
                0) break ;;
                *) echo -e "\n${red}❌ 无效选择。${plain}"; sleep 1 ;;
            esac
        done
        ;;
        
   17)
        echo -e "\n${blue}--- 💽 自定义虚拟内存 (Swap) 管理 ---${plain}"
        check_virt_safe "Swap 虚拟内存硬盘挂载" || { read -p "👉 按【回车键】继续..."; continue; }

        current_swap=$(free -m | awk '/Swap/ {print $2}')
        if [ "$current_swap" -gt "0" ]; then
            echo -e "${green}✅ 检测到当前已开启 ${current_swap} MB 虚拟内存。${plain}"
            read -p "👉 是否需要【彻底关闭并无痕卸载】虚拟内存？(y/n): " del_swap
            if [[ "${del_swap,,}" == "y" ]]; then
                echo -e "${yellow}正在执行物理拔管，强拆 Swap 空间...${plain}"
                swapoff -a
                rm -f /swapfile
                sed -i '/swapfile/d' /etc/fstab
                echo -e "${green}✅ 虚拟内存已彻底清空卸载！${plain}"
            fi
        else
            echo -e "${yellow}⚠️ 当前未开启虚拟内存，小内存机器极易爆内存宕机！${plain}"
            read -p "👉 是否立即创建虚拟内存文件？(y/n): " add_swap
            if [[ "${add_swap,,}" == "y" ]]; then
                read -p "👉 请输入划拨容量 (纯数字，单位:GB，例如填 2 代表 2GB): " swap_size
                if [[ "$swap_size" =~ ^[0-9]+$ ]]; then
                    echo -e "${cyan}⚙️ 正在为您划拨 ${swap_size}GB 硬盘空间作为防爆装甲...${plain}"
                    # 暴力写入双重保险
                    fallocate -l ${swap_size}G /swapfile 2>/dev/null || dd if=/dev/zero of=/swapfile bs=1M count=$((swap_size * 1024)) status=progress
                    chmod 600 /swapfile
                    mkswap /swapfile > /dev/null 2>&1
                    swapon /swapfile
                    echo '/swapfile none swap sw 0 0' >> /etc/fstab
                    echo -e "${green}✅ ${swap_size}GB 虚拟内存装载完毕！系统运行更稳定了。${plain}"
                else
                    echo -e "${red}❌ 格式错误，为了防炸膛，请输入纯数字！${plain}"
                fi
            fi
        fi
        
        echo ""
        read -p "👉 按【回车键】继续..."
        ;;
        
    18)
        echo -e "\n${blue}--- 📝 修改服务器主机名 (VPS 物理改名/洗白) ---${plain}"
        echo -e "当前主机名: ${yellow}$(hostname)${plain}"
        echo -e "  ${green}1.${plain} 🔄 恢复系统默认主机名 (洗白为: localhost)"
        echo -e "  ${cyan}0.${plain} 🔙 返回主菜单"
        read -p "👉 请输入新主机名(纯英文/数字)，或输入 [0-1] 执行选项: " new_hostname
        
        if [ "$new_hostname" == "0" ] || [ -z "$new_hostname" ]; then
            echo -e "\n${yellow}已取消操作，返回主菜单。${plain}"
        elif [ "$new_hostname" == "1" ]; then
            hostnamectl set-hostname "localhost"
            # 极客细节：修复 /etc/hosts，绝杀 sudo 解析报错暗雷
            sed -i "s/127.0.0.1.*/127.0.0.1 localhost/g" /etc/hosts
            echo -e "\n${green}✅ 主机名已成功洗白为系统默认: localhost ${plain}"
            echo -e "💡 提示: 重新连接 SSH 终端后即可看到全新名称！"
        elif [[ "$new_hostname" =~ ^[a-zA-Z0-9-]+$ ]]; then
            hostnamectl set-hostname "$new_hostname"
            # 极客细节：同步注入 /etc/hosts 防炸膛
            sed -i "s/127.0.0.1.*/127.0.0.1 localhost $new_hostname/g" /etc/hosts
            echo -e "\n${green}✅ 主机名已成功修改为: $new_hostname ${plain}"
            echo -e "💡 提示: 重新连接 SSH 终端后即可生效！"
        else
            echo -e "\n${red}❌ 格式致命错误！主机名只能包含字母、数字和连字符(-)。${plain}"
        fi
        
        if [ "$new_hostname" != "0" ] && [ -n "$new_hostname" ]; then
            echo ""
            read -p "👉 按【回车键】继续..."
        fi
        ;;
        
    19)
        echo -e "\n${blue}=== 🔄 一键系统全能更新与焦土清理 (防卡死纯净版) ===${plain}"
        echo -e "${yellow}正在调用底层包管理器拉取最新防弹补丁，请耐心等待...${plain}\n"
        
        if command -v apt-get >/dev/null 2>&1; then
            echo -e "${cyan}📦 正在执行 Ubuntu/Debian 极限更新指令...${plain}"
            apt-get update -yqq
            # 终极防卡死参数：强行静默，默认保留旧配置，告别紫色弹窗卡死
            DEBIAN_FRONTEND=noninteractive apt-get -o Dpkg::Options::="--force-confdef" -o Dpkg::Options::="--force-confold" upgrade -yqq
            
        elif command -v dnf >/dev/null 2>&1; then
            echo -e "${cyan}📦 正在执行 RHEL/Fedora 极限更新指令...${plain}"
            dnf check-update -q
            dnf upgrade -yq
            
        elif command -v yum >/dev/null 2>&1; then
            echo -e "${cyan}📦 正在执行 CentOS 极限更新指令...${plain}"
            yum check-update -q
            yum upgrade -yq
        fi
        
        echo -e "\n${cyan}🧹 正在呼叫智能路由执行系统焦土化清理...${plain}"
        # 直接动用咱们之前封装的全局清理大招，一行顶十行！
        $PKG_CLEAN >/dev/null 2>&1
        
        echo -e "\n${green}✅ 系统底层库及内核组件已满血更新，且历史冗余包已物理粉碎！${plain}"
        read -p "👉 按【回车键】返回主菜单..."
        ;;
        
   20)
        while true; do
            # --- 🕵️‍♂️ 史诗级智能侦测引擎 ---
            current_port=$(grep -iE "^Port " /etc/ssh/sshd_config | awk '{print $2}' | head -n 1)
            [ -z "$current_port" ] && current_port="22 (默认)"

            pwd_auth=$(grep -i "^PasswordAuthentication" /etc/ssh/sshd_config | awk '{print $2}' | tr -d '\r' | head -n 1)

            if [[ "$pwd_auth" == "no" ]]; then
                login_status="${green}仅限密钥登录 (极高安全) 🛡️${plain}"; pw_toggle="重新开启密码"
            elif [ -f ~/.ssh/authorized_keys ] && [ -s ~/.ssh/authorized_keys ]; then
                login_status="${yellow}密钥/密码混合模式 (建议锁死) ⚠️${plain}"; pw_toggle="强制关闭密码"
            else
                login_status="${red}纯密码登录 (极高风险) 🚨${plain}"; pw_toggle="强制关闭密码"
            fi

            defender_status="${red}裸奔中 (未部署防爆破)${plain}"
            if systemctl is-active --quiet velox-defender 2>/dev/null; then
                defender_status="${cyan}已激活 (纯 Bash 轻量机枪塔)${plain}"
            elif systemctl is-active --quiet fail2ban 2>/dev/null; then
                defender_status="${purple}已激活 (Fail2Ban 工业级装甲)${plain}"
            fi

            echo -e "\n${blue}=== 🚨 SSH 智能动态防盗门与双核防御中心 ===${plain}"
            echo -e "🔹 当前状态 -> 端口: [${cyan}$current_port${plain}] | 模式: [$login_status]"
            echo -e "🔹 实时防御: [$defender_status]"
            echo -e "${cyan}--------------------------------------------------------------------------------${plain}"
            echo -e "  ${green}1.${plain} 🕵️  查看当前在线 SSH 用户并实施制裁"
            echo -e "  ${green}2.${plain} 💣  审计被拦截的黑客爆破日志 (查外鬼)"
            echo -e "  ${cyan}3.${plain} 🚪  修改 SSH 端口 (输入 22 即可恢复默认)"
            echo -e "  ${yellow}4.${plain} 🔑  一键切换密码登录开关 (执行: $pw_toggle)"
            echo -e "  ${purple}5.${plain} 🚀  一键部署免密登录并【锁死密码】(极客推荐)"
            echo -e "  ${red}6.${plain} 🛡️  部署/卸载安全防御武器库 (机枪塔/Fail2Ban)"
            echo -e "  ${yellow}0.${plain} 🔙  返回主菜单"
            echo -e "${cyan}--------------------------------------------------------------------------------${plain}"
            read -p "👉 请选择安全操作 [0-6]: " ssh_choice
            
            case $ssh_choice in
                1)
                    echo -e "\n${blue}--- 🕵️ 查看当前在线 SSH 用户 ---${plain}"
                    w
                    echo -e "${cyan}---------------------------------------------------${plain}"
                    read -p "👉 请输入要制裁的终端号 (例如 pts/1，完整输入): " target_pts
                    if [[ -n "$target_pts" && "$target_pts" =~ ^pts/[0-9]+$ ]]; then
                        if w | grep -q "$target_pts"; then
                            target_ip=$(w | grep "$target_pts" | grep -oE '[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+' | head -1)
                            [ -z "$target_ip" ] && target_ip="未知IP或隐藏来源"
                            
                            echo -e "\n${yellow}🎯 已锁定目标: 终端 [$target_pts] | 来源 IP: [$target_ip]${plain}"
                            echo -e "  ${cyan}1.${plain} 🥾 强行踢出\n  ${cyan}2.${plain} 🧱 永久拉黑\n  ${cyan}3.${plain} 👻 极客恶搞"
                            read -p "👉 选择制裁套餐 [1-3]: " punish_choice
                            case $punish_choice in
                                1) sudo pkill -9 -t "${target_pts#*/}" 2>/dev/null || sudo skill -9 "$target_pts"; echo -e "${green}✅ 已踢出！${plain}" ;;
                                2)
                                    [ "$target_ip" != "未知IP或隐藏来源" ] && sudo iptables -A INPUT -s "$target_ip" -j DROP
                                    sudo pkill -9 -t "${target_pts#*/}" 2>/dev/null || sudo skill -9 "$target_pts"; echo -e "${green}✅ 已永久拉黑！${plain}" ;;
                                3)
                                    echo -e "\n${purple}😈 发送死神警告...${plain}"
                                    sudo bash -c "echo -e '\n\n\033[1;31m[FATAL WARNING] UNAUTHORIZED ACCESS. CONNECTION TERMINATED.\033[0m' > /dev/$target_pts" 2>/dev/null
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
                        
                        if [ "$new_port" -eq 22 ]; then 
                            echo -e "\n${green}✅ SSH 端口已恢复为默认 ${red}22${plain} 端口！${plain}"
                        else 
                            vps_ip=$(echo $SSH_CONNECTION | awk '{print $3}')
                            if [ -z "$vps_ip" ]; then
                                real_iface=$(ip -4 route ls | grep default | grep -vE 'wg|warp|tun' | awk '{print $5}' | head -n 1)
                                vps_ip=$(curl -s4m8 --interface "$real_iface" https://icanhazip.com 2>/dev/null)
                            fi
                            [ -z "$vps_ip" ] && vps_ip="您的VPS真实IP"

                            echo -e "\n${yellow}================ 🚨 极客换门指南 & 避坑必读 🚨 =================${plain}"
                            echo -e "${green}✅ SSH 端口已成功切换至: ${new_port}${plain}"
                            echo -e "👉 当前窗口断开后，请使用以下全新口令登录："
                            echo -e "${cyan}ssh root@${vps_ip} -p ${new_port}${plain}\n"
                            
                            echo -e "${purple}💡 【如果改完端口后连不上怎么办？】${plain}"
                            echo -e " ${cyan}▶ 场景 A: 终端提示 REMOTE HOST IDENTIFICATION HAS CHANGED${plain}"
                            echo -e "   本地执行: ${green}ssh-keygen -R \"[${vps_ip}]:${new_port}\"${plain} 洗白记录即可！"
                            echo -e " ${cyan}▶ 场景 B: 客户端弹窗提示主机密钥已更改${plain}"
                            echo -e "   直接点击 ${green}「接受并保存」${plain} 即可进入！"
                            echo -e "${yellow}=================================================================${plain}\n"
                            echo -e "⚠️ ${red}切记：务必去云服务商（如 GCP/AWS）网页防火墙放行 ${new_port} 端口！${plain}"
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
                        if [[ "${confirm_key,,}" == "y" ]]; then
                            sed -i 's/^#\?PasswordAuthentication.*/PasswordAuthentication no/g' /etc/ssh/sshd_config
                            grep -q "^PasswordAuthentication no" /etc/ssh/sshd_config || echo "PasswordAuthentication no" >> /etc/ssh/sshd_config
                            systemctl restart sshd 2>/dev/null || systemctl restart ssh 2>/dev/null
                            echo -e "\n${green}✅ 密码登录已【永久关闭】！(防线已锁死)${plain}"
                        fi
                    fi
                    ;;
                5)
                    echo -e "\n${cyan}=== 🔐 极客级密钥部署与防线飞升程序 ===${plain}"
                    echo -e "${yellow}💡 本地获取公钥指令 (Mac/Win10+): ${green}cat ~/.ssh/id_ed25519.pub${plain}"
                    read -p "✍️  请在此粘贴您的公钥 (ssh-rsa/ssh-ed25519...): " ssh_pub_key
                    if [[ "$ssh_pub_key" == ssh-rsa* ]] || [[ "$ssh_pub_key" == ssh-ed25519* ]] || [[ "$ssh_pub_key" == ecdsa-sha2* ]]; then
                        mkdir -p ~/.ssh && chmod 700 ~/.ssh
                        grep -q "$ssh_pub_key" ~/.ssh/authorized_keys 2>/dev/null || echo "$ssh_pub_key" >> ~/.ssh/authorized_keys
                        chmod 600 ~/.ssh/authorized_keys
                        
                        sed -i 's/^#\?PasswordAuthentication.*/PasswordAuthentication no/g' /etc/ssh/sshd_config
                        sed -i 's/^#\?PubkeyAuthentication.*/PubkeyAuthentication yes/g' /etc/ssh/sshd_config
                        grep -q "^PasswordAuthentication no" /etc/ssh/sshd_config || echo "PasswordAuthentication no" >> /etc/ssh/sshd_config
                        
                        systemctl restart sshd 2>/dev/null || systemctl restart ssh 2>/dev/null
                        echo -e "\n${green}✅ 公钥注入成功！密码登录已物理切断，防御力拉满！${plain}"
                    else 
                        echo -e "\n${red}❌ 格式识别失败！确保粘贴的是以 ssh- 开头的【公钥】。${plain}"
                    fi
                    ;;
               6)
                    echo -e "\n${blue}--- 🚀 Velox 双核安全防御武器库 ---${plain}"
                    echo -e "  ${cyan}1.${plain} 🟢 [极简特种兵] 部署纯 Bash 机枪塔 (0 内存消耗，专防 SSH)"
                    echo -e "  ${cyan}2.${plain} 🗑️ ${red}[极简特种兵] 拆除并物理粉碎 Bash 机枪塔${plain}"
                    echo -e "  ${purple}3.${plain} 🛡️ [工业正规军] 安装 Fail2Ban (全面防护，适度占内存)"
                    echo -e "  ${purple}4.${plain} 🗑️ ${red}[工业正规军] 完全卸载 Fail2Ban${plain}"
                    echo -e "  ${yellow}5.${plain} 📜 查看武器库防御战果与拦截名单"
                    read -p "👉 请选择武器库操作 [1-5]: " def_choice
                    
                    if [ "$def_choice" == "1" ]; then
                        echo -e "\n${yellow}正在手搓 Bash 底层守护进程并注入 Systemd...${plain}"
                        
                        # 🚀 降维打击 1：抛弃丑陋的 echo 拼接，直接用原生 Heredoc 生成防爆破脚本
                        cat << 'EOF_DEFENDER' > /usr/local/bin/velox-defender.sh
#!/bin/bash
if [ -f /var/log/auth.log ]; then LOG_CMD="tail -Fn0 /var/log/auth.log"
elif [ -f /var/log/secure ]; then LOG_CMD="tail -Fn0 /var/log/secure"
else LOG_CMD="journalctl -u ssh -u sshd -fn0"; fi

eval "$LOG_CMD" | awk '/Failed password/ {print $(NF-3)}' | while read IP; do
    if [ -n "$IP" ]; then
        COUNT=$(grep -c "^$IP$" /tmp/velox_ip_counts.txt 2>/dev/null || echo 0)
        if [ "$COUNT" -ge 4 ]; then
            if ! iptables -C INPUT -s "$IP" -j DROP &>/dev/null; then 
                iptables -I INPUT -s "$IP" -j DROP
                echo "$(date +'%Y-%m-%d %H:%M:%S') - 💥 击毙爆破 IP: $IP" >> /var/log/velox-defender.log
            fi
            sed -i "/^$IP$/d" /tmp/velox_ip_counts.txt 2>/dev/null
        else 
            echo "$IP" >> /tmp/velox_ip_counts.txt
        fi
    fi
done
EOF_DEFENDER
                        chmod +x /usr/local/bin/velox-defender.sh
                        
                        cat << 'EOF_SVC' > /etc/systemd/system/velox-defender.service
[Unit]
Description=Velox SSH Defender Auto-Ban Daemon
After=network.target

[Service]
ExecStart=/usr/local/bin/velox-defender.sh
Restart=always
RestartSec=3

[Install]
WantedBy=multi-user.target
EOF_SVC
                        systemctl daemon-reload; systemctl enable --now velox-defender >/dev/null 2>&1
                        echo -e "${green}✅ Bash 机枪塔已部署！连续输错 5 次密码的 IP 将被物理击毙！${plain}"
                        
                    elif [ "$def_choice" == "2" ]; then
                        systemctl disable --now velox-defender >/dev/null 2>&1
                        rm -f /usr/local/bin/velox-defender.sh /etc/systemd/system/velox-defender.service /tmp/velox_ip_counts.txt /var/log/velox-defender.log
                        systemctl daemon-reload
                        echo -e "${green}✅ Bash 机枪塔已彻底拆除！${plain}"
                        
                    elif [ "$def_choice" == "3" ]; then
                        virt_type=$(systemd-detect-virt 2>/dev/null || echo "unknown")
                        if [[ "$virt_type" == "lxc" || "$virt_type" == "openvz" ]]; then
                            echo -e "\n${red}❌ 致命拦截：容器架构 ($virt_type) 强装 Fail2Ban 将导致断网失联！请使用 Bash 机枪塔！${plain}"
                        else
                            echo -e "\n${yellow}正在调用智能路由安装 Fail2Ban 工业装甲...${plain}"
                           if ! command -v fail2ban-client >/dev/null 2>&1; then
                                $PKG_INSTALL fail2ban >/dev/null 2>&1
                            fi
                            
                            # 🚀 降维打击 2：智能适配 Debian 12 / Ubuntu 22+ 的纯 journalctl 环境
                            if [ -f /var/log/auth.log ]; then LOG_CFG="logpath = /var/log/auth.log"
                            elif [ -f /var/log/secure ]; then LOG_CFG="logpath = /var/log/secure"
                            else LOG_CFG="backend = systemd"; fi

                            cat << EOF_F2B > /etc/fail2ban/jail.local
[sshd]
enabled = true
port = ssh
filter = sshd
$LOG_CFG
maxretry = 5
bantime = 86400
EOF_F2B
                            systemctl enable --now fail2ban >/dev/null 2>&1; systemctl restart fail2ban >/dev/null 2>&1
                            echo -e "${green}✅ Fail2Ban 顶级装甲已部署完毕！(默认封禁 24 小时)${plain}"
                        fi
                        
                    elif [ "$def_choice" == "4" ]; then
                        echo -e "\n${yellow}正在暴力拆除 Fail2Ban...${plain}"
                        systemctl disable --now fail2ban >/dev/null 2>&1
                        $PKG_REMOVE fail2ban >/dev/null 2>&1
                        rm -rf /etc/fail2ban
                        echo -e "${green}✅ Fail2Ban 已彻底抹除！${plain}"
                        
                    elif [ "$def_choice" == "5" ]; then
                        if systemctl is-active --quiet velox-defender 2>/dev/null; then
                            echo -e "\n${cyan}--- 🎖️ Bash 机枪塔战果统计 (最新 15 条) ---${plain}"
                            [ -f "/var/log/velox-defender.log" ] && tail -n 15 /var/log/velox-defender.log || echo "暂无击毙记录！"
                        elif systemctl is-active --quiet fail2ban 2>/dev/null; then
                            echo -e "\n${purple}--- 🎖️ Fail2Ban 拦截战果 ---${plain}"
                            fail2ban-client status sshd
                        else
                            echo -e "\n${yellow}⚠️ 未开启任何防御系统！${plain}"
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
    
       21)
        while true; do
            clear
            echo -e "\n${blue}=== ⏱️ Velox 高级定时任务与时空调度中心 ===${plain}"
            echo -e "${yellow}说明：设置后系统会在指定时间自动干活。再次设置将智能覆盖旧任务，绝不重叠。${plain}"
            timedatectl set-timezone Asia/Shanghai
            echo -e "当前系统已强制锚定北京时间：${green}$(date +"%Y-%m-%d %H:%M:%S")${plain}\n"
            
            echo -e "${cyan}【VPS 整机自动重启】 (物理清空内存碎片，防死机)${plain}"
            echo -e "  ${green}1.${plain} 设置 [每天] 定时整机重启      ${red}11.${plain} 彻底删除 [整机重启] 任务"
            echo -e "  ${green}2.${plain} 设置 [每周] 定时整机重启"
            echo -e "  ${green}3.${plain} 设置 [每月] 定时整机重启"
            echo -e "\n${cyan}【WARP 链路自动刷新】 (防流媒体/ChatGPT IP 被封锁)${plain}"
            echo -e "  ${green}4.${plain} 设置 [每天] 定时刷新 WARP     ${red}44.${plain} 彻底删除 [刷新WARP] 任务"
            echo -e "\n${cyan}【综合任务管理】${plain}"
            echo -e "  ${purple}5.${plain} 📜 查看当前已生效的任务雷达图  ${purple}6.${plain} ✍️  手动高级编辑 (极客专属)"
            echo -e " ${red}55.${plain} 💥 一键焦土化清空所有任务     ${yellow}0.${plain} 🔙 返回主菜单"
            echo -e "--------------------------------------------------------"
            read -p "👉 请输入调度指令 [0-6, 11, 44, 55]: " cron_choice

            case $cron_choice in
                1) 
                    read -p "👉 请输入每天重启的小时(0-23, 填4代表凌晨4点) [回车取消]: " h
                    if [[ "$h" =~ ^[0-9]+$ && "$h" -ge 0 && "$h" -le 23 ]]; then
                        # 🚀 降维打击：内存级管道覆写 + 缝死输出防爆盘
                        (crontab -l 2>/dev/null | grep -v "/sbin/reboot"; echo "0 $h * * * /sbin/reboot >/dev/null 2>&1") | crontab -
                        echo -e "\n${green}✅ 调度生效！每天北京时间 $h:00 会自动执行物理拔管重启。${plain}"
                    else
                        echo -e "\n${yellow}⚠️ 防呆拦截：输入无效或已取消，未执行任何修改。${plain}"
                    fi
                    ;;
                2) 
                    read -p "👉 星期几执行重启(1-7, 7代表周日) [回车取消]: " d
                    read -p "👉 几点重启(0-23, 填4代表凌晨4点) [回车取消]: " h
                    if [[ "$d" =~ ^[1-7]$ && "$h" =~ ^[0-9]+$ && "$h" -ge 0 && "$h" -le 23 ]]; then
                        [ "$d" == "7" ] && d=0
                        (crontab -l 2>/dev/null | grep -v "/sbin/reboot"; echo "0 $h * * $d /sbin/reboot >/dev/null 2>&1") | crontab -
                        echo -e "\n${green}✅ 调度生效！每周 $d 的北京时间 $h:00 会自动重启 VPS。${plain}"
                    else
                        echo -e "\n${yellow}⚠️ 防呆拦截：输入无效或已取消，未执行任何修改。${plain}"
                    fi
                    ;;
                3) 
                    read -p "👉 每月几号执行重启(1-28) [回车取消]: " d
                    read -p "👉 几点重启(0-23, 填4代表凌晨4点) [回车取消]: " h
                    if [[ "$d" =~ ^([1-9]|1[0-9]|2[0-8])$ && "$h" =~ ^[0-9]+$ && "$h" -ge 0 && "$h" -le 23 ]]; then
                        (crontab -l 2>/dev/null | grep -v "/sbin/reboot"; echo "0 $h $d * * /sbin/reboot >/dev/null 2>&1") | crontab -
                        echo -e "\n${green}✅ 调度生效！每月 $d 号的北京时间 $h:00 会自动重启 VPS。${plain}"
                    else
                        echo -e "\n${yellow}⚠️ 防呆拦截：输入无效或已取消，未执行任何修改。${plain}"
                    fi
                    ;;
                11)
                    (crontab -l 2>/dev/null | grep -v "/sbin/reboot") | crontab -
                    echo -e "\n${green}✅ 绝杀成功！已物理抹除 [VPS整机自动重启] 相关的定时任务。${plain}"
                    ;;
                4) 
                    read -p "👉 请输入每天刷新 WARP 的小时(0-23) [回车取消]: " h
                    if [[ "$h" =~ ^[0-9]+$ && "$h" -ge 0 && "$h" -le 23 ]]; then
                        # 兼容多版本 WARP 客户端重启，同样加上静默输出
                        WARP_CMD="systemctl stop warp-go; systemctl restart warp-go; systemctl restart wg-quick@wgcf; systemctl restart warp-svc"
                        (crontab -l 2>/dev/null | grep -i -v "warp"; echo "0 $h * * * $WARP_CMD >/dev/null 2>&1") | crontab -
                        echo -e "\n${green}✅ 调度生效！每天北京时间 $h:00 会自动强刷所有 WARP 守护进程换 IP。${plain}"
                    else
                        echo -e "\n${yellow}⚠️ 防呆拦截：输入无效或已取消，未执行任何修改。${plain}"
                    fi
                    ;;
                44)
                    (crontab -l 2>/dev/null | grep -i -v "warp") | crontab -
                    echo -e "\n${green}✅ 绝杀成功！已物理抹除 [WARP IP 自动刷新] 相关的定时任务。${plain}"
                    ;;
                5) 
                    echo -e "\n${yellow}👇 核心雷达：当前系统已生效的定时任务列表如下：${plain}"
                    crontab -l 2>/dev/null || echo -e "${cyan}暂无任何激活的定时任务！${plain}"
                    echo -e "${yellow}--------------------------------------------------------${plain}"
                    ;;
                6) 
                    echo -e "\n${cyan}正在进入 crontab 极客编辑模式... (按 Ctrl+X 或 :wq 保存退出)${plain}"
                    crontab -e
                    echo -e "\n${green}✅ 手动手术结束。${plain}"
                    ;;
                55)
                    read -p "⚠️ 危险指令：这会彻底强拆当前用户的所有定时任务！确定要执行吗？(y/n): " clear_all
                    if [[ "${clear_all,,}" == "y" ]]; then
                        crontab -r 2>/dev/null
                        echo -e "\n${red}💥 焦土打击完成！已强行清空所有定时任务！${plain}"
                    else
                        echo -e "\n${yellow}已取消清空操作。${plain}"
                    fi
                    ;;
                0) 
                    echo -e "\n${green}正在撤离时空调度中心，返回主界面...${plain}"
                    break
                    ;;
                *) 
                    echo -e "\n${red}❌ 指令未能识别，请重新输入。${plain}"
                    ;;
            esac
            
            if [[ "$cron_choice" != "0" ]]; then
                echo ""
                read -p "👉 按【回车键】继续..."
            fi
        done
        ;;
        
    22)
        echo -e "\n${blue}=== 🔐 Acme 域名证书深度体检与管理 (极客全自动版) ===${plain}"
        
       # 💡 防崩依赖：强制判定 fuser，确保能强行释放 80 端口
        if ! command -v fuser >/dev/null 2>&1; then
            echo -e "${yellow}⚙️ 正在向底层注入缺失装甲: psmisc...${plain}"
            $PKG_INSTALL psmisc >/dev/null 2>&1
        fi
        
        # 智能侦测 Acme.sh 真实路径
        ACME_BIN=""
        if [ -f "/root/.acme.sh/acme.sh" ]; then ACME_BIN="/root/.acme.sh/acme.sh"
        elif [ -f "$HOME/.acme.sh/acme.sh" ]; then ACME_BIN="$HOME/.acme.sh/acme.sh"; fi

        if [ -z "$ACME_BIN" ]; then
            echo -e "${yellow}⚠️ 未检测到 Acme.sh 安装路径。${plain}"
            echo -e "可能原因：当前 VPS 未申请过本地证书，或使用了其他证书管理工具。"
        else
            echo -e "${cyan}👇 当前 VPS 本地已申请的证书列表与到期时间如下：${plain}"
            echo -e "${yellow}--------------------------------------------------------------------------------${plain}"
            "$ACME_BIN" --list
            echo -e "${yellow}--------------------------------------------------------------------------------${plain}"
            
            echo -e "\n${green}💡 极客科普：${plain}"
            echo -e "正常的 Acme 脚本会自动在后台续签。若发现节点突然断流，且距离到期不足 10 天，请手动强制续签！"
            
            # 🚀 进阶子菜单：续签与卸载彻底分离
            echo -e "\n  ${green}1.${plain} 🚀 强制续签证书 (智能注入 Nginx 避让与节点重启守护)"
            echo -e "  ${red}2.${plain} 🗑️ 彻底删除证书 (焦土化清理无用域名残留)"
            echo -e "  ${yellow}0.${plain} 🔙 取消并返回主菜单"
            echo -e "${cyan}--------------------------------------------------------------------------------${plain}"
            read -p "👉 请选择进阶管理操作 [0-2]: " acme_choice
            
            case $acme_choice in
                1)
                    read -p "✍️ 请输入需要续签的【主域名 Main_Domain】 (例如 node.123.xyz): " renew_domain
                    if [ -n "$renew_domain" ]; then
                        echo -e "\n${yellow}⏳ 正在向 Acme 底层注入端口避让与服务联动逻辑...${plain}"
                        
                        # 核心防线：把停端口和启服务的命令，打包塞进 Acme 的钩子(Hook)里，实现断流秒连
                        PRE_HOOK="systemctl stop nginx apache2 >/dev/null 2>&1; fuser -k 80/tcp >/dev/null 2>&1"
                        POST_HOOK="systemctl restart nginx sing-box xray x-ui 3x-ui v2ray >/dev/null 2>&1"
                        
                        echo -e "${cyan}⏳ 正在向 CA 签发机构请求续签 [ ${renew_domain} ]，请耐心等待...${plain}"
                        
                        "$ACME_BIN" --renew -d "$renew_domain" --force --ecc --pre-hook "$PRE_HOOK" --post-hook "$POST_HOOK"
                        if [ $? -ne 0 ]; then
                            echo -e "\n${yellow}⚠️ ECC 模式续签失败，正在尝试切换为 RSA 模式强行重试...${plain}"
                            "$ACME_BIN" --renew -d "$renew_domain" --force --pre-hook "$PRE_HOOK" --post-hook "$POST_HOOK"
                        fi
                        
                        echo -e "\n${green}✅ 操作完毕！Web 容器与代理服务已满血复活！${plain}"
                        echo -e "💡 ${cyan}提示：避让逻辑已刻入底层配置。以后的后台自动续签将【100%防炸全自动】完成，无需手动干预！${plain}"
                    else
                        echo -e "${red}❌ 域名输入为空，已取消续签操作。${plain}"
                    fi
                    ;;
                2)
                    read -p "✍️ 请输入需要彻底物理吊销的【旧域名 Main_Domain】: " del_domain
                    if [ -n "$del_domain" ]; then
                        echo -e "\n${yellow}⏳ 正在向 CA 机构请求吊销，并抹除续签守护...${plain}"
                        
                        # 官方标准注销命令 (兼顾 ECC 和 RSA)
                        "$ACME_BIN" --remove -d "$del_domain" --ecc 2>/dev/null
                        "$ACME_BIN" --remove -d "$del_domain" 2>/dev/null
                        
                        echo -n "正在物理粉碎本地残留的证书实体文件... "
                        rm -rf ~/.acme.sh/"$del_domain"
                        rm -rf ~/.acme.sh/"${del_domain}_ecc"
                        echo -e "[${green}已彻底焦土化${plain}]"
                        
                        echo -e "\n✅ ${green}操作完毕！该域名证书已被完全销毁，系统将不再触发失效续签报错！${plain}"
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
        
       23)
        while true; do
            echo -e "\n${blue}=== 🛰️ 星际舰队与跨机容灾中心 ===${plain}"
            echo -e "  ${green}1.${plain} 📦 全域资产一键打包与跨机搬家 (真·动态路径克隆版)"
            echo -e "  ${cyan}2.${plain} 🤝 组建舰队: 配置多机免密互信 (打通专属 SSH 桥梁)"
            echo -e "  ${purple}3.${plain} 🚀 舰队出击: 向所有僚机群发执行指令 (万机齐发)"
            echo -e "  ${red}4.${plain} 🗑️ 解散舰队: 清除本机群发记录与专属密钥 (安全无痕)"
            echo -e "  ${yellow}0.${plain} 返回主菜单"
            echo -e "--------------------------------------------------------"
            read -p "👉 请选择操作 [0-4]: " fleet_choice
            
            case $fleet_choice in
                1)
                    echo -e "\n${blue}--- 🧳 模块化资产精准打包与跨机搬家 ---${plain}"
                    echo -e "${yellow}正在启动模块化高维雷达，精准嗅探高价值战略资产...${plain}\n"

                    has_data=0
                    BACKUP_LIST=""

                    # ================= 1. Nginx 幽灵分发中枢 =================
                    if [ -d "/var/www/stealth_8x9q2z" ] || [ -f "/etc/nginx/conf.d/stealth.conf" ]; then
                        echo -e "📡 雷达锁定: ${purple}发现 [Nginx 私有分发地堡与同步引擎]${plain}"
                        read -p "👉 是否打包此模块？(y/n) [回车默认 y]: " pack_nginx
                        if [[ "${pack_nginx,,}" != "n" ]]; then
                            [ -d "/var/www/stealth_8x9q2z" ] && BACKUP_LIST="$BACKUP_LIST /var/www/stealth_8x9q2z"
                            [ -f "/etc/nginx/conf.d/stealth.conf" ] && BACKUP_LIST="$BACKUP_LIST /etc/nginx/conf.d/stealth.conf"
                            [ -f "/root/sync_github.sh" ] && BACKUP_LIST="$BACKUP_LIST /root/sync_github.sh"
                            [ -f "/root/.github_token" ] && BACKUP_LIST="$BACKUP_LIST /root/.github_token"
                            echo -e "✅ [Nginx 分发中枢] 已装载入克隆舱！\n"
                            has_data=1
                        else
                            echo -e "⏭️  已跳过 [Nginx 分发中枢]。\n"
                        fi
                    fi

                    # ================= 2. 代理核心与面板数据 =================
                    CORE_DIRS="/etc/velox_vne /etc/x-ui /etc/s-box /etc/sing-box /usr/local/etc/xray /etc/velox /usr/local/etc/velox /etc/vne /usr/local/etc/vne /root/agsbx"
                    CORE_FOUND=""
                    for dir in $CORE_DIRS; do [ -e "$dir" ] && CORE_FOUND="$CORE_FOUND $dir"; done
                    
                    if [ -n "$CORE_FOUND" ]; then
                        echo -e "📡 雷达锁定: ${cyan}发现 [代理节点核心配置与面板数据库]${plain}"
                        read -p "👉 是否打包此模块？(y/n) [回车默认 y]: " pack_core
                        if [[ "${pack_core,,}" != "n" ]]; then
                            BACKUP_LIST="$BACKUP_LIST $CORE_FOUND"
                            echo -e "✅ [代理核心数据] 已装载入克隆舱！\n"
                            has_data=1
                        else
                            echo -e "⏭️  已跳过 [代理核心数据]。\n"
                        fi
                    fi

                    # ================= 3. Acme.sh 域名证书 =================
                    ACME_FOUND=""
                    [ -d "/root/.acme.sh" ] && ACME_FOUND="/root/.acme.sh"
                    [ -d "$HOME/.acme.sh" ] && ACME_FOUND="$HOME/.acme.sh"
                    
                    if [ -n "$ACME_FOUND" ]; then
                        echo -e "📡 雷达锁定: ${green}发现 [Acme.sh 域名 SSL 证书库]${plain}"
                        read -p "👉 是否打包此模块？(y/n) [回车默认 y]: " pack_acme
                        if [[ "${pack_acme,,}" != "n" ]]; then
                            BACKUP_LIST="$BACKUP_LIST $ACME_FOUND"
                            echo -e "✅ [SSL 证书库] 已装载入克隆舱！\n"
                            has_data=1
                        else
                            echo -e "⏭️  已跳过 [SSL 证书库]。\n"
                        fi
                    fi

                    # ================= 4. 全局 TG 报警配置 =================
                    if [ -f "/etc/velox_tg.conf" ]; then
                        echo -e "📡 雷达锁定: ${yellow}发现 [全局 Telegram 机器人凭证]${plain}"
                        read -p "👉 是否打包此凭证？(y/n) [回车默认 y]: " pack_tg
                        if [[ "${pack_tg,,}" != "n" ]]; then
                            BACKUP_LIST="$BACKUP_LIST /etc/velox_tg.conf"
                            echo -e "✅ [TG 报警凭证] 已装载入克隆舱！\n"
                            has_data=1
                        else
                            echo -e "⏭️  已跳过 [TG 报警凭证]。\n"
                        fi
                    fi

                    # ================= 5. 定时任务 (Cron) =================
                    if crontab -l > /root/crontab_backup.txt 2>/dev/null && [ -s /root/crontab_backup.txt ]; then
                        echo -e "📡 雷达锁定: ${blue}发现 [系统自动化定时任务 (Crontab)]${plain}"
                        read -p "👉 是否打包系统定时任务？(y/n) [回车默认 y]: " pack_cron
                        if [[ "${pack_cron,,}" != "n" ]]; then
                            BACKUP_LIST="$BACKUP_LIST /root/crontab_backup.txt"
                            echo -e "✅ [自动化定时任务] 已装载入克隆舱！\n"
                            has_data=1
                        else
                            rm -f /root/crontab_backup.txt
                            echo -e "⏭️  已跳过 [自动化定时任务]。\n"
                        fi
                    else
                        rm -f /root/crontab_backup.txt
                    fi

                    echo -e "${cyan}--------------------------------------------------------${plain}"
                    
                    # ================= 6. 自定义游离目录 (联动 24 号雷达) =================
                    echo -e "💡 ${green}除了已选的资产，您是否还有其他自建的神秘应用需要一起打包搬家？${plain}"
                    echo -e "${yellow}🔔 极客提示：您可以根据 24 号资产雷达盘出的路径，在下方直接盲敲注入。${plain}"
                    read -p "👉 请输入完整路径 (多个用空格隔开，直接回车跳过): " custom_paths

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

                    # ================= 最终执行物理打包 =================
                    if [ "$has_data" -eq 1 ]; then
                        echo -e "\n${cyan}⏳ 正在对所选模块进行高强度压缩加密 (强行保留绝对路径与权限)...${plain}"
                        
                        tar --exclude=/root/Velox_Assets_Backup.tar.gz -czpPf /root/Velox_Assets_Backup.tar.gz $BACKUP_LIST >/dev/null 2>&1
                        
                        SSH_PORT=$(grep -iE "^Port " /etc/ssh/sshd_config | awk '{print $2}')
                        [ -z "$SSH_PORT" ] && SSH_PORT="22"

                        echo -e "\n${green}🎉 模块化资产克隆打包完毕！您的定制备份文件已生成：${plain}"
                        echo -e "${cyan}📂 文件绝对路径：/root/Velox_Assets_Backup.tar.gz${plain}"
                        
                        # ================= 👇 TG 云端容灾附加选项 👇 =================
                        echo -e "\n${purple}☁️ 【可选附加项：TG 云端容灾备份】${plain}"
                        read -p "👉 是否顺便将此备份包推送至您的 Telegram 机器人保管？(y/n) [直接回车跳过]: " send_tg
                        if [[ "${send_tg,,}" == "y" ]]; then
                            (
                                SHARED_TG_CONF="/etc/velox_tg.conf" 
                                if [ -f "$SHARED_TG_CONF" ]; then source "$SHARED_TG_CONF"; fi
                                
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
                            )
                        fi
                        # ================= 👆 TG 云端容灾结束 👆 =================
                        
                        echo -e "\n${yellow}💡 【跨机无缝恢复教学】 (全系统平台智能适配版)：${plain}"
                        echo -e "--------------------------------------------------------"
                        echo -e "${cyan}👉 方案 A：使用图形化 SSH 软件 (如 FinalShell / Termius)${plain}"
                        echo -e "  1. 右键下载 /root/Velox_Assets_Backup.tar.gz 到电脑桌面。"
                        echo -e "  2. 登录【新机器】，直接将该包拖拽上传到新机器的 /root 目录下。\n"
                        
                        echo -e "${cyan}👉 方案 B：使用纯命令行工具 (CMD / PowerShell / Mac终端)${plain}"
                        echo -e "  📥 【第一步：下载到本地电脑】打开本地新终端，复制执行 (请修改旧IP)："
                        echo -e "   - [Windows 用户]: scp -P $SSH_PORT root@旧VPS的IP:/root/Velox_Assets_Backup.tar.gz D:/"
                        echo -e "   - [Mac/Linux 用户]: scp -P $SSH_PORT root@旧VPS的IP:/root/Velox_Assets_Backup.tar.gz ~/Desktop/"
                        echo -e ""
                        echo -e "  📤 【第二步：上传至新机器】(请修改新IP及端口)："
                        echo -e "   - [Windows 用户]: scp -P 22 D:/Velox_Assets_Backup.tar.gz root@新VPS的IP:/root/"
                        echo -e "   - [Mac/Linux 用户]: scp -P 22 ~/Desktop/Velox_Assets_Backup.tar.gz root@新VPS的IP:/root/"
                        echo -e ""

                        echo -e "${purple}🔥 【第三步：新机器终极恢复长指令】 (在新 VPS 终端执行)：${plain}"
                        echo -e "  ${cyan}cd / && tar -xzpPf /root/Velox_Assets_Backup.tar.gz && crontab /root/crontab_backup.txt 2>/dev/null; systemctl restart nginx vx-core sing-box xray x-ui cloudflared velox-argo 2>/dev/null; echo -e \"\\n✅ 资产覆盖恢复成功！节点、证书与 TG 防线已满血复活！\"${plain}"
                    else
                        echo -e "\n${red}❌ 未提取到任何资产，打包已取消。${plain}"
                    fi
                    ;;
                2)
                    echo -e "\n${blue}--- 🤝 组建星际舰队：打通免密互信 ---${plain}"
                    echo -e "💡 原理：本机将生成 Velox 专属独立密钥，并塞入目标机器。不影响原有的 SSH 配置！"
                    
                    if [ ! -f ~/.ssh/velox_fleet_rsa ]; then
                        echo -e "${yellow}正在为母舰生成专属指挥官兵符 (velox_fleet_rsa)...${plain}"
                        ssh-keygen -t rsa -b 4096 -N "" -f ~/.ssh/velox_fleet_rsa >/dev/null 2>&1
                    fi
                    
                    read -p "👉 请输入目标僚机 IP 地址: " target_ip
                    if [ -n "$target_ip" ]; then
                        read -p "👉 请输入目标机器 SSH 端口 (默认 22): " target_port
                        [ -z "$target_port" ] && target_port=22
                        
                        echo -e "\n${cyan}即将连接目标机器，如提示 (yes/no) 请输入 yes，随后输入目标机器 root 密码！${plain}"
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
                        awk -F: '{print " - 🟢 IP: "$1" (端口: "$2")"}' /root/.velox_fleet_nodes.txt
                        echo -e "${cyan}--------------------------------------------------------${plain}"
                        echo -e "💡 你可以输入类似 ${yellow}apt update -y${plain} 或者 ${yellow}reboot${plain}"
                        read -p "👉 请输入要对所有僚机下达的 Linux 指令: " fleet_cmd
                        
                        if [ -n "$fleet_cmd" ]; then
                            echo -e "\n${purple}📡 正在向全频段广播指令...${plain}"
                            for node in $(cat /root/.velox_fleet_nodes.txt); do
                                ip=$(echo "$node" | cut -d: -f1)
                                port=$(echo "$node" | cut -d: -f2)
                                echo -e "\n${yellow}[执行节点 -> $ip] 的回传报告：${plain}"
                                ssh -i ~/.ssh/velox_fleet_rsa -o ConnectTimeout=10 -o StrictHostKeyChecking=no -p "$port" "root@$ip" "$fleet_cmd"
                            done
                            echo -e "\n${green}🎉 舰队指令群发完毕！${plain}"
                        fi
                    fi
                    ;;
                4)
                    echo -e "\n${blue}--- 🗑️ 解散舰队与痕迹清理 ---${plain}"
                    read -p "⚠️ 此操作将删除本机的群发名单及 Velox 专属兵符，确认解散？(y/n): " confirm_disband
                    if [[ "${confirm_disband,,}" == "y" ]]; then
                        rm -f /root/.velox_fleet_nodes.txt ~/.ssh/velox_fleet_rsa ~/.ssh/velox_fleet_rsa.pub
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

    24)
        clear
        echo -e "\n${blue}=== 🔍 VeloX 全域高维资产雷达与进程透视镜 ===${plain}"
        echo -e "${yellow}正在启动内核级深空雷达，强行爆破系统进程与高价值数据藏匿点...${plain}\n"

        # ----------------- 第一维度：端口雷达 -----------------
        echo -e "${cyan}📡 第一维度：内核级 Socket 端口监听表 (无法伪装)${plain}"
        echo -e "--------------------------------------------------------"
        # 利用 ss 底层命令，精准提取端口和进程名
        ss -tulnp | grep LISTEN | while read -r line; do
            port=$(echo "$line" | awk '{print $5}' | awk -F':' '{print $NF}')
            proc=$(echo "$line" | grep -oP 'users:\(\("\K[^"]+')
            [ -n "$proc" ] && printf "  🔌 监听端口: \033[1;36m%-6s\033[0m | 👾 活跃进程: \033[1;33m%s\033[0m\n" "$port" "$proc"
        done | sort -u -k4,4n
        
        # ----------------- 第二维度：守护进程透视 -----------------
        echo -e "\n${cyan}🧬 第二维度：第三方常驻服务 (已反向过滤 Ubuntu 底层冗余)${plain}"
        echo -e "--------------------------------------------------------"
        # 过滤掉常见系统自带组件，只保留用户自己装的服务
        IGNORE_SVCS="systemd|ssh|cron|dbus|getty|polkit|rsyslog|network|ufw|kmod|apparmor|user@|modprobe|resolv|auditd|multipath|unattended|rsync|logrotate"
        
        systemctl list-units --type=service --state=active --no-pager 2>/dev/null | awk '{print $1}' | grep '\.service' | grep -vE "$IGNORE_SVCS" | while read svc; do
            desc=$(systemctl show -p Description --value "$svc" 2>/dev/null)
            printf "  ⚙️ 系统服务: \033[1;32m%-20s\033[0m | 📝 战略描述: %s\n" "$svc" "$desc"
        done

        # ----------------- 第三维度：Docker 深潜 -----------------
        if command -v docker >/dev/null 2>&1; then
            echo -e "\n${cyan}🐳 第三维度：Docker 虚拟容器集群深潜雷达${plain}"
            echo -e "--------------------------------------------------------"
            if [ -n "$(docker ps -q 2>/dev/null)" ]; then
                docker ps --format "  📦 活跃容器: \033[1;33m{{.Names}}\033[0m\t| 💾 镜像源: {{.Image}}" | column -t -s $'\t'
            else
                echo -e "  ⚪ Docker 引擎在位，但当前未挂载任何活跃容器。"
            fi
        fi

        # ----------------- 第四维度：高价值体积目录 -----------------
        echo -e "\n${cyan}💽 第四维度：FHS 高价值数据藏匿点 (体积 Top 6 盘点)${plain}"
        echo -e "--------------------------------------------------------"
        # 扫描第三方软件最喜欢扎堆的路径
        du -sh /opt/* /var/www/* /usr/local/etc/* /root/* 2>/dev/null | sort -rh | head -n 6 | while read size path; do
            printf "  📁 实体路径: \033[1;33m%-30s\033[0m | ⚖️ 物理占用: \033[1;31m%s\033[0m\n" "$path" "$size"
        done

        echo -e "\n${green}🎉 矩阵扫描完毕！全域资产已完全曝光。${plain}"
        echo -e "💡 ${yellow}提示：现在您可以退出并进入 23 号容灾中心，对上述资产实施模块化精准抽离！${plain}"
        
        echo -e "\n${yellow}------------------------------------------${plain}"
        read -p "👉 按【回车键】返回主菜单..."
        ;;
        
       U|u)
            echo -e "\n${red}=======================================================${plain}"
            echo -e "${red}                ⚠️ 终极卸载与物理粉碎程序                ${plain}"
            echo -e "${red}=======================================================${plain}"
            echo -e "${yellow}💡 提示：此操作为【焦土化卸载】，将彻底拔除 Velox 面板、底层监控及所有定时任务。${plain}"
            echo -e "${red}⚠️  核平警告：您的代理核心(Sing-box/Xray)、穿透隧道(Argo)以及 WARP 将被连根拔起，物理蒸发！${plain}\n"
            
            read -p "👉 确定要彻底卸载本面板并【焦土化抹除】监控数据吗？(y/n): " confirm_uninstall
            if [[ "${confirm_uninstall,,}" == "y" ]]; then
                echo -e "\n${cyan}🚀 正在启动全功率焦土卸载引擎...${plain}"

                # 1. 拆除核心面板与所有关联报警组件
                echo -n "1. 正在清理面板本体、备份包裹与所有监控/报警脚本... "
                rm -f /usr/local/bin/velox /root/velox.sh 2>/dev/null
                rm -f /root/Velox_Assets_Backup.tar.gz /root/crontab_backup.txt 2>/dev/null
                rm -f /usr/local/bin/ssh_tg_alert.sh /usr/local/bin/tg_boot_alert.sh
                rm -f /usr/local/bin/velox_pulse_alert.sh /usr/local/bin/velox_watchdog.sh /tmp/*_dead.flag
                sed -i '/ssh_tg_alert.sh/d' /etc/profile /etc/bash.bashrc
                systemctl disable --now tg_boot_alert.service >/dev/null 2>&1
                rm -f /etc/systemd/system/tg_boot_alert.service
                systemctl daemon-reload 
                echo -e "[${green}已彻底抹除${plain}]"

                # 1.5 拆除全局 TG 凭证与血洗所有定时任务
                echo -n "1.5 正在清洗全局 TG 凭证与所有相关定时任务... "
                rm -f /etc/velox_tg.conf /usr/local/bin/velox_traffic_alert.sh
                crontab -l 2>/dev/null | grep -vE "velox_traffic_alert.sh|velox_pulse_alert.sh|velox_watchdog.sh|warp|reboot" | crontab -
                echo -e "[${green}已彻底清洗${plain}]"

                # 1.6 彻底拔除 vnstat 底层监控与历史流量数据库 (🚀 智改：调用全域卸载装甲)
                echo -n "1.6 正在连根拔起底层流量监控引擎 (vnstat) 与历史账单... "
                systemctl disable --now vnstat >/dev/null 2>&1
                $PKG_REMOVE vnstat >/dev/null 2>&1
                rm -rf /var/lib/vnstat /etc/vnstat.conf
                echo -e "[${green}已彻底连根拔起${plain}]"

                # 2. 拆除 Bash 机枪塔
                echo -n "2. 正在物理粉碎 Bash 防爆破机枪塔与击毙日志... "
                systemctl disable --now velox-defender >/dev/null 2>&1
                rm -f /usr/local/bin/velox-defender.sh /etc/systemd/system/velox-defender.service
                rm -f /tmp/velox_ip_counts.txt /var/log/velox-defender.log
                systemctl daemon-reload
                echo -e "[${green}已彻底抹除${plain}]"

                # 3. 销毁星际舰队兵符
                echo -n "3. 正在销毁星际舰队跨机互信兵符与点名册... "
                rm -f /root/.velox_fleet_nodes.txt ~/.ssh/velox_fleet_rsa ~/.ssh/velox_fleet_rsa.pub
                echo -e "[${green}已彻底抹除${plain}]"

                # 4. 恢复网络底层默认参数 (🚀 智改：抹除独立模块配置，防遗漏)
                echo -n "4. 正在抹除底层网络调优 (TCP/UDP/BBR) 并恢复出厂状态... "
                rm -f /etc/sysctl.d/99-velox-network.conf /etc/sysctl.d/99-velox-bbr.conf /etc/modules-load.d/velox-bbr.conf
                # 顺手打扫一下可能存在的旧版本残留
                sed -i '/rmem_max/d; /wmem_max/d; /tcp_rmem/d; /tcp_wmem/d; /udp_rmem_min/d; /udp_wmem_min/d; /default_qdisc/d; /tcp_congestion_control/d' /etc/sysctl.conf
                sysctl -w net.ipv4.tcp_congestion_control=cubic >/dev/null 2>&1
                sysctl --system > /dev/null 2>&1
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
                sed -i "s/127.0.0.1.*/127.0.0.1 localhost/g" /etc/hosts
                echo -e "[${green}已恢复为 localhost${plain}]"

                # 7. Fail2Ban 强拆询问 (🚀 智改：调用全域卸载装甲)
                if command -v fail2ban-client >/dev/null 2>&1; then
                    echo -e "\n${yellow}⚠️ 检测到系统中安装了 Fail2Ban 工业级防御装甲。${plain}"
                    read -p "👉 是否一并【彻底强拆】Fail2Ban？(y/n): " remove_f2b
                    if [[ "${remove_f2b,,}" == "y" ]]; then
                        echo -n "正在全网追剿 Fail2Ban 及其依赖残留... "
                        systemctl disable --now fail2ban >/dev/null 2>&1
                        $PKG_REMOVE fail2ban >/dev/null 2>&1
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
      0)   echo -e "\n${green}祝 Velox 折腾愉快！${plain}\n"; exit ;;
        *) echo -e "\n${red}❌ 输入错误，请重新输入！${plain}"; sleep 1 ;;
    esac
    
    # 🚀 智改：彻底修复“双重回车”的恶心卡顿 Bug！
    # 只有 1 到 6 这几个基础信息查询命令，才需要在此处暂停。其他模块均已自带防闪退雷达。
    if [[ "$choice" =~ ^[1-6]$ ]]; then
        echo -e "\n${cyan}按回车键继续...${plain}"; read
    fi
done
EOF

chmod +x /usr/local/bin/velox
echo -e "\033[1;32m✅ Velox V5.2 (全域兼容满血终极版) 部署完毕！请输入 velox 欣赏！\033[0m"
velox
