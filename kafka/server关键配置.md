# 单机模式

只列出关键配置

```shell
//表示该节点既是 Broker 又是 Controller
process.roles=broker,controller

//节点的唯一 ID
node.id=1

//指定控制器的投票节点列表。在单机模式下，只需指定当前节点。
controller.quorum.voters=1@localhost:9093

//- `PLAINTEXT://:9092`：Broker 监听器，用于客户端通信。
//- `CONTROLLER://:9093`：Controller 监听器，用于控制器通信。
listeners=PLAINTEXT://:9092,CONTROLLER://:9093

//对外暴露的 Broker 地址
advertised.listeners=PLAINTEXT://localhost:9092

//指定控制器监听器名称
controller.listener.names=CONTROLLER

//Kafka 数据存储目录
log.dirs=/tmp/kafka-logs
```



需要注意防火墙是否拦截了端口，以及监听是否是IPV4（部分服务默认监听的事ipv6，这会导致服务无法给其他IP访问）

```
vi /bin/kafka-server-start.sh

//监听IPV4
export KAFKA_OPTS="-Djava.net.preferIPv4Stack=true"
exec $base_dir/kafka-run-class.sh $EXTRA_ARGS kafka.Kafka "$@"
```



# 集群模式