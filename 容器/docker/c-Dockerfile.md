# docker部署

## 极小存储

构建docker服务应该尽量减小容器占用的存储空间，

- `scratch`：【FROM scratch 】空镜像，什么都不包含，适合静态编译的程序。
- `alpine`：【FROM alpine:latest】一个很小的Linux发行版，包含基本的工具，大小约5MB。如果我们的程序需要一些外部依赖（如CA证书）或shell等，可以选择alpine。
- `distroless`: 【FROM gcr.io/distroless/static-debian11】Google出品，只包含运行环境

方案：

1. 使用小的基础镜像
2. 多阶段构建（Multi-stage build）来减少最终镜像的大小，因为最终镜像只包含编译后的可执行文件，而不包含编译环境和源代码。
3. 使用静态编译，这样生成的可执行文件不依赖外部的动态库，可以运行在很小的基础镜像上。



## 步骤进行

### 1. 选择小的基础镜像

对于Go项目，我们可以选择非常小的基础镜像，例如：

- `scratch`：空镜像，什么都不包含，适合静态编译的程序。
- `alpine`：一个很小的Linux发行版，包含基本的工具，大小约5MB。如果我们的程序需要一些外部依赖（如CA证书）或shell等，可以选择alpine。

### 2. 多阶段构建

多阶段构建允许我们在一个Dockerfile中使用多个FROM语句，每个FROM语句可以使用不同的基础镜像。我们可以在一阶段中编译Go程序，然后在二阶段中将编译好的可执行文件复制到一个小的基础镜像中。

### 3. 静态编译

在Go中，通过设置环境变量`CGO_ENABLED=0`来禁用CGO，这样可以生成静态链接的可执行文件，从而可以在`scratch`镜像中运行。



## Dockerfile构建

### scratch

- **`scratch`作为基础镜像，多阶段构建**

```dockerfile
# 第一阶段：构建阶段
FROM golang:1.19-alpine AS builder

# 设置工作目录
WORKDIR /app

# 将go.mod和go.sum复制到工作目录
COPY go.mod go.sum ./

# 下载依赖
RUN go mod download

# 复制源代码
COPY . .

# 编译项目，禁用CGO，并生成静态链接的可执行文件
# -ldflags="-w -s": 移除调试信息，减小二进制大小
# -a: 强制重新编译所有包
# -installsuffix cgo: 静态链接C库
RUN CGO_ENABLED=0 GOOS=linux go build -ldflags="-w -s" -a -installsuffix cgo -o main .

# 第二阶段：运行阶段
FROM scratch

# 从构建阶段复制可执行文件
COPY --from=builder /app/main .

# 复制CA证书（如果需要访问外部TLS服务，如HTTPS）
# 如果不需要可以省略
COPY --from=builder /etc/ssl/certs/ca-certificates.crt /etc/ssl/certs/

# 暴露端口（根据实际情况修改）
EXPOSE 8080

# 运行程序
CMD ["./main"]
```

### alpine

- **`alpine`作为镜像，包含shell和基本工具的环境中运行（例如为了调试）**

```dockerfile
# 第一阶段：构建阶段
FROM golang:1.19-alpine AS builder

# 设置工作目录
WORKDIR /app

# 将go.mod和go.sum复制到工作目录
COPY go.mod go.sum ./

# 下载依赖
RUN go mod download

# 复制源代码
COPY . .

# 编译项目，禁用CGO，并生成静态链接的可执行文件
RUN CGO_ENABLED=0 GOOS=linux go build -a -installsuffix cgo -o main .

# 第二阶段使用alpine
FROM alpine:latest

# 安装CA证书（如果需要）
RUN apk --no-cache add ca-certificates

WORKDIR /root/

# 从构建阶段复制可执行文件
COPY --from=builder /app/main .

# 暴露端口
EXPOSE 8080

# 运行程序
CMD ["./main"]
```

### Distroless 

Distroless 是 Google 推出的专注于安全的最小化容器镜像，只包含应用程序及其运行时依赖，不包含 shell、包管理器等工具。

**假设项目结构：**

```sh
myapp/
├── Dockerfile
├── go.mod
├── main.go
├── templates/
│   └── index.html
└── static/
    └── style.css
```

Dockerfile：

```dockerfile
# 构建阶段
FROM golang:1.21-alpine AS builder

WORKDIR /app
COPY go.mod go.sum ./
RUN go mod download

COPY . .
RUN CGO_ENABLED=0 GOOS=linux go build \
    -ldflags="-w -s -extldflags '-static'" \
    -a -installsuffix cgo \
    -o main .

# 运行阶段 - 使用 distroless
FROM gcr.io/distroless/static-debian12

# 复制可执行文件
COPY --from=builder /app/main /
COPY --from=builder /app/templates ./templates
COPY --from=builder /app/static ./static

# 设置非root用户
USER nonroot:nonroot

CMD ["/main"]
```

不同需求的Distroless选择

```dockerfile
# 选项1: 静态二进制 (推荐)
FROM gcr.io/distroless/static-debian12

# 选项2: 需要C库支持
FROM gcr.io/distroless/base-debian12

# 选项3: 需要调试工具 (非生产)
FROM gcr.io/distroless/static-debian12:debug
```

