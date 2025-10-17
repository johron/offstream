package commands

import (
	"net/http"

	"github.com/gin-gonic/gin"

	"api/actions"
)

type NewPlaylistCommand struct{}

type NewPlaylistRequest struct {
	Username string `json:"username" binding:"required"`
	Password string `json:"password" binding:"required"`
	Name     string `json:"name" binding:"required"`
}

func init() {
	RegisterCommand(&NewPlaylistCommand{})
}

func (cmd *NewPlaylistCommand) Register(router *gin.Engine) {
	router.POST("/newplaylist", cmd.Handle)
}

func (cmd *NewPlaylistCommand) Handle(c *gin.Context) {
	var req NewPlaylistRequest

	if err := c.ShouldBindJSON(&req); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}

	if actions.GetUser(req.Username) == nil {
		c.JSON(http.StatusNotFound, gin.H{"error": "user not found"})
		return
	}

	if req.Password != actions.GetUser(req.Username).Password {
		c.JSON(http.StatusUnauthorized, gin.H{"error": "invalid auth key"})
		return
	}

	user := actions.GetUser(req.Username)
	playlist := actions.NewPlaylist(user, req.Name)

	if playlist == nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": "could not create playlist"})
		return
	}

	c.JSON(http.StatusOK, gin.H{
		"message": "playlist created",
	})
}
