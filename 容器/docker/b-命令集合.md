# 镜像相关

| 功能         | 命令                                        |
| ------------ | ------------------------------------------- |
| 搜索镜像     | `docker search <镜像名>`                    |
| 拉取镜像     | `docker pull <镜像名>:<标签>`               |
| 查看镜像列表 | `docker images`                             |
| 删除镜像     | `docker rmi <iamge name>:<tag>`             |
| 构建镜像     | `docker build -t <iamge name>:<tag> <路径>` |

# 容器管理

| 功能                       | 命令                                                         |
| -------------------------- | ------------------------------------------------------------ |
| 运行容器                   | `docker run [选项] <镜像名>`示例：`docker run -d -p 8080:80 nginx` |
| 挂载主机目录到容器         | docker run -d --name <container name> -v /host/path:/app/data <iamge name>:<tag> |
| 挂载主机目录到容器         | docker run -d --name <container name> --mount type=bind,source=/host/path,target=/app/data <iamge name>:<tag> |
| 卷挂载                     | docker run -d --name <container name> -v <volume name>:/app/data <iamge name>:<tag> |
| 卷挂载                     | docker run -d --name <container name> --mount type=volume,source=<volume name>,target=/app/data <iamge name>:<tag> |
| 查看正在运行的容器         | `docker ps`                                                  |
| 查看所有容器（包括停止的） | `docker ps -a`                                               |
| 停止容器                   | `docker stop <containerID | container name>`                 |
| 启动容器                   | `docker start <containerID | container name>`                |
| 重启容器                   | `docker restart <containerID | container name>`              |
| 删除容器                   | `docker rm <容器ID或名称>`                                   |
| 强制删除运行中的容器       | `docker rm -f <容器ID>`                                      |

# 容器操作

| 功能               | 命令                                       |
| ------------------ | ------------------------------------------ |
| 容器内部执行命令   | `docker exec -it <容器名> /bin/bash`       |
| 查看容器日志       | `docker logs <容器ID或名称>`               |
| 查看容器使用的端口 | `docker port <容器ID或名称>`               |
| 拷贝文件到容器中   | `docker cp <宿主路径> <容器ID>:<容器路径>` |
| 拷贝容器文件到主机 | `docker cp <容器ID>:<容器路径> <宿主路径>` |



# 系统管理

| 功能                 | 命令                     |
| -------------------- | ------------------------ |
| 查看 Docker 版本     | `docker version`         |
| 查看系统信息         | `docker info`            |
| 清理未使用资源       | `docker system prune`    |
| 删除所有已停止的容器 | `docker container prune` |
| 删除所有未使用的镜像 | `docker image prune`     |

# 网络与卷

| 功能     | 命令                             |
| -------- | -------------------------------- |
| 查看网络 | `docker network ls`              |
| 创建网络 | `docker network create <网络名>` |
| 查看卷   | `docker volume ls`               |
| 创建卷   | `docker volume create <卷名>`    |

# Docker Compose

| 功能         | 命令                     |
| ------------ | ------------------------ |
| 启动服务     | `docker compose up -d`   |
| 停止服务     | `docker compose down`    |
| 查看服务日志 | `docker compose logs`    |
| 重启服务     | `docker compose restart` |