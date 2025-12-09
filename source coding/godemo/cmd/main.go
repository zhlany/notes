package main

import (
	"fmt"
	"godemo/internal/constants"

	"godemo/internal/config"
	"godemo/internal/logger"
	"godemo/internal/runner"
	"godemo/internal/sshc"
	"godemo/pkg/utils"
)

func main() {
	cfg, err := config.Load(constants.ConfigFile)
	if err != nil {
		panic(err)
	}

	manager := sshc.NewManager()

	for name, c := range cfg.SSH {
		cli := sshc.NewSSHClient(c.Host, c.Port, c.User, c.Password)
		manager.Add(name, cli)
	}

	// 执行命令
	cmd := "uname -a"
	logger.Logger.Println("Executing:", cmd)

	results := runner.MultiHostRun(manager, cmd)

	// 转换为 JSON 输出
	fmt.Println(utils.ToJSON(results))
}
