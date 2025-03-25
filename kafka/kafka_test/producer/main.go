package main

import (
	"github.com/IBM/sarama"
	"log"
	"os"
	"os/signal"
)

func main() {
	// 配置生产者
	config := sarama.NewConfig()
	config.Producer.Return.Successes = true
	config.Producer.RequiredAcks = sarama.WaitForAll
	config.Producer.Retry.Max = 5

	// 创建生产者
	producer, err := sarama.NewSyncProducer([]string{"192.168.169.130:9092"}, config)
	if err != nil {
		log.Fatalln("Failed to start Sarama producer:", err)
	}
	defer func() {
		if err := producer.Close(); err != nil {
			log.Fatalln("Failed to close producer:", err)
		}
	}()

	// 发送消息
	topic := "test-topic"
	msg := &sarama.ProducerMessage{
		Topic: topic,
		Value: sarama.StringEncoder("Hello, Kafka!"),
	}

	partition, offset, err := producer.SendMessage(msg)
	if err != nil {
		log.Fatalln("Failed to send message:", err)
	}

	log.Printf("Message sent to partition %d at offset %d\n", partition, offset)

	// 处理中断信号
	signals := make(chan os.Signal, 1)
	signal.Notify(signals, os.Interrupt)
	<-signals
}
