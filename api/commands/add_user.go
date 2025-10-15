package commands

import (
	"net/http"

	"github.com/gin-gonic/gin"

	"api/actions"
)

type AddUserCommand struct{}

type AddUserRequest struct {
	AuthKey  string `json:"authKey" binding:"required"`
	Username string `json:"username" binding:"required"`
	Password string `json:"password" binding:"required"`
}

func init() {
	RegisterCommand(&AddUserCommand{})
}

func (cmd *AddUserCommand) Register(router *gin.Engine) {
	router.POST("/adduser", cmd.Handle)
}

func (cmd *AddUserCommand) Handle(c *gin.Context) {
	var req AddUserRequest

	if err := c.ShouldBindJSON(&req); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}

	if req.AuthKey != "SECRET123" {
		c.JSON(http.StatusUnauthorized, gin.H{"error": "invalid auth key"})
		return
	}

	user := actions.AddUser(req.Username, req.Password)
	if user.Success {
		c.JSON(http.StatusOK, gin.H{
			"message":  user.Message,
			"username": req.Username,
		})
	} else {
		c.JSON(http.StatusInternalServerError, gin.H{"error": user.Message})
	}
}
