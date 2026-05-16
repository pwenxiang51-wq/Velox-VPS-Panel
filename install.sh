#!/bin/bash
# Velox Panel V6.0 智能安装母舰 (Golang Web版)

cyan='\033[1;36m'
green='\033[1;32m'
plain='\033[0m'

echo -e "${cyan}🚀 正在启动 Velox Web 面板部署程序...${plain}"

# 1. 抓取 GitHub 最新编译成品
echo -e "${green}⬇️ 正在拉取底层防弹装甲...${plain}"
LATEST_URL=$(curl -s https://api.github.com/repos/pwenxiang51-wq/Velox-VPS-Panel/releases/latest | grep "browser_download_url" | grep "velox-panel" | cut -d '"' -f 4)
wget -qO /usr/local/bin/velox-panel "$LATEST_URL"
chmod +x /usr/local/bin/velox-panel

# 2. 注入 Systemd 守护
echo -e "${green}🛡️ 正在注入系统守护进程...${plain}"
cat << EOF > /etc/systemd/system/velox-panel.service
[Unit]
Description=Velox Web Panel Daemon
After=network.target

[Service]
Type=simple
ExecStart=/usr/local/bin/velox-panel
Restart=always

[Install]
WantedBy=multi-user.target
EOF

systemctl daemon-reload
systemctl enable --now velox-panel

echo -e "\n${green}🎉 部署完毕！Velox 舰载 AI 已接管主机。${plain}"
echo -e "👉 请访问: ${cyan}http://$(curl -s4m3 icanhazip.com):8080${plain}"