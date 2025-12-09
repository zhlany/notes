package runner

import (
	"sync"

	"godemo/internal/sshc"
)

// MultiHostRun 向所有主机发送命令
func MultiHostRun(manager *sshc.Manager, cmd string) map[string]sshc.CmdResult {
	results := make(map[string]sshc.CmdResult)
	var mu sync.Mutex
	var wg sync.WaitGroup

	for name, cli := range manager.All() {
		wg.Add(1)
		go func(name string, cli *sshc.SSHClient) {
			defer wg.Done()
			r := cli.Run(cmd)

			mu.Lock()
			results[name] = r
			mu.Unlock()
		}(name, cli)
	}

	wg.Wait()
	return results
}
