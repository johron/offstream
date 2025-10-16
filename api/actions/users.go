package actions

import (
	"api/util"
	"fmt"
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
		Playlists:     []util.Playlist{},
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
