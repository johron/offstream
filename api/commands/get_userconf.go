package commands

import (
	"api/actions"
	"net/http"

	"github.com/gin-gonic/gin"
)

type GetUserConfCommand struct{}

type GetUserConfRequest struct {
	Username string `form:"username" binding:"required"`
}

func init() {
	RegisterCommand(&GetUserConfCommand{})
}

func (cmd *GetUserConfCommand) Register(router *gin.Engine) {
	router.GET("/getuserconf", cmd.Handle)
}

func (cmd *GetUserConfCommand) Handle(c *gin.Context) {
	var req GetUserConfRequest
	if err := c.ShouldBindQuery(&req); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": "username query param required"})
		return
	}

	user := actions.GetUser(req.Username)
	if user == nil {
		c.JSON(http.StatusNotFound, gin.H{"error": "user not found"})
		return
	}

	configuration := user.Configuration

	c.JSON(http.StatusOK, gin.H{
		"configuration": configuration,
	})
}
