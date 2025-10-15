package actions

import (
	"api/util"
	"fmt"
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

	user := util.User{
		Username: username,
		Password: password,
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

}
