package commands

import "github.com/gin-gonic/gin"

type Command interface {
	Register(router *gin.Engine)
}

var commands []Command

func RegisterCommand(cmd Command) {
	commands = append(commands, cmd)
}

func RegisterAll(router *gin.Engine) {
	for _, cmd := range commands {
		cmd.Register(router)
	}
}
