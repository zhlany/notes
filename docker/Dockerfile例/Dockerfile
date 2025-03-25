FROM goland1.22-gin AS build
WORKDIR /gin-jxpro
# 复制 go.mod 和 go.sum 文件到工作目录
COPY go.mod go.sum ./

# 下载依赖
RUN go mod tidy

# 复制项目源码到工作目录
COPY . .

# 构建 Go 应用
# RUN go build -o main .

# ENV CGO_ENABLED=0
EXPOSE 3435/tcp

#RUN go build -o openapi .
#ENTRYPOINT ["./openapi"]

# CMD ["go", "run", "main.go"]

#####第二阶段

#以空白的基础镜像 scratch 开始构建镜像
#FROM scratch AS runtime
#设置生产环境模式（release）来优化性能
#ENV GIN_MODE=release
#从名为 build 的构建阶段复制文件
#COPY --from=build /go/src/openapi ./
#EXPOSE 3435/tcp
#ENTRYPOINT ["./openapi"]
