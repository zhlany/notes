package sshc

import (
	"bytes"
	"fmt"
	"sync"
	"time"

	"golang.org/x/crypto/ssh"
)

type SSHClient struct {
	Host   string
	Port   int
	Config *ssh.ClientConfig
	Client *ssh.Client
	mu     sync.Mutex
}

func NewSSHClient(host string, port int, user, password string) *SSHClient {
	return &SSHClient{
		Host: host,
		Port: port,
		Config: &ssh.ClientConfig{
			User:            user,
			Auth:            []ssh.AuthMethod{ssh.Password(password)},
			HostKeyCallback: ssh.InsecureIgnoreHostKey(),
			Timeout:         10 * time.Second,
		},
	}
}

func (s *SSHClient) ensureConnected() error {
	s.mu.Lock()
	defer s.mu.Unlock()

	if s.Client != nil {
		_, _, err := s.Client.SendRequest("keepalive@golang", false, nil)
		if err == nil {
			return nil
		}
	}

	addr := fmt.Sprintf("%s:%d", s.Host, s.Port)
	client, err := ssh.Dial("tcp", addr, s.Config)
	if err != nil {
		return err
	}
	s.Client = client
	return nil
}

func (s *SSHClient) Run(cmd string) CmdResult {
	if err := s.ensureConnected(); err != nil {
		return CmdResult{Command: cmd, Err: err}
	}

	session, err := s.Client.NewSession()
	if err != nil {
		return CmdResult{Command: cmd, Err: err}
	}
	defer session.Close()

	var stdoutBuf, stderrBuf bytes.Buffer
	session.Stdout = &stdoutBuf
	session.Stderr = &stderrBuf

	err = session.Run(cmd)

	exitCode := 0
	if err != nil {
		if exitErr, ok := err.(*ssh.ExitError); ok {
			exitCode = exitErr.ExitStatus()
		} else {
			exitCode = -1
		}
	}

	return CmdResult{
		Command:  cmd,
		Stdout:   stdoutBuf.String(),
		Stderr:   stderrBuf.String(),
		ExitCode: exitCode,
		Err:      err,
	}
}

// RunConcurrent 并发多执行
func (s *SSHClient) RunConcurrent(cmds []string) []CmdResult {
	results := make([]CmdResult, len(cmds))
	var wg sync.WaitGroup
	wg.Add(len(cmds))

	for i, c := range cmds {
		go func(idx int, cmd string) {
			defer wg.Done()
			results[idx] = s.Run(cmd)
		}(i, c)
	}

	wg.Wait()
	return results
}
