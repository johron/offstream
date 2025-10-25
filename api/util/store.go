package util

import (
	"os"

	"github.com/goccy/go-json"
)

const baseDir = "stream/"

func EnsureStream() error {
	err := os.MkdirAll(baseDir, os.ModePerm)
	if err != nil {
		return err
	}
	return nil
}

func WriteStreamFile(stream Stream) error {
	streamErr := EnsureStream()
	if streamErr != nil {
		return streamErr
	}

	content, marshallErr := json.MarshalIndent(stream, "", "  ")
	if marshallErr != nil {
		return marshallErr
	}

	err := os.WriteFile(baseDir+"stream.json", content, 0644)
	if err != nil {
		return err
	}

	return nil
}

func ReadStreamFile() (error, *Stream) {
	streamErr := EnsureStream()
	if streamErr != nil {
		return streamErr, nil
	}

	content, err := os.ReadFile(baseDir + "stream.json")
	if err != nil {
		return err, nil
	}

	var obj Stream
	unmarshallErr := json.Unmarshal(content, &obj)
	if unmarshallErr != nil {
		return unmarshallErr, nil
	}

	return nil, &obj
}
