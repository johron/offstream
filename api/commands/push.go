package commands

import (
	"api/actions"
	"api/util"
	"net/http"

	"github.com/gin-gonic/gin"
)

type PushCommand struct{}

type PushRequest struct {
	Username string    `json:"username" binding:"required"`
	Password string    `json:"password" binding:"required"`
	Updates  util.Data `json:"updates" binding:"required"`
}

func init() {
	RegisterCommand(&PushCommand{})
}

func (cmd *PushCommand) Register(router *gin.Engine) {
	router.POST("/push", cmd.Handle)
}

func (cmd *PushCommand) Handle(c *gin.Context) {
	var req PushRequest

	if err := c.ShouldBindJSON(&req); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}

	user := actions.GetUser(req.Username)
	if user == nil {
		c.JSON(http.StatusNotFound, gin.H{"error": "user not found"})
		return
	}

	if req.Password != user.Password {
		c.JSON(http.StatusUnauthorized, gin.H{"error": "incorrect password"})
		return
	}

	result := actions.ApplyUpdates(user.Username, req.Updates)
	if !result.Success {
		c.JSON(http.StatusInternalServerError, gin.H{"error": result.Message})
		return
	}

	c.JSON(http.StatusOK, gin.H{"message": "updates applied successfully"})
}
