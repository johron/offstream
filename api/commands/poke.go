package commands

import (
	"api/actions"
	"api/util"
	"net/http"

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

	err, stream := actions.GetUpdates(req.Stream)
	if err != nil && stream != nil {
		c.JSON(http.StatusOK, gin.H{"message": "server needs update"})
		return
	}

	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}

	if stream == nil {
		c.JSON(http.StatusOK, gin.H{"message": "stream is up to date"})
		return
	}

	c.JSON(http.StatusOK, gin.H{"message": "client needs update", "stream": stream})
	return
}
