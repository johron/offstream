package actions

import (
	"api/util"
	"encoding/json"
	"fmt"
	"time"
)

func UpdateUser(user *util.User) util.ActionResponse {
	user.LastUpdate = time.Now()

	err := util.WriteUserFile(user.Username, user)
	if err != nil {
		return util.ActionResponse{
			Success: false,
			Message: "failed to update user file",
		}
	}

	return util.ActionResponse{
		Success: true,
		Message: "user updated successfully",
	}
}

func updatePlaylist(username string, playlist *util.Playlist) util.ActionResponse {
	playlist.LastUpdate = time.Now()

	err := util.WritePlaylistFile(username, playlist.Title, *playlist)
	if err != nil {
		return util.ActionResponse{
			Success: false,
			Message: "failed to update playlist file",
		}
	}

	return util.ActionResponse{
		Success: true,
		Message: "playlist updated successfully",
	}
}

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

func NewPlaylist(user *util.User, playlistName string) *util.Playlist {
	if PlaylistExists(user.Username, playlistName) {
		return nil
	}

	playlist := util.Playlist{
		Title:      playlistName,
		Songs:      []util.Song{},
		Created:    time.Now(),
		LastUpdate: time.Now(),
	}

	err := util.WritePlaylistFile(user.Username, playlistName, playlist)
	if err != nil {
		return nil
	}

	return &playlist
}

func PlaylistExists(username string, playlistName string) bool {
	err, _ := util.ReadPlaylistFile(username, playlistName)
	if err != nil {
		return false
	}

	return true
}

func GetPlaylists(username string) []util.Playlist {
	err, playlists := util.ReadAllPlaylistFiles(username)
	if err != nil {
		return []util.Playlist{}
	}

	return playlists
}

func GetPlaylist(username string, playlistName string) *util.Playlist {
	err, playlist := util.ReadPlaylistFile(username, playlistName)
	if err != nil {
		return nil
	}

	return playlist
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

	var poke util.Poke
	if userUpdated {
		poke.User = user
	}
	if len(updatedPlaylists) > 0 {
		poke.Playlists = updatedPlaylists
	}

	content, err := json.Marshal(poke)
	if err != nil {
		return util.ActionResponse{
			Success: false,
			Message: "failed to marshal updates",
		}
	}

	return util.ActionResponse{
		Success: true,
		Message: "updates retrieved successfully",
		Return:  content,
	}
}
