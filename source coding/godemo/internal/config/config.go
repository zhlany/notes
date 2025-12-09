package config

import (
	"log"

	"gopkg.in/ini.v1"
)

type SSHConfig struct {
	Host     string
	Port     int
	User     string
	Password string
}

type GlobalConfig struct {
	LogLevel string
}

type AppConfig struct {
	SSH    map[string]SSHConfig
	Global GlobalConfig
}

func Load(path string) (*AppConfig, error) {
	cfg, err := ini.Load(path)
	if err != nil {
		return nil, err
	}

	app := &AppConfig{
		SSH: make(map[string]SSHConfig),
	}

	for _, sec := range cfg.Sections() {
		if sec.Name() == "DEFAULT" || sec.Name() == "global" {
			app.Global.LogLevel = sec.Key("log_level").MustString("info")
			continue
		}

		app.SSH[sec.Name()] = SSHConfig{
			Host:     sec.Key("host").String(),
			Port:     sec.Key("port").MustInt(22),
			User:     sec.Key("user").String(),
			Password: sec.Key("password").String(),
		}
	}

	log.Printf("Loaded %d SSH nodes", len(app.SSH))
	return app, nil
}
