package commands

import (
	"api/actions"
	"api/constants"

	"net/http"

	"github.com/gin-gonic/gin"
)

type InitCommand struct{}

type InitRequest struct {
	Version string `json:"version" binding:"required"`
	Token   string `json:"token" binding:"required"`
}

func init() {
	RegisterCommand(&InitCommand{})
}

func (cmd *InitCommand) Register(router *gin.Engine) {
	router.POST("/init", cmd.Handle)
}

func (cmd *InitCommand) Handle(c *gin.Context) {
	var req InitRequest

	if err := c.ShouldBindJSON(&req); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}

	workspace := actions.GetWorkspace()
	if workspace.Success {
		c.JSON(http.StatusInternalServerError, gin.H{"error": "workspace already initialized"})
		return
	}

	if req.Version != constants.VERSION {
		c.JSON(http.StatusBadRequest, gin.H{"error": "version mismatch"})
		return
	}

	result := actions.InitWorkspace(req.Version, req.Token)
	if !result.Success {
		c.JSON(http.StatusInternalServerError, gin.H{"error": result.Message})
		return
	}

	c.JSON(http.StatusOK, gin.H{"message": "workspace initialized successfully"})
}
