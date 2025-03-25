# Curl

curl 是一个命令行工具，用于在终端中发送 HTTP 请求并接收响应。

以下是 curl 命令的一些常用选项和用法：

| 字符 | 说明                                                         |
| ---- | :----------------------------------------------------------- |
| -X   | 指定 HTTP 请求方法，如 -X GET 表示发送 GET 请求。            |
| -H   | 设置 HTTP 请求头，如 -H "Content-Type: application/json" 表示设置请求头的 Content-Type 为 application/json。 |
| -d   | 设置 HTTP 请求体，如 -d '{"name": "John", "age": 30}' 表示设置请求体为 JSON 格式的数据。 |
| -o   | 将响应保存到文件中，如 -o response.txt 表示将响应保存到 response.txt 文件中。 |
| -s   | 静默模式，不输出任何信息。                                   |
| -v   | 详细模式，输出请求和响应的详细信息。                         |
| -u   | 设置 HTTP 认证信息，如 -u username:password 表示使用基本认证方式，并设置用户名和密码。 |

以下是一些常见的 curl 命令用法示例：

发送 GET 请求：curl https://www.example.com

发送 POST 请求：curl -X POST -H "Content-Type: application/json" -d '{"name": "John", "age": 30}' https://www.example.com

下载文件：curl -o filename.txt https://www.example.com/file.txt

使用 HTTP 认证：curl -u username:password https://www.example.com