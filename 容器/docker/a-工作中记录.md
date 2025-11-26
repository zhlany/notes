--no-cache**强制忽略所有缓存层，从头开始构建**

```shell
# 开发环境 - 通常不需要 --no-cache
# 生产环境发布 - 建议使用 --no-cache

# 不使用 --no-cache，可能还在用旧的基础镜像
docker build -t myapp .

# 使用 --no-cache，确保获取最新的基础镜像
docker build --no-cache -t myapp .
```

