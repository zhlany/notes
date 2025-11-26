```sh
#!/bin/bash

set -e

echo "Starting Docker Compose..."

# 检查环境变量文件
if [ ! -f .env ]; then
    echo "Warning: .env file not found, using default values"
fi

# 构建并启动服务
docker-compose down
docker-compose build --no-cache
docker-compose up -d

echo "Services started successfully!"
echo "MySQL: localhost:3307"
echo "Gin App: localhost:3435"

# 显示日志
docker-compose logs -f
```

