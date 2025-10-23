package commands

import (
	"api/actions"
	"api/constants"
	"api/util"
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

	stream := actions.GetStream()
	if stream.Success {
		c.JSON(http.StatusInternalServerError, gin.H{"error": "stream already initialized"})
		return
	}

	if req.Version != constants.VERSION {
		c.JSON(http.StatusBadRequest, gin.H{"error": "version mismatch"})
		return
	}

	result := actions.InitStream(req.Version, req.Token)
	if !result.Success {
		c.JSON(http.StatusInternalServerError, gin.H{"error": result.Message})
		return
	}

	err := util.GitInit()
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": "failed to initialize git repository"})
		return
	}

	c.JSON(http.StatusOK, gin.H{"message": "stream initialized successfully"})
}
