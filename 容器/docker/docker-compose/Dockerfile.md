```dockerfile
# 构建阶段
FROM golang:1.21-alpine AS builder

ARG APP_VERSION=1.0.0
ARG BUILD_ENV=production

WORKDIR /app

# 复制依赖文件
COPY go.mod go.sum ./
RUN go mod download

# 复制源代码
COPY . .

# 运行测试（生产环境可跳过）
RUN if [ "$BUILD_ENV" != "production" ]; then go test ./...; fi

# 构建应用
RUN CGO_ENABLED=0 GOOS=linux go build \
    -ldflags="-w -s -X main.version=$APP_VERSION" \
    -a -installsuffix cgo \
    -o main .

# 运行阶段
FROM alpine:latest

RUN apk --no-cache add ca-certificates tzdata && \
    addgroup -S app && adduser -S app -G app

WORKDIR /home/app

# 从构建阶段复制二进制文件
COPY --from=builder --chown=app:app /app/main .
COPY --chown=app:app config ./config

# 创建必要的目录
RUN mkdir -p logs && chown app:app logs

USER app

EXPOSE 3435

# 健康检查端点需要在应用中实现
HEALTHCHECK --interval=30s --timeout=10s --start-period=40s --retries=3 \
    CMD wget --no-verbose --tries=1 --spider http://localhost:3435/health || exit 1

CMD ["./main"]
```

