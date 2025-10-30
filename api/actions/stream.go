package actions

import (
	"api/util"
	"fmt"
	"time"

	"github.com/goccy/go-json"
)

func GetStream() (*util.Stream, error) {
	err, stream := util.ReadStreamFile()
	if err != nil {
		return nil, fmt.Errorf("failed to read stream file: %v", err)
	}

	return stream, nil
}

func InitStream(version string, token string) util.ActionResponse {
	stream := util.Stream{
		Version:    version,
		Token:      token,
		LastUpdate: time.Now().Unix(),
	}

	streamErr := util.WriteStreamFile(stream)
	if streamErr != nil {
		return util.ActionResponse{
			Success: false,
			Message: "failed to initialize stream",
		}
	}

	return util.ActionResponse{
		Success: true,
		Message: "stream initialized successfully",
	}
}

func UpdateStream(stream util.Stream) error {
	existingStream, err := GetStream()
	if err != nil {
		return fmt.Errorf("failed to get existing stream: %v", err)
	}

	oldStream, err := json.Marshal(existingStream)
	if err != nil {
		return fmt.Errorf("failed to marshal existing stream: %v", err)
	}

	newStream, err := json.Marshal(&stream)
	if err != nil {
		return fmt.Errorf("failed to marshal new stream: %v", err)
	}

	if string(oldStream) == string(newStream) {
		return nil
	}

	var a, b map[string]interface{}
	a, err = util.LoadJSON(string(oldStream))
	b, err = util.LoadJSON(string(newStream))
	res := util.Merge(a, b)

	mergedStreamBytes, err := json.Marshal(res)
	if err != nil {
		return fmt.Errorf("failed to marshal merged stream: %v", err)
	}

	var mergedStream util.Stream
	err = json.Unmarshal(mergedStreamBytes, &mergedStream)
	if err != nil {
		return fmt.Errorf("failed to unmarshal merged stream: %v", err)
	}

	err = util.WriteStreamFile(mergedStream)
	if err != nil {
		return fmt.Errorf("failed to write merged stream file: %v", err)
	}

	return nil
}

func GetUpdates(stream util.Stream) util.ActionResponse {
	return util.ActionResponse{
		Success: true,
		Message: "updates retrieved successfully",
		Return:  stream,
	}
}
