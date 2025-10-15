package actions

import (
	"api/util"
	"fmt"

	"github.com/pelletier/go-toml/v2"
)

var users []util.User

func AddUser(username string, password string) util.ActionResponse {
	for _, user := range users {
		if user.Username == username {
			return util.ActionResponse{
				Success: false,
				Message: "user already exists",
			}
		}
	}

	users = append(users, util.User{
		Username: username,
		Password: password,
	})

	fmt.Println(users)

	data, err := toml.Marshal(users)
	if err != nil {
		return util.ActionResponse{
			Success: false,
			Message: "failed to marshal user data",
		}
	}

	err = util.WriteUserFile(username, data)
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
