package main

import (
	"sync"
)

func main() {
	group := sync.WaitGroup{}

	group.Add(1)
	go func() {
		defer func() {
			group.Done()
		}()
		// TODO: receive NATS mesages
	}()

	group.Wait()
}