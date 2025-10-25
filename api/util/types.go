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
	Title      string
	Songs      []Song
	Created    time.Time
	LastUpdate time.Time
}

type Song struct {
	UUID     string // artist_album_title_duration_date in base64 => YXJ0aXN0X2FsYnVtX3RpdGxlXzE4MF8wMTAxMjAyNQ==
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
	Playlists     []Playlist
	Configuration Configuration
}

type Stream struct {
	LastUpdate int64
	Version    string
	Token      string
	Users      []User
}
