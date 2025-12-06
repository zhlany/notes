package main

import (
	"context"
	"fmt"

	"github.com/sashabaranov/go-openai"
	"gopkg.in/ini.v1"
)

type Config struct {
	APIKey  string `ini:"api_key"`
	BaseURL string `ini:"base_url"`
	Model   string `ini:"model"`
}

// loadConfig 加载配置，环境变量优先
func loadConfig(filename string) (*Config, error) {
	cfg := &Config{}
	iniFile, _ := ini.Load(filename)

	deepseekSection := iniFile.Section("deepseek")
	if err := deepseekSection.MapTo(cfg); err != nil {
		return nil, fmt.Errorf("映射配置到结构体出错: %v", err)
	}

	return cfg, nil
}

func main() {
	// 读取配置，环境变量优先级高于配置文件
	cfg, err := loadConfig("config.ini")
	if err != nil {
		fmt.Printf("加载配置出错: %v\n", err)
		return
	}

	// 创建客户端
	config := openai.DefaultConfig(cfg.APIKey)
	config.BaseURL = cfg.BaseURL
	client := openai.NewClientWithConfig(config)

	resp, err := client.CreateChatCompletion(
		context.Background(),
		openai.ChatCompletionRequest{
			Model: cfg.Model,
			Messages: []openai.ChatCompletionMessage{
				{Role: openai.ChatMessageRoleSystem, Content: "You are a helpful assistant"},
				{Role: openai.ChatMessageRoleUser, Content: "Hello"},
			},
			Stream: false,
		},
	)

	if err != nil {
		fmt.Printf("调用API时出错: %v\n", err)
		return
	}

	fmt.Println(resp.Choices[0].Message.Content)
}
