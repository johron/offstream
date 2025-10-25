package actions

import (
	"api/util"
	"fmt"
	"time"
)

func AddUser(username string, password string) error {
	stream, err := GetStream()
	if err != nil {
		return err
	}

	users := stream.Users

	for _, user := range users {
		if user.Username == username {
			return fmt.Errorf("user already exists")
		}
	}

	user := util.User{
		Username:      username,
		Password:      password,
		Configuration: util.Configuration{},
		Playlists:     []util.Playlist{},
	}
	users = append(users, user)

	stream.Users = users
	stream.LastUpdate = time.Now().Unix()

	writeErr := util.WriteStreamFile(*stream)
	if writeErr != nil {
		return fmt.Errorf("failed to write stream file: %v", writeErr)
	}

	return nil
}

func GetUsers() []util.User {
	err, stream := util.ReadStreamFile()
	if err != nil {
		return []util.User{}
	}

	return stream.Users
}

func GetUser(username string) *util.User {
	users := GetUsers()
	for _, user := range users {
		if user.Username == username {
			return &user
		}
	}

	return nil
}
