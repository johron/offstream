package actions

import (
	"api/util"
	"time"
)

func GetStream() util.ActionResponse {
	err, stream := util.ReadStreamFile()
	if err != nil {
		return util.ActionResponse{
			Success: false,
			Message: "failed to read stream",
		}
	}

	return util.ActionResponse{
		Success: true,
		Message: "stream retrieved successfully",
		Return:  stream,
	}
}

func InitStream(version string, token string) util.ActionResponse {
	stream := &util.Stream{
		Version:    version,
		Token:      token,
		LastUpdate: time.Now(),
	}

	streamErr := util.WriteStreamFile(stream)
	if streamErr != nil {
		return util.ActionResponse{
			Success: false,
			Message: "failed to initialize stream",
		}
	}

	return util.ActionResponse{
		Success: true,
		Message: "stream initialized successfully",
	}
}
