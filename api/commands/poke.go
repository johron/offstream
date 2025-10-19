package commands

import (
	"api/actions"
	"net/http"
	"time"

	"github.com/gin-gonic/gin"
)

type PokeCommand struct{}

type PokeRequest struct {
	Username   string `form:"username" binding:"required"`
	LastUpdate int64  `form:"last_update" binding:"required"`
}

func init() {
	RegisterCommand(&PokeCommand{})
}

func (cmd *PokeCommand) Register(router *gin.Engine) {
	router.GET("/poke", cmd.Handle)
}

func (cmd *PokeCommand) Handle(c *gin.Context) {
	var req PokeRequest
	if err := c.ShouldBindQuery(&req); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": "username query param required"})
		return
	}

	user := actions.GetUser(req.Username)
	if user == nil {
		c.JSON(http.StatusNotFound, gin.H{"error": "user not found"})
		return
	}

	data := actions.GetUpdatesSince(user.Username, time.Unix(req.LastUpdate, 0))
	c.JSON(http.StatusOK, gin.H{
		"data":      data.Return,
		"timestamp": time.Now().Unix(),
	})
}
