```dockerfile
# 生产环境
docker-compose up -d

# 开发环境（使用 override）
docker-compose -f docker-compose.yml -f docker-compose.override.yml up -d

# 重新构建
docker-compose build --no-cache
docker-compose up -d



```





```sh
# 查看状态：
docker-compose ps
docker-compose logs
docker-compose logs gin_service

# 进入容器：
docker-compose exec zhl_service mysql -u root -p
docker-compose exec gin_service sh
```

