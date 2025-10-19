package actions

import (
	"api/util"
	"fmt"
	"time"
)

func AddUser(username string, password string) util.ActionResponse {
	users := GetUsers()

	for _, user := range users {
		if user.Username == username {
			return util.ActionResponse{
				Success: false,
				Message: "user already exists",
			}
		}
	}

	user := util.User{
		Username:      username,
		Password:      password,
		LastUpdate:    time.Now(),
		Configuration: util.Configuration{},
	}
	users = append(users, user)

	fmt.Println(users)

	err := util.WriteUserFile(username, user)
	if err != nil {
		return util.ActionResponse{
			Success: false,
			Message: "failed to write user file",
		}
	}

	return util.ActionResponse{
		Success: true,
		Message: "user added successfully",
	}
}

func GetUsers() []util.User {
	err, users := util.ReadAllUserFiles()
	if err != nil {
		return []util.User{}
	}

	return users
}

func GetUser(username string) *util.User {
	err, user := util.ReadUserFile(username)
	if err != nil {
		return nil
	}

	return user
}

func GetPlaylists(username string) []util.Playlist {
	err, playlists := util.ReadAllPlaylistFiles(username)
	if err != nil {
		return []util.Playlist{}
	}

	return playlists
}

func GetUpdatesSince(username string, since time.Time) util.ActionResponse {
	user := GetUser(username)
	if user == nil {
		return util.ActionResponse{
			Success: false,
			Message: "user not found",
		}
	}

	var updatedPlaylists []util.Playlist
	playlists := GetPlaylists(username)
	for _, playlist := range playlists {
		if playlist.LastUpdate.After(since) {
			updatedPlaylists = append(updatedPlaylists, playlist)
		}
	}

	userUpdated := false
	if user.LastUpdate.After(since) {
		userUpdated = true
	}

	if !userUpdated && len(updatedPlaylists) == 0 {
		return util.ActionResponse{
			Success: true,
			Message: "no updates",
		}
	}

	var poke util.Data
	if userUpdated {
		poke.User = user
	}
	if len(updatedPlaylists) > 0 {
		poke.Playlists = updatedPlaylists
	}

	return util.ActionResponse{
		Success: true,
		Message: "updates retrieved successfully",
		Return:  poke,
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

	workspaceErr := util.WriteWorkspaceFile(updates.Workspace)
	if workspaceErr != nil {
		return util.ActionResponse{
			Success: false,
			Message: "failed to write workspace file",
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
