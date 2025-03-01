go语言的学习的笔记



## 1、go语言的历史  

2007年开发一门全新的语言

2015年google发布Go 1.5

 2017

 2018

## 2、go语言的特点

“21 世纪的C语言”

部署简单、并发性好、语言设计良好、执行性能好

网络编程、系统编程、并发编程、分布式编程



## 3、比较流行的语言比较

1、 C\C++   java  python Go

C\C++ 执行效率高 开发效率低  对程序员能力要求高

python 执行效率低 开发效率高

java  站在一个平衡点

go  开发效率高  执行效率高



## 4、环境搭建

4.1  安装Go的安装包：go1.17.2.windows-amd64.msi

4.2 配置环境变量：  GOROOT：C:\Program Files\Go

​                                      path：C:\Program Files\Go\bin

​                                      gopath：C:\Users\laokai\go;C:\goproject

4.3 安装vscode

4.4  安装vscode 的插件 chinese插件 go的插件

4.5  编写一个go的文件 main.go

​          注意：文件结构：$GOPATH$/src/main.go

```go
package main

import "fmt"
func main(){
    
  fmt.Println("hello world")

}
```

4.6 执行

​       go run main.go

​     注意：当软件提示没有mod时，在终端执行：       go env -w GO111MODULE=auto
