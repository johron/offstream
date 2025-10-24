package util

import (
	"fmt"
	"os"

	"github.com/go-git/go-git/v5"
	"github.com/go-git/go-git/v5/config"
)

func GitInit() error {
	err := os.MkdirAll("stream/main/", os.ModePerm)
	if err != nil {
		return err
	}

	_, err = git.PlainInit("stream/main", true)
	if err != nil {
		return err
	}
	repo, err := git.PlainOpen("stream/main")
	if err != nil {
		return err
	}
	err = repo.CreateBranch(&config.Branch{
		Name: "master",
	})
	if err != nil {
		return err
	}

	text := "*.json merge=jsonmerge\n"
	err = os.WriteFile("stream/main/.gitattributes", []byte(text), 0644)
	if err != nil {
		return err
	}

	text = "[merge \"jsonmerge\"]\nname = JSON merge driver using jsonmerge\ndriver = python script/merge_json.py %0 %A %B %A\n"
	// Append the text to .git/config
	f, err := os.OpenFile("stream/main/.git/config", os.O_APPEND|os.O_WRONLY, 0644)
	if err != nil {
		return err
	}
	defer func(f *os.File) {
		err := f.Close()
		if err != nil {
			fmt.Println("Error closing file:", err)
		}
	}(f)
	_, err = f.WriteString(text)

	_, err = git.PlainInit("stream/write", false)
	repo, err = git.PlainOpen("stream/write")
	if err != nil {
		return err
	}

	_, err = repo.CreateRemote(&config.RemoteConfig{
		Name: "origin",
		URLs: []string{"stream/main"},
	})
	if err != nil {
		return err
	}

	err = repo.CreateBranch(&config.Branch{
		Name:   "master",
		Remote: "origin",
		Merge:  "refs/heads/master",
	})
	if err != nil {
		return err
	}

	return err
}

func GitCommitAll() error {
	fmt.Println("1")

	gitRepo, err := git.PlainOpen("stream/write")
	if err != nil {
		return err
	}

	fmt.Println("2")

	w, err := gitRepo.Worktree()
	if err != nil {
		return err
	}

	fmt.Println("3")

	_, err = w.Add(".")
	if err != nil {
		return err
	}

	fmt.Println("4")

	_, err = w.Commit("Auto-commit changes", &git.CommitOptions{})
	if err != nil {
		return err
	}

	fmt.Println("5")

	// My problem here is: command error on refs/heads/master: branch is currently checked out

	err = gitRepo.Push(&git.PushOptions{})
	if err != nil {
		return err
	}

	fmt.Println("6")

	return nil
}
