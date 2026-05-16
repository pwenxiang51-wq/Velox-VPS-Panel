package main

import (
	"embed"
	"io/fs"
	"net/http"
	"os/exec"
	"strings"

	"github.com/gin-gonic/gin"
)

// 极客魔法：物理吞噬前端目录
//go:embed frontend/*
var staticFS embed.FS

func main() {
	// 开启生产环境静默模式
	gin.SetMode(gin.ReleaseMode)
	r := gin.Default()

	// 挂载网页防线
	frontendFS, _ := fs.Sub(staticFS, "frontend")
	r.StaticFS("/ui", http.FS(frontendFS))
	
	// 访问根目录自动跳到面板
	r.GET("/", func(c *gin.Context) {
		c.Redirect(http.StatusFound, "/ui/")
	})

	// 部署底层 API 战术雷达
	api := r.Group("/api")
	{
		// 探针：获取 VPS 负载
		api.GET("/status", func(c *gin.Context) {
			out, _ := exec.Command("uptime").Output()
			c.JSON(200, gin.H{"data": strings.TrimSpace(string(out))})
		})

		// 绝杀：重启核心
		api.POST("/core/restart", func(c *gin.Context) {
			exec.Command("bash", "-c", "systemctl restart sing-box xray").Run()
			c.JSON(200, gin.H{"message": "✅ 绝杀完毕！系统底层的代理服务已满血复活！"})
		})
	}

	r.Run(":8080")
}