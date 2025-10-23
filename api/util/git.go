package util

import (
	"github.com/go-git/go-git/v5"
)

func GitInit() error {
	_, err := git.PlainInit("stream", false)
	return err
}

func GitCommitAll() error {
	gitRepo, err := git.PlainOpen("stream")
	if err != nil {
		return err
	}

	w, err := gitRepo.Worktree()
	if err != nil {
		return err
	}

	_, err = w.Add(".")
	if err != nil {
		return err
	}

	_, err = w.Commit("Auto-commit changes", &git.CommitOptions{})
	if err != nil {
		return err
	}

	return nil
}
