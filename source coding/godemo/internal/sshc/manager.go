package sshc

import "sync"

type Manager struct {
	mu      sync.RWMutex
	clients map[string]*SSHClient
}

func NewManager() *Manager {
	return &Manager{
		clients: make(map[string]*SSHClient),
	}
}

func (m *Manager) Add(name string, c *SSHClient) {
	m.mu.Lock()
	defer m.mu.Unlock()
	m.clients[name] = c
}

func (m *Manager) Get(name string) (*SSHClient, bool) {
	m.mu.RLock()
	defer m.mu.RUnlock()
	c, ok := m.clients[name]
	return c, ok
}

func (m *Manager) All() map[string]*SSHClient {
	m.mu.RLock()
	defer m.mu.RUnlock()
	return m.clients
}
