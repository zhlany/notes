package sshc

import (
	"fmt"
	"io"
	"os"
	"path"
)

func (s *SSHClient) SCPUpload(local, remote string) error {
	if err := s.ensureConnected(); err != nil {
		return err
	}

	session, err := s.Client.NewSession()
	if err != nil {
		return err
	}
	defer session.Close()

	srcFile, err := os.Open(local)
	if err != nil {
		return err
	}
	defer srcFile.Close()

	fileInfo, _ := srcFile.Stat()

	w, _ := session.StdinPipe()
	go func() {
		fmt.Fprintf(w, "C0644 %d %s\n", fileInfo.Size(), path.Base(remote))
		io.Copy(w, srcFile)
		fmt.Fprint(w, "\x00")
		w.Close()
	}()

	if err := session.Run(fmt.Sprintf("scp -t %s", path.Dir(remote))); err != nil {
		return err
	}
	return nil
}
