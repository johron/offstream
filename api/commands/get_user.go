package commands

import (
	"api/actions"
	"net/http"

	"github.com/gin-gonic/gin"
)

type GetPlaylistsCommand struct{}

type GetPlaylistsRequest struct {
	Username string `form:"username" binding:"required"`
}

func init() {
	RegisterCommand(&GetPlaylistsCommand{})
}

func (cmd *GetPlaylistsCommand) Register(router *gin.Engine) {
	router.GET("/getplaylists", cmd.Handle)
}

func (cmd *GetPlaylistsCommand) Handle(c *gin.Context) {
	var req GetPlaylistsRequest
	if err := c.ShouldBindQuery(&req); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": "username query param required"})
		return
	}

	user := actions.GetUser(req.Username)
	if user == nil {
		c.JSON(http.StatusNotFound, gin.H{"error": "user not found"})
		return
	}

	playlists := user.Playlists

	c.JSON(http.StatusOK, gin.H{
		"playlists": playlists,
	})
}
