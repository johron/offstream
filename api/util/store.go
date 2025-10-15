package util

import (
	"os"
)

func EnsureDataDir() error {
	err := os.MkdirAll("workspace/users", os.ModePerm)
	if err != nil {
		return err
	}
	return nil
}

func WriteUserFile(username string, content []byte) error {
	err := EnsureDataDir()
	if err != nil {
		return err
	}

	err = os.WriteFile("workspace/users/"+username+".toml", content, 0644)
	if err != nil {
		return err
	}
	return nil
}
