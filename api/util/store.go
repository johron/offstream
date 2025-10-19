package util

import (
	"os"

	"github.com/goccy/go-json"
)

const baseDir = "workspace/"

func EnsureWorkspace() error {
	err := os.MkdirAll(baseDir, os.ModePerm)
	if err != nil {
		return err
	}
	return nil
}

func EnsureDataDir() error {
	workspaceErr := EnsureWorkspace()
	if workspaceErr != nil {
		return workspaceErr
	}

	err := os.MkdirAll(baseDir+"users", os.ModePerm)
	if err != nil {
		return err
	}
	return nil
}

func EnsureUserDir(username string) error {
	workspaceErr := EnsureWorkspace()
	if workspaceErr != nil {
		return workspaceErr
	}

	err := os.MkdirAll(baseDir+"users/"+username, os.ModePerm)
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

	userDirErr := EnsureUserDir(username)
	if userDirErr != nil {
		return userDirErr
	}

	content, marshallErr := json.MarshalIndent(obj, "", "  ")
	if marshallErr != nil {
		return marshallErr
	}

	err := os.WriteFile(baseDir+"users/"+username+"/user.json", content, 0644)
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

	content, err := os.ReadFile(baseDir + "users/" + username + "/user.json")
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

	files, err := os.ReadDir(baseDir + "users")
	if err != nil {
		return err, nil
	}

	var objs []User
	for _, file := range files {
		if !file.IsDir() {
			continue
		}

		content, readErr := os.ReadFile(baseDir + "users/" + file.Name() + "/user.json")
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

func EnsurePlaylistDir(username string) error {
	err := os.MkdirAll(baseDir+"users/"+username+"/playlists", os.ModePerm)
	if err != nil {
		return err
	}

	return nil
}

func WritePlaylistFile(username string, playlistName string, obj interface{}) error {
	playlistDirErr := EnsurePlaylistDir(username)
	if playlistDirErr != nil {
		return playlistDirErr
	}

	content, marshallErr := json.MarshalIndent(obj, "", "  ")
	if marshallErr != nil {
		return marshallErr
	}

	err := os.WriteFile(baseDir+"users/"+username+"/playlists/"+playlistName+".json", content, 0644)
	if err != nil {
		return err
	}

	return nil
}

func ReadPlaylistFile(username string, playlistName string) (error, *Playlist) {
	playlistDirErr := EnsurePlaylistDir(username)
	if playlistDirErr != nil {
		return playlistDirErr, nil
	}

	content, err := os.ReadFile(baseDir + "users/" + username + "/playlists/" + playlistName + ".json")
	if err != nil {
		return err, nil
	}

	var obj Playlist
	unmarshallErr := json.Unmarshal(content, &obj)
	if unmarshallErr != nil {
		return unmarshallErr, nil
	}

	return nil, &obj
}

func ReadAllPlaylistFiles(username string) (error, []Playlist) {
	playlistDirErr := EnsurePlaylistDir(username)
	if playlistDirErr != nil {
		return playlistDirErr, nil
	}

	files, err := os.ReadDir(baseDir + "users/" + username + "/playlists")
	if err != nil {
		return err, nil
	}

	var objs []Playlist
	for _, file := range files {
		if file.IsDir() {
			continue
		}

		content, readErr := os.ReadFile(baseDir + "users/" + username + "/playlists/" + file.Name())
		if readErr != nil {
			return readErr, nil
		}

		var obj Playlist
		unmarshallErr := json.Unmarshal(content, &obj)
		if unmarshallErr != nil {
			return unmarshallErr, nil
		}

		objs = append(objs, obj)
	}

	return nil, objs
}

func WriteWorkspaceFile(obj interface{}) error {
	workspaceErr := EnsureWorkspace()
	if workspaceErr != nil {
		return workspaceErr
	}

	content, marshallErr := json.MarshalIndent(obj, "", "  ")
	if marshallErr != nil {
		return marshallErr
	}

	err := os.WriteFile(baseDir+"workspace.json", content, 0644)
	if err != nil {
		return err
	}

	return nil
}

func ReadWorkspaceFile() (error, *Workspace) {
	workspaceErr := EnsureWorkspace()
	if workspaceErr != nil {
		return workspaceErr, nil
	}

	content, err := os.ReadFile(baseDir + "workspace.json")
	if err != nil {
		return err, nil
	}

	var obj Workspace
	unmarshallErr := json.Unmarshal(content, &obj)
	if unmarshallErr != nil {
		return unmarshallErr, nil
	}

	return nil, &obj
}
