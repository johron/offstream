package util

import (
	"encoding/json"
)

func Merge(a, b map[string]interface{}) map[string]interface{} {
	result := make(map[string]interface{})

	// copy all fields from A
	for k, v := range a {
		result[k] = v
	}

	// merge/override from B
	for k, vB := range b {
		if vA, exists := result[k]; exists {
			// both exist and are maps
			mapA, okA := vA.(map[string]interface{})
			mapB, okB := vB.(map[string]interface{})
			if okA && okB {
				result[k] = Merge(mapA, mapB)
				continue
			}

			// both have LastUpdate timestamps → choose newer
			lastA := getLastUpdate(a)
			lastB := getLastUpdate(b)

			if lastB > lastA {
				result[k] = vB
			} else {
				result[k] = vA
			}
		} else {
			result[k] = vB
		}
	}

	return result
}

func LoadJSON(content string) (map[string]interface{}, error) {
	var obj map[string]interface{}
	if err := json.Unmarshal([]byte(content), &obj); err != nil {
		return nil, err
	}
	return obj, nil
}

func getLastUpdate(m map[string]interface{}) float64 {
	if v, ok := m["LastUpdate"]; ok {
		if f, ok := v.(float64); ok {
			return f
		}
	}
	return 0
}
