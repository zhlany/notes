# 目录结构

| 目录       | 用途说明                                             |
| :--------- | :--------------------------------------------------- |
| **/**      | 根目录，所有其他目录的起点                           |
| **/bin**   | 基本用户命令二进制文件（普通用户和root用户都能使用） |
| **/boot**  | 启动加载程序和内核文件                               |
| **/dev**   | 设备文件（硬盘、USB、终端等）                        |
| **/etc**   | 系统配置文件                                         |
| **/home**  | 普通用户的家目录                                     |
| **/lib**   | 系统库文件（32位系统）                               |
| **/lib64** | 64位系统库文件                                       |
| **/media** | 可移动媒体挂载点（USB、光盘等）                      |
| **/mnt**   | 临时文件系统挂载点                                   |
| **/opt**   | 可选应用软件包                                       |
| **/proc**  | 虚拟文件系统，提供进程和内核信息                     |
| **/root**  | root用户的家目录                                     |
| **/run**   | 运行时的变量数据（较新系统）                         |
| **/sbin**  | 系统管理命令二进制文件（通常需要root权限）           |
| **/srv**   | 服务相关数据                                         |
| **/sys**   | 系统虚拟文件系统，硬件设备信息                       |
| **/tmp**   | 临时文件                                             |
| **/usr**   | 用户程序和数据（二级目录结构）                       |
| **/var**   | 可变数据（日志、缓存、邮件等）                       |

# **/boot**

`/boot`分区是Linux启动过程的核心，虽然现代系统使其重要性有所降低，但理解其结构和功能对于系统管理、故障排除和优化仍然至关重要。无论是否使用独立分区，`/boot`目录的内容都是系统正常启动的基础。

# /dev

## 1. **Loop 设备 (loop0, loop1, loop2...)**

### 功能：

- **虚拟块设备**，用于将普通文件模拟成块设备
- 常用于挂载磁盘镜像文件（ISO、IMG 等）

### 常见用途：

bash

```
# 将 ISO 文件挂载为块设备
sudo mount -o loop ubuntu.iso /mnt

# 创建虚拟磁盘
dd if=/dev/zero of=disk.img bs=1M count=100
sudo losetup /dev/loop0 disk.img
sudo mkfs.ext4 /dev/loop0
```



### 工作原理：

- 内核模块 `loop` 提供这些设备
- 数量可以动态增加（通过 `modprobe loop max_loop=10`）

## 2. **NBD 设备 (nbd0, nbd1...)**

### 功能：

- **Network Block Device** - 网络块设备
- 允许通过网络访问远程块设备

### 常见用途：

bash

```
# 服务器端导出块设备
nbd-server 1234 /dev/sdb1

# 客户端连接
nbd-client server-ip 1234 /dev/nbd0
sudo mount /dev/nbd0 /mnt
```



## 3. **TTY 设备 (tty0, tty1...)**

### 功能：

- **Teletype** - 终端设备
- 提供命令行界面

### 分类：

- **虚拟控制台**：tty1-tty63（Ctrl+Alt+F1-F7 切换）
- **串行终端**：ttyS0（COM1）、ttyUSB0（USB 串口）
- **伪终端**：pts/0、pts/1（SSH/X终端等）
- **当前终端**：tty（当前会话的终端）

## 4. **其他常见设备文件**

### a) 块设备：

- **sdX**：SCSI/SATA/USB 磁盘（sda, sdb...）
- **hdX**：旧 IDE 磁盘（hda, hdb...）
- **nvmeXnY**：NVMe SSD
- **mmcblkX**：SD/MMC 卡

### b) 字符设备：

- **null**：数据黑洞（写入消失，读取返回 EOF）
- **zero**：无限零字节源
- **random/urandom**：随机数生成器
- **fb0**：帧缓冲设备（图形显示）
- **dri/card0**：Direct Rendering 设备（显卡）
- **input/eventX**：输入设备（键盘、鼠标）

### c) 特殊用途：

- **pts/**：伪终端从设备（用于 SSH、终端模拟器）
- **shm/**：共享内存
- **fd/**：文件描述符

## 5. **设备类型区分**

bash

```
# 查看设备类型
ls -l /dev/loop0
# brw-rw----  表示块设备（b开头）

ls -l /dev/tty0
# crw-rw----  表示字符设备（c开头）

# 查看所有loop设备
ls /sys/block/loop*
```
