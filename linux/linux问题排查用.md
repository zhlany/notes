nslookup查找域名的 IP 地址、反向解析 IP 地址到域名，以及查询特定的 DNS 记录

```shell
nslookup google.com  //
nslookup 142.250.72.206 //通过 IP 地址查询对应的域名
```

### 系统相关

#### 0.CPU占用

```shell
//每2s刷新
watch -n 2 "top -b -n 1 | head -n 17"
选项	作用
-n 秒数	设置刷新间隔（默认 2 秒）
-d	高亮显示变化的部分
-t	关闭标题行（不显示 watch 运行时间等信息）
-c	使用终端的颜色（如果终端支持）
-b	监测命令返回值，如果非 0，则发出警告（蜂鸣）
-g	退出 watch，当命令输出的内容发生变化时

//显示 java 进程的每个线程 CPU 占用情况
top -H -p $(pidof java)
//找到对应的线程 ID (TID) 假设你看到某个线程
printf "%x\n" 2125


top -o %CPU
ps -p <PID> -o %cpu,%mem,cmd
top -H -p <PID>

```

#### CPU占用过高排查

可能出现的问题：

1.GC频繁出发

2.服务高吞吐

3.磁盘 I/O 瓶颈

```shell
//1.先确认哪些线程占用 CPU
top -o %CPU
ps -p <PID> -o %cpu,%mem,cmd

//2.查找服务线程负载，显示 服务内部线程TID的 CPU 使用情况，观察哪些线程最占用 CPU
top -H -p <PID>
//更详细的线程信息。LWP 是线程 ID（TID）
ps -eLo pid,lwp,pcpu,pmem,cmd --sort=-pcpu | grep <服务>

//3.找到高 CPU 线程后，把它转换成 16 进制"<hex_tid>"
printf "%x\n" <TID>

//4.在 jstack 中查找该线程
jstack <服务-PID> | grep -A 20 "<hex_tid>"
【看到 Blocked 或 Runnable 状态，说明是 Kafka 任务或 GC 问题】

//检查 JVM GC 统计信息
jstat -gcutil <Kafka-PID> 1000
【如果 YGC（年轻代 GC）和 FGC（Full GC）频繁出现，说明 JVM 可能存在内存回收问题】
```

##### 磁盘I/O检查

iostat -xm 1

`await` 或 `svctm` 值过高，说明磁盘有瓶颈

```shell
log.segment.bytes=1073741824  # 降低单个日志段大小
log.segment.ms=600000         # 增加日志分段时间
num.partitions=3              # 增加分区数

```







### 服务相关

#### 0.查看系统日志

特别适用于 **systemd 服务**

```
//查看系统启动日志
journalctl -b


//查看特定 systemd 服务的日志
journalctl -u 服务名

//查看最近 30 分钟的日志,查看从特定时间开始的日志,查看特定时间段的日志
journalctl --since "30 minutes ago"
journalctl --since "2025-03-23 00:00:00"
journalctl --since "2025-03-23 00:00:00" --until "2025-03-23 02:00:00"


//查看 Kafka 失败的日志。-xe 选项：-x → 解释日志详情;-e → 直接跳到日志末尾
journalctl -xe -u kafka
journalctl -f   //实时日志
journalctl -d   //本次启动日志
journalctl --disk-usage   //查看日志占用空间
journalctl --vacuum-time=7d   //删除超过 7 天的日志


//例
journalctl -u kafka --no-pager | tail -n 50
```



#### 1.查看服务状态，ID，执行文件等

```shell
//例：查看防火墙服务状态
systemctl status firewalld.service

//查看服务进程
// -aux：查看占用资源； -ef：查看进程层次结构（显示父进程ID）
ps -aux | head -n 10  //显示前10条
ps -ef | grep firewalld

//部分服务没有常驻进程,需要查看相关内核模块
lsmod | grep ip_tables

journalctl -u <服务名>
journalctl -xe -u kafka --no-pager | tail -n 50
```

#### 2.查看服务端口号

```
//  -t：显示 TCP 端口。 -u：显示 UDP 端口。 -l：显示监听中的端口。
//  -n：以数字形式显示端口和地址。-p：显示进程 ID 和名称。
netstat -tulnp | grep "进程ID" 
```

#### 3.查看哪些文件正在使用端口号

```shell
lsof -i -P -n | grep <端口号>
lsof -i -P -n -p <进程ID>
```

