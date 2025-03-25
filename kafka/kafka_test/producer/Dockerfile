# 使用官方的 Go 镜像作为基础镜像
FROM golang:1.21-alpine

# 设置工作目录
WORKDIR /app

# 安装必要的工具
RUN apk add --no-cache \
    git \
    bash \
    curl \
    wget \
    unzip \
    gcc \
    musl-dev


# 安装 Go 工具链
RUN go install golang.org/x/tools/cmd/gopls@latest && \
    go install github.com/go-delve/delve/cmd/dlv@latest && \
    go install github.com/cosmtrek/air@latest

# 设置环境变量
ENV GOPATH /go
ENV PATH $GOPATH/bin:$PATH

# 暴露端口（如果需要）
EXPOSE 3030

# 启动命令（可以根据需要修改）
#CMD ["bash"]