package main

import (
	"log"
	"os"
	"os/signal"

	"github.com/IBM/sarama"
)

func main() {
	// 配置消费者
	config := sarama.NewConfig()
	config.Consumer.Return.Errors = true

	// 创建消费者
	consumer, err := sarama.NewConsumer([]string{"192.168.169.130:9092"}, config)
	if err != nil {
		log.Fatalln("Failed to start Sarama consumer:", err)
	}
	defer func() {
		if err := consumer.Close(); err != nil {
			log.Fatalln("Failed to close consumer:", err)
		}
	}()

	// 订阅主题
	topic := "test-topic"
	partitionConsumer, err := consumer.ConsumePartition(topic, 0, sarama.OffsetNewest)
	if err != nil {
		log.Fatalln("Failed to start partition consumer:", err)
	}
	defer func() {
		if err := partitionConsumer.Close(); err != nil {
			log.Fatalln("Failed to close partition consumer:", err)
		}
	}()

	// 处理中断信号
	signals := make(chan os.Signal, 1)
	signal.Notify(signals, os.Interrupt)

	// 消费消息
	for {
		select {
		case msg := <-partitionConsumer.Messages():
			log.Printf("Consumed message: %s at offset %d\n", msg.Value, msg.Offset)
		case err := <-partitionConsumer.Errors():
			log.Printf("Error: %s\n", err.Error())
		case <-signals:
			return
		}
	}
}
