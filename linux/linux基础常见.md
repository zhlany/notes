### 网络配置

```go
vi /etc/sysconfig/network-scripts/ifcfg-ens33

//配置静态IP，添加
BOOTPROTO="static"          # 改为静态 IP（或使用 "none"）
IPADDR=192.168.1.100       # 静态 IP 地址（根据实际网络填写）
NETMASK=255.255.255.0      # 子网掩码
GATEWAY=192.168.1.1        # 默认网关（通常为路由器 IP）
DNS1=8.8.8.8               # 主 DNS（已存在，无需修改）
DNS2=8.8.4.4               # 备用 DNS（已存在，无需修改）
```

### 常用设置

shell会话永不退出

```shell
//永不休眠
vi /etc/profile
TMOUT=0
source /etc/proflie

//grep 添加颜色
export GREP_OPTIONS="--color=auto"
```

### 命令补全工具bash-completion

```shell
yum install bash-completion
```

### SCP文件传输

```shell
scp [选项] [源文件] [目标路径]
-P <端口>	指定远程主机的SSH端口（默认是22）。
-r	递归复制整个目录。
-C	启用压缩传输。
-v	显示详细输出（调试模式）。
-i <私钥文件>	指定用于身份验证的私钥文件。

//从本地复制文件到远程主机
//(user@remote_host：远程主机的用户名和地址。)
scp local_file.txt user@remote_host:/remote/directory/
//从远程主机复制文件到本地
scp user@remote_host:/remote/file.txt /local/directory/
```

