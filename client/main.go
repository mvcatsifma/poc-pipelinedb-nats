package main

import (
	"github.com/nats-io/go-nats"
	"log"
	"os"
	"os/signal"
	"sync"
	"syscall"
)

func main() {
	group := sync.WaitGroup{}

	nc, _ := nats.Connect(nats.DefaultURL)

	rcvChannel := make(chan *nats.Msg, 64)
	sub, err := nc.ChanSubscribe("products", rcvChannel)
	if err != nil {
		log.Fatal("subscribe error", err)
	}
	log.Println("subscribed to products channel")

	terminate := make(chan bool)

	group.Add(1)
	go func() {
		defer func() {
			group.Done()
		}()

	ReceiveLoop:
		for {
			select {
			case msg := <-rcvChannel:
				log.Println("rcv message", string(msg.Data))
			case <-terminate:
				log.Println("rcv terminate")
				break ReceiveLoop
			}
		}
	}()

	// create a channel to receive incoming OS interrupts and signals:
	osInterruptChannel := make(chan os.Signal, 1)
	signal.Notify(osInterruptChannel, os.Interrupt, syscall.SIGHUP)

	// This read will block execution until an OS signal (such as Ctrl-C) is received:
readInterruptLoop:
	for {
		select {
		case sig := <-osInterruptChannel:
			switch sig {
			case os.Interrupt:
				terminate <- true
				group.Wait()
				break readInterruptLoop
			}
		}
	}
	signal.Stop(osInterruptChannel) // stop sending signals

	err = sub.Unsubscribe()
	if err != nil {
		log.Println("unsubscribe error", err)
	}
	close(rcvChannel)
	log.Println("unsubscribed from products channel")
}
