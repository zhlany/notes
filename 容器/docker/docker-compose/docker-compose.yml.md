```yaml
version: '3.8'

services:
  mysql_service:
    image: mysql:8.0  # ✅ 使用具体版本号
    container_name: zhl-mysql
    environment:
      - MYSQL_ROOT_PASSWORD=${MYSQL_ROOT_PASSWORD}
      - MYSQL_DATABASE=${MYSQL_DATABASE}
      - MYSQL_USER=${MYSQL_USER}
      - MYSQL_PASSWORD=${MYSQL_PASSWORD}
      - MYSQL_CHARSET=utf8mb4
      - MYSQL_COLLATION=utf8mb4_unicode_ci
    volumes:
      - mysql_data:/var/lib/mysql
      - ./mysql/init.sql:/docker-entrypoint-initdb.d/init.sql:ro  # ✅ 初始化脚本
      - ./mysql/conf.d:/etc/mysql/conf.d:ro  # ✅ 自定义配置
    ports:
      - "3307:3306"
    networks:
      - my_network
    restart: unless-stopped  # ✅ 更优雅的重启策略
    healthcheck:  # ✅ 添加健康检查
      test: ["CMD", "mysqladmin", "ping", "-h", "localhost", "-u", "root", "-p${MYSQL_ROOT_PASSWORD}"]
      timeout: 20s
      retries: 10
      start_period: 30s
      interval: 10s

  gin_jxpro_service:
    build:
      context: .
      dockerfile: Dockerfile
      args:  # ✅ 构建参数
        - APP_VERSION=1.0.0
        - BUILD_ENV=production
    image: gin_jxpro:latest
    container_name: gin-jxpro
    environment:
      - CGO_ENABLED=${CGO_ENABLED:-0}
      - DB_USER=${DB_USER}
      - DB_PASSWORD=${DB_PASSWORD}
      - DB_HOST=mysql_service  # ✅ 使用服务名作为主机
      - DB_PORT=3306  # ✅ 容器内端口
      - DB_NAME=${DB_NAME}
      - GIN_MODE=release
      - PORT=3435
    # 开发环境取消注释以下 volumes
    # volumes:
    #   - .:/gin-jxpro
    #   - ./logs:/app/logs
    depends_on:
      mysql_service:
        condition: service_healthy  # ✅ 等待 MySQL 健康
    ports:
      - "3435:3435"
    command: ["./main"]  # ✅ 运行编译后的二进制文件  command: go run main.go  # 开发模式使用 go run
    networks:
      - my_network
    restart: unless-stopped
    healthcheck:  # ✅ 应用健康检查
      test: ["CMD", "wget", "--no-verbose", "--tries=1", "--spider", "http://localhost:3435/health"]
      interval: 30s
      timeout: 10s
      retries: 3
      start_period: 40s

# 确保它们在同一个 Docker 网络中，这样它们才能通过容器名称互相发现和通信
networks:
  my_network:
    driver: bridge
    # 可选：自定义网络配置
    # ipam:
    #   config:
    #     - subnet: 172.20.0.0/16

volumes:
  mysql_data:
    driver: local
```

