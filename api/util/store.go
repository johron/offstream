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
