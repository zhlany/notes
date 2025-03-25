#!/bin/bash

# 检查是否提供了容器名称参数
if [ $# -eq 0 ]; then
  echo "请提供一个或多个容器名称作为参数。"
  echo "用法: $0 <容器名称1> [<容器名称2> ...]"
  exit 1
fi

# 获取传递的容器名称
CONTAINER_NAME=$1

# 遍历所有提供的容器名称
for CONTAINER_NAME in "$@"; do
  # 检查容器是否存在
  if [ "$(docker ps -a -q -f name=$CONTAINER_NAME)" ]; then
	docker rm -f $CONTAINER_NAME
    echo "容器 $CONTAINER_NAME 已存在，正在删除..."
  else
    echo "容器 $CONTAINER_NAME 不存在。"
  fi
done

# 获取当前工作目录
CURRENT_DIR=$(pwd)

# 使用 docker-compose 启动新容器
docker-compose -f ${CURRENT_DIR}/docker-compose.yml up -d
