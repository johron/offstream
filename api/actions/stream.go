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

func ApplyUpdates(username string, updates util.Data) util.ActionResponse {
	user := GetUser(username)
	if user == nil {
		return util.ActionResponse{
			Success: false,
			Message: "user not found",
		}
	}

	streamErr := util.WriteStreamFile(updates.Stream)
	if streamErr != nil {
		return util.ActionResponse{
			Success: false,
			Message: "failed to write stream file",
		}
	}

	userErr := util.WriteUserFile(username, *user)
	if userErr != nil {
		return util.ActionResponse{
			Success: false,
			Message: "failed to write user file",
		}
	}

	for _, playlist := range updates.Playlists {
		err := util.WritePlaylistFile(username, playlist.Title, playlist)
		if err != nil {
			return util.ActionResponse{
				Success: false,
				Message: "failed to write playlist file",
			}
		}
	}

	return util.ActionResponse{
		Success: true,
		Message: "updates applied successfully",
	}
}
