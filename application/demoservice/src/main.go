package main

import (
	"encoding/json"
	"fmt"
	"net/http"
	"time"
)

type logJson struct {
	Level   string `json:"level"`
	Dt      string `json:"dt"`
	Id      string `json:"id"`
	Url     string `json:"url"`
	Method  string `json:"method"`
	Message string `json:"message"`
}

func handler(w http.ResponseWriter, r *http.Request) {
	fmt.Println(logStr(&logJson{Level: "INFO", Id: "1234-5678", Dt: fmt.Sprint(time.Now()), Url: "http://localhost:18080/usagisan", Method: "usagisan", Message: "start usagisan"}))

	fmt.Fprint(w, "Hello World!")

	fmt.Println(logStr(&logJson{Level: "INFO", Id: "1234-5678", Dt: fmt.Sprint(time.Now()), Url: "http://localhost:18080/usagisan", Method: "usagisan", Message: "start usagisan"}))
}

func logStr(v interface{}) string {
	b, err := json.Marshal(v)
	if err != nil {
		return fmt.Sprintln(err)
	}
	return string(b)
}

func main() {
	http.HandleFunc("/hello", handler)
	http.ListenAndServe(":18080", nil)
}
