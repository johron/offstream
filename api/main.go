package main

import (
	"github.com/gin-gonic/gin"

	"api/commands"
)

func main() {
	r := gin.Default()

	if err := r.SetTrustedProxies([]string{"127.0.0.1"}); err != nil {
		return
	}

	commands.RegisterAll(r)

	if err := r.Run(":8080"); err != nil {
		return
	}
}
