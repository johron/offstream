package main

import (
	"net/http"

	"github.com/gin-gonic/gin"
)

type AddUserRequest struct {
	AuthKey  string `json:"authKey" binding:"required"`
	Username string `json:"username" binding:"required"`
	Password string `json:"password" binding:"required"`
}

func main() {
	r := gin.Default()

	err := r.SetTrustedProxies([]string{"127.0.0.1"})
	if err != nil {
		return
	}

	r.POST("/adduser", func(c *gin.Context) {
		var req AddUserRequest

		if err := c.ShouldBindJSON(&req); err != nil {
			c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
			return
		}

		if req.AuthKey != "SECRET123" {
			c.JSON(http.StatusUnauthorized, gin.H{"error": "invalid auth key"})
			return
		}

		c.JSON(http.StatusOK, gin.H{
			"message":  "user added successfully",
			"username": req.Username,
		})
	})

	err2 := r.Run(":8080")
	if err2 != nil {
		return
	}
}
