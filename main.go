package main

import (
	"embed"
	"io/fs"
	"net"
	"net/http"
	"os/exec"
	"strings"

	"github.com/gin-gonic/gin"
)

//go:embed frontend/*
var staticFS embed.FS

// 智能嗅探防线：判断是否为域名访问
func isDomain(host string) (bool, string) {
	// 修正：net.SplitHostPort 返回 host, port, error 三个值
	h, _, err := net.SplitHostPort(host)
	if err != nil {
		// 如果报错，说明传进来的 host 本身就不带端口（比如直接就是 IP 或域名）
		h = host
	}
	// 尝试解析为 IP，如果解析成功说明是纯 IP 访问，反之则是域名
	ip := net.ParseIP(h)
	if ip != nil {
		return false, h
	}
	return true, h
}

func main() {
	gin.SetMode(gin.ReleaseMode)
	r := gin.Default()

	frontendFS, _ := fs.Sub(staticFS, "frontend")
	r.StaticFS("/ui", http.FS(frontendFS))
	
	r.GET("/", func(c *gin.Context) {
		c.Redirect(http.StatusFound, "/ui/")
	})

	api := r.Group("/api")
	{
		// 1. 全域智能探针：吞噬老脚本所有运维与调优数据
		api.GET("/sysinfo", func(c *gin.Context) {
			osInfo, _ := exec.Command("bash", "-c", "cat /etc/os-release | grep PRETTY_NAME | cut -d'\"' -f2").Output()
			memInfo, _ := exec.Command("bash", "-c", "free -h | awk '/Mem:/ {print $3\" / \"$2}'").Output()
			diskInfo, _ := exec.Command("bash", "-c", "df -h / | awk '/\\// {print $3\" / \"$2}'").Output()
			bbrInfo, _ := exec.Command("bash", "-c", "sysctl net.ipv4.tcp_congestion_control | awk '{print $3}'").Output()
			proxyInfo, _ := exec.Command("bash", "-c", "systemctl is-active sing-box").Output()
			
			// 自动侦测域名访问状态
			isDom, currentHost := isDomain(c.Request.Host)
			domainStatus := "⚠️ 纯 IP 裸奔中"
			if isDom {
				domainStatus = "🟢 已成功绑定域名: " + currentHost
			}

			proxyStatus := strings.TrimSpace(string(proxyInfo))
			if proxyStatus != "active" {
				proxyStatus = "🔴 已停止 / 未安装"
			} else {
				proxyStatus = "🟢 满血运行中"
			}

			c.JSON(200, gin.H{
				"os":     strings.TrimSpace(string(osInfo)),
				"mem":    strings.TrimSpace(string(memInfo)),
				"disk":   strings.TrimSpace(string(diskInfo)),
				"bbr":    strings.TrimSpace(string(bbrInfo)),
				"proxy":  proxyStatus,
				"domain": domainStatus,
			})
		})

		// 2. 核心制裁路由：一键物理修复/重启代理
		api.POST("/core/restart", func(c *gin.Context) {
			exec.Command("bash", "-c", "systemctl restart sing-box xray").Run()
			c.JSON(200, gin.H{"message": "⚡ 核心节点已全线执行满血重启！"})
		})

		// 3. 焦土清理：一键强制释放系统物理内存
		api.POST("/core/clean", func(c *gin.Context) {
			exec.Command("bash", "-c", "sync; echo 3 > /proc/sys/vm/drop_caches").Run()
			c.JSON(200, gin.H{"message": "🧹 垃圾清理完毕，物理内存已满血复苏！"})
		})

		// 4. BBR 暴力内核调优开关
		api.POST("/network/bbr", func(c *gin.Context) {
			// 检测环境安全阻断
			virt, _ := exec.Command("systemd-detect-virt").Output()
			virtType := strings.TrimSpace(string(virt))
			if virtType == "lxc" || virtType == "openvz" {
				c.JSON(400, gin.H{"message": "❌ 致命拦截：容器架构共享宿主机内核，无权更改 BBR 参数！"})
				return
			}
			// 暴力注入 BBR+fq 黄金配置
			cmd := `sed -i '/net.core.default_qdisc/d' /etc/sysctl.conf; sed -i '/net.ipv4.tcp_congestion_control/d' /etc/sysctl.conf; echo 'net.core.default_qdisc=fq' >> /etc/sysctl.conf; echo 'net.ipv4.tcp_congestion_control=bbr' >> /etc/sysctl.conf; sysctl -p >/dev/null 2>&1`
			exec.Command("bash", "-c", cmd).Run()
			c.JSON(200, gin.H{"message": "🎉 降维打击成功！BBR + fq 暴力加速全线生效！"})
		})
	}

	r.Run(":8080")
}