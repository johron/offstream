package commands

import (
	"api/actions"
	"api/util"
	"net/http"
	"time"

	"github.com/gin-gonic/gin"
)

type PokeCommand struct{}

type PokeRequest struct {
	Stream util.Stream `form:"stream" binding:"required"`
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

	data := actions.GetUpdates(req.Stream)
	c.JSON(http.StatusOK, gin.H{
		"data":      data.Return,
		"timestamp": time.Now().Unix(), // TODO: should this be here?
	})
}
