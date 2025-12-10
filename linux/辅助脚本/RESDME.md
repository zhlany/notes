# Linux 系统工具脚本集合

本仓库包含两个实用的Linux系统工具脚本：`help.sh`和`resource_monitor.sh`，旨在帮助用户更高效地管理和监控系统资源。

## help.sh - Shell命令助手

### 功能简介
`help.sh`是一个交互式Shell命令助手，为常用的Linux命令提供详细的用法说明和示例。它通过彩色输出使信息更易读，并支持多种常用命令的快速查询。

### 主要特性
- **全面的命令支持**：覆盖网络、文件操作、系统管理等多个类别的常用命令
- **彩色输出**：使用不同颜色标记命令、示例和重要提示，提高可读性
- **详细用法说明**：每个命令都包含基本用法、常用选项和实际示例
- **实用建议**：提供命令使用的最佳实践和技巧

### 支持的命令类别
- **网络相关命令**：`ip`、`ping`、`netstat`、`ss`、`curl`、`wget`等
- **文件操作命令**：`ls`、`cd`、`pwd`、`mkdir`、`rm`、`cp`、`mv`等
- **文本处理命令**：`find`、`grep`、`cat`、`less`、`head`等

### 使用方法
1. 直接运行脚本：
   ```bash
   ./help.sh
   ```

2. 设置别名（推荐）：
   ```bash
   # 编辑 ~/.bashrc 文件，添加以下行
   alias help='/path/to/help.sh'
   
   # 使配置生效
   source ~/.bashrc
   ```

3. 创建软链接：
   ```bash
   ln -s /path/to/help.sh ~/bin/help
   ```

### 示例输出
运行脚本后，用户可以输入命令名称（如`ls`、`grep`等），脚本会显示该命令的详细用法、常用选项和实际示例，帮助用户快速掌握命令的使用方法。

## resource_monitor.sh - 系统资源监控工具

### 功能简介
`resource_monitor.sh`是一个全面的Linux系统资源监控脚本，能够实时监控系统的各项资源使用情况，包括CPU、内存、磁盘I/O、网络带宽等。脚本支持多种监控选项，并会自动安装所需的工具包。

### 主要特性
- **多维度监控**：支持CPU、内存、磁盘I/O、网络、连接状态、进程等多个方面的监控
- **自动工具安装**：检测系统环境并自动安装所需的监控工具
- **灵活的监控选项**：可选择监控特定项目或全部项目
- **可配置刷新间隔**：支持自定义数据刷新间隔
- **日志记录**：将监控数据保存到日志文件，便于后续分析

### 监控项目
- **CPU监控**：显示CPU使用率、负载情况、核心使用状态等
- **内存监控**：显示内存使用量、交换空间使用情况等
- **磁盘I/O监控**：显示磁盘读写速度、I/O操作统计等
- **网络监控**：显示网络带宽使用、数据包统计等
- **连接状态监控**：显示网络连接数、连接状态分布等
- **进程监控**：显示进程和线程数量、资源占用情况等

### 使用方法

1. 基本用法（监控所有项目，默认5秒刷新）：
   ```bash
   ./resource_monitor.sh
   ```

2. 监控特定项目：
   ```bash
   # 监控CPU使用情况
   ./resource_monitor.sh cpu
   
   # 监控CPU和磁盘I/O，每10秒刷新
   ./resource_monitor.sh cpu io 10
   ```

3. 查看帮助信息：
   ```bash
   ./resource_monitor.sh --help
   ```

4. 查看特定监控项目的基础命令：
   ```bash
   # 查看CPU监控基础命令
   ./resource_monitor.sh -h cpu
   
   # 查看内存监控基础命令
   ./resource_monitor.sh -h memory 或 ./resource_monitor.sh -h mem
   
   # 查看磁盘I/O监控基础命令
   ./resource_monitor.sh -h io 或 ./resource_monitor.sh -h disk
   
   # 查看网络监控基础命令
   ./resource_monitor.sh -h network 或 ./resource_monitor.sh -h net
   
   # 查看网络连接监控基础命令
   ./resource_monitor.sh -h connections 或 ./resource_monitor.sh -h conn
   
   # 查看进程监控基础命令
   ./resource_monitor.sh -h process 或 ./resource_monitor.sh -h proc
   
   # 查看端口监控基础命令
   ./resource_monitor.sh -h port
   ```

### 监控数据输出
脚本会在`./monitor_logs`目录下创建日志文件，记录所有监控数据。日志文件命名格式为`resource_monitor.log`，包含时间戳和详细的监控数据。

### 支持的包管理器
脚本会自动检测系统使用的包管理器，并支持以下包管理器的工具安装：
- apt-get（Debian/Ubuntu）
- yum（CentOS/RHEL）
- dnf（Fedora）
- pacman（Arch Linux）
- zypper（openSUSE）

### 自动安装的工具
根据监控需求，脚本会自动安装以下工具：
- sysstat（包含mpstat和iostat）
- dstat
- iftop
- net-tools（包含netstat）
- iproute2/iproute（包含ss）
- lsof
- bc

## 总结
这两个脚本相辅相成，`help.sh`帮助用户快速学习和掌握Linux命令，而`resource_monitor.sh`则提供了强大的系统资源监控能力。无论是日常系统管理还是故障排查，这些工具都能提供有力的支持。

## 许可证
本项目采用开源许可证，详见LICENSE文件。