package utils

import (
	"encoding/json"
)

func ToJSON(v any) string {
	b, _ := json.MarshalIndent(v, "", "  ")
	return string(b)
}
