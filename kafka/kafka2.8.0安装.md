linux环境下

### 1.下载安装

```shell
//下载javav jdk 17，在/opt/jdk/ 目录下（需要检查kafka需要的版本）
//添加环境变量
vi  ~/.bashrc
export JAVA_HOME=/path/to/jdk-17
export PATH=$JAVA_HOME/bin:$PATH


//下载kafka 4.0并解压，在/opt/目录下
wget https://dlcdn.apache.org/kafka/4.0.0/kafka_2.13-4.0.0.tgz
tar -xzf kafka_2.13-4.0.0.tgz
//查看版本
cd kafka_2.13-4.0.0
bin/kafka-topics.sh --version
```

### 2.配置Kafka Broker（使用KRaft 模式）

```shell
vi config/server.properties

process.roles=broker,controller
node.id=1  # 每个节点的唯一 ID
controller.quorum.voters=1@localhost:9093
listeners=PLAINTEXT://:9092,CONTROLLER://:9093
advertised.listeners=PLAINTEXT://<主机IP>:9092

controller.listener.names=CONTROLLER

log.dirs=/tmp/kafka-logs

```

创建mate.meta.properties文件

```shell
// 创建log.dirs目录
mkdir -p /tmp/kafka-logs
cd /tmp/kafka-logs

//创建mate.meta.properties文件
//添加内容
# Kafka 集群的唯一 ID
# cluster.id：可以通过以下命令生成一个唯一的集群 ID:
# bin/kafka-storage.sh random-uuid
cluster.id=your-cluster-id
# 当前节点的唯一 ID
node.id=1
# Kafka 版本
version=4.0.0
```

###  

### 3.启动 Kafka Broker

初始化原始数据(单机模式下添加--standalone)

```shell
bin/kafka-storage.sh format -t 9c9SCzP2QBOE_pZQCprvuQ -c config/server.properties --standalone

//启动kafka
bin/kafka-server-start.sh config/server.properties

//在后台运行
bin/kafka-server-start.sh config/server.properties &
```



### 4.创建kafka服务文件

```shell
vi /etc/systemd/system/kafka.service
```

```
[Unit]
Description=Apache Kafka Server

[Service]
Type=simple
User=kafka
Group=kafka
ExecStart=/path/to/kafka_2.13-4.0.0/bin/kafka-server-start.sh /path/to/kafka_2.13-4.0.0/config/server.properties
ExecStop=/path/to/kafka_2.13-4.0.0/bin/kafka-server-stop.sh
Restart=on-failure
RestartSec=10
Environment="JAVA_HOME=/usr/lib/jvm/java-17-openjdk"

[Install]
WantedBy=multi-user.target
```

- **`/path/to/kafka_2.13-4.0.0`**：替换为你的 Kafka 安装路径。
- **`User=kafka` 和 `Group=kafka`**：如果你有专门的用户和组来运行 Kafka，可以替换为对应的用户和组。如果没有，可以删除这两行或使用 `root`。
- **`After=network.target zookeeper.service`**：如果 Kafka 依赖 Zookeeper，确保 Zookeeper 服务已经启动。

### 5.重启systemd配置

sudo systemctl daemon-reload
