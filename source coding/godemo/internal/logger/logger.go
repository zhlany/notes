package logger

import (
	"log"
	"os"
)

var Logger = log.New(os.Stdout, "[SSH-TOOL] ", log.LstdFlags)
