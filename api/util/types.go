package util

import (
	"time"
)

type ActionResponse struct {
	Success bool
	Message string
	Return  interface{}
}

type Configuration struct {
}

type Playlist struct {
	Title   string
	Songs   []Song
	Created time.Time
}

type Song struct {
	Title    string
	Artist   string
	Album    string
	Duration Duration
	Created  time.Time
	Added    time.Time
}

type Duration struct {
	minutes int
	seconds int
}

type User struct {
	Username      string
	Password      string
	Configuration Configuration
}
