# Stream API
- Server API for the Offstream client

## Todo
- JSON merging:
  - .gitattributes, driver, jsonmerge in .git/config

## Documentation (Unfinished)
- `*` indicates optional fields

### Add User
`POST /adduser`
- Request Body:
```json
{
  "token": "string",
  "username": "string",
  "password": "string"
}
```
- Response Body:
```json
{
  "message": "string"
}
```

### New Playlist
`POST /newplaylist`
- Request Body:
```json
{
  "username": "string",
  "password": "string",
  "name": "string"
}
```
- Response Body:
```json
{
  "message": "string"
}
```

### Get Playlists
`GET /getplaylists`
- Request
- Query Parameters:
  - `username`: string
- Response Body:
```json
{
  "playlists": [
    {
      "id": "string",
      "name": "string",
      "tracks": [
        {
          "id": "string",
          "title": "string",
          "artist": "string",
          "duration": 0
        }
      ]
    }
  ]
}
```

### Get User Configuration
`GET /getuserconf`
- Request
- Query Parameters:
  - `username`: string
- Response Body:
```json
{}
```

### Poke
`GET /poke`
- Request
- Query Parameters:
  - `username`: string
  - `last_update`: integer
- Response Body:
- If no updates:
```json
{
  "timestamp": "integer",
  "message": "no updates"
}
```
- If updates available:
```json
{
  "timestamp": "integer",
  "message": "updates retrieved successfully",
  "updates*": {
    "playlists*": "playlists[]",
    "user*": "user"
  }
}
```