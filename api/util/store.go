package util

import (
	"os"

	"github.com/goccy/go-json"
)

func EnsureDataDir() error {
	err := os.MkdirAll("workspace/users", os.ModePerm)
	if err != nil {
		return err
	}
	return nil
}

func WriteUserFile(username string, obj interface{}) error {
	dataDirErr := EnsureDataDir()
	if dataDirErr != nil {
		return dataDirErr
	}

	content, marshallErr := json.MarshalIndent(obj, "", "  ")
	if marshallErr != nil {
		return marshallErr
	}

	err := os.WriteFile("workspace/users/"+username+".json", content, 0644)
	if err != nil {
		return err
	}

	return nil
}

func ReadUserFile(username string) (error, *User) {
	dataDirErr := EnsureDataDir()
	if dataDirErr != nil {
		return dataDirErr, nil
	}

	content, err := os.ReadFile("workspace/users/" + username + ".json")
	if err != nil {
		return err, nil
	}

	var obj User
	unmarshallErr := json.Unmarshal(content, &obj)
	if unmarshallErr != nil {
		return unmarshallErr, nil
	}

	return nil, &obj
}

func ReadAllUserFiles() (error, []User) {
	dataDirErr := EnsureDataDir()
	if dataDirErr != nil {
		return dataDirErr, nil
	}

	files, err := os.ReadDir("workspace/users")
	if err != nil {
		return err, nil
	}

	var objs []User
	for _, file := range files {
		if file.IsDir() {
			continue
		}

		content, readErr := os.ReadFile("workspace/users/" + file.Name())
		if readErr != nil {
			return readErr, nil
		}

		var obj User
		unmarshallErr := json.Unmarshal(content, &obj)
		if unmarshallErr != nil {
			return unmarshallErr, nil
		}

		objs = append(objs, obj)
	}

	return nil, objs
}
