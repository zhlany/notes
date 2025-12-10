#!/bin/bash

# Linux资源监控脚本
# 功能：监控CPU、RAM、I/O、网络带宽、数据包、网络链接状态、系统整体与进程数、运行中的进程和线程数等

# 设置输出文件目录
OUTPUT_DIR="./logs"
mkdir -p "$OUTPUT_DIR"

# 获取当前时间戳
TIMESTAMP=$(date +"%Y%m%d_%H%M%S")
LOG_FILE="$OUTPUT_DIR/monitor.log"

# 函数：检查并安装工具包
check_and_install_tools() {
    print_title "检查并安装所需工具包"
    
    # 检查包管理器
    PKG_MANAGER=""
    if command -v apt-get &> /dev/null; then
        PKG_MANAGER="apt-get"
    elif command -v yum &> /dev/null; then
        PKG_MANAGER="yum"
    elif command -v dnf &> /dev/null; then
        PKG_MANAGER="dnf"
    elif command -v pacman &> /dev/null; then
        PKG_MANAGER="pacman"
    elif command -v zypper &> /dev/null; then
        PKG_MANAGER="zypper"
    else
        print_warning "未找到支持的包管理器，跳过自动安装工具包"
        return
    fi
    
    print_info "检测到包管理器: $PKG_MANAGER"
    
    # 需要检查的工具列表
    TOOLS=("mpstat" "iostat" "dstat" "iftop" "netstat" "ss" "lsof" "bc")
    MISSING_TOOLS=()
    
    # 检查哪些工具缺失
    for tool in "${TOOLS[@]}"; do
        if ! command -v "$tool" &> /dev/null; then
            MISSING_TOOLS+=("$tool")
        fi
    done
    
    # 如果没有缺失的工具，则退出
    if [ ${#MISSING_TOOLS[@]} -eq 0 ]; then
        print_info "所有必需的工具包已安装"
        return
    fi
    
    # 显示缺失的工具
    print_info "以下工具包缺失: ${MISSING_TOOLS[*]}"
    
    # 尝试安装缺失的工具
    print_info "尝试安装缺失的工具包..."
    
    # 根据不同的包管理器安装不同的包
    case $PKG_MANAGER in
        "apt-get")
            # 更新包列表
            print_info "更新包列表..."
            if sudo apt-get update -qq; then
                print_info "包列表更新成功"
            else
                print_error "包列表更新失败，跳过工具包安装"
                return
            fi
            
            # 安装sysstat包（包含mpstat和iostat）
            if [[ " ${MISSING_TOOLS[*]} " =~ " mpstat " ]] || [[ " ${MISSING_TOOLS[*]} " =~ " iostat " ]]; then
                print_info "安装sysstat包..."
                sudo apt-get install -y sysstat || print_warning "安装sysstat失败"
            fi
            
            # 安装dstat
            if [[ " ${MISSING_TOOLS[*]} " =~ " dstat " ]]; then
                print_info "安装dstat包..."
                sudo apt-get install -y dstat || print_warning "安装dstat失败"
            fi
            
            # 安装iftop
            if [[ " ${MISSING_TOOLS[*]} " =~ " iftop " ]]; then
                print_info "安装iftop包..."
                sudo apt-get install -y iftop || print_warning "安装iftop失败"
            fi
            
            # 安装net-tools（包含netstat）
            if [[ " ${MISSING_TOOLS[*]} " =~ " netstat " ]]; then
                print_info "安装net-tools包..."
                sudo apt-get install -y net-tools || print_warning "安装net-tools失败"
            fi
            
            # 安装iproute2（包含ss）
            if [[ " ${MISSING_TOOLS[*]} " =~ " ss " ]]; then
                print_info "安装iproute2包..."
                sudo apt-get install -y iproute2 || print_warning "安装iproute2失败"
            fi
            
            # 安装lsof
            if [[ " ${MISSING_TOOLS[*]} " =~ " lsof " ]]; then
                print_info "安装lsof包..."
                sudo apt-get install -y lsof || print_warning "安装lsof失败"
            fi
            
            # 安装bc
            if [[ " ${MISSING_TOOLS[*]} " =~ " bc " ]]; then
                print_info "安装bc包..."
                sudo apt-get install -y bc || print_warning "安装bc失败"
            fi
            ;;
            
        "yum")
            # 安装sysstat包（包含mpstat和iostat）
            if [[ " ${MISSING_TOOLS[*]} " =~ " mpstat " ]] || [[ " ${MISSING_TOOLS[*]} " =~ " iostat " ]]; then
                print_info "安装sysstat包..."
                sudo yum install -y sysstat || print_warning "安装sysstat失败"
            fi
            
            # 安装dstat
            if [[ " ${MISSING_TOOLS[*]} " =~ " dstat " ]]; then
                print_info "安装dstat包..."
                sudo yum install -y dstat || print_warning "安装dstat失败"
            fi
           
            # 安装iftop
            if [[ " ${MISSING_TOOLS[*]} " =~ " iftop " ]]; then
                print_info "安装iftop包..."
                sudo apt-get install -y iftop || print_warning "安装iftop失败"
            fi
            
            # 安装net-tools（包含netstat）
            if [[ " ${MISSING_TOOLS[*]} " =~ " netstat " ]]; then
                print_info "安装net-tools包..."
                sudo apt-get install -y net-tools || print_warning "安装net-tools失败"
            fi
            
            # 安装iproute2（包含ss）
            if [[ " ${MISSING_TOOLS[*]} " =~ " ss " ]]; then
                print_info "安装iproute2包..."
                sudo apt-get install -y iproute2 || print_warning "安装iproute2失败"
            fi
            
            # 安装lsof
            if [[ " ${MISSING_TOOLS[*]} " =~ " lsof " ]]; then
                print_info "安装lsof包..."
                sudo apt-get install -y lsof || print_warning "安装lsof失败"
            fi
            
            # 安装bc
            if [[ " ${MISSING_TOOLS[*]} " =~ " bc " ]]; then
                print_info "安装bc包..."
                sudo apt-get install -y bc || print_warning "安装bc失败"
            fi
            ;;
            
        "yum")
            # 安装sysstat包（包含mpstat和iostat）
            if [[ " ${MISSING_TOOLS[*]} " =~ " mpstat " ]] || [[ " ${MISSING_TOOLS[*]} " =~ " iostat " ]]; then
                print_info "安装sysstat包..."
                sudo yum install -y sysstat || print_warning "安装sysstat失败"
            fi
            
            # 安装dstat
            if [[ " ${MISSING_TOOLS[*]} " =~ " dstat " ]]; then
                print_info "安装dstat包..."
                sudo yum install -y dstat || print_warning "安装dstat失败"
            fi
            
            # 安装iftop
            if [[ " ${MISSING_TOOLS[*]} " =~ " iftop " ]]; then
                print_info "安装iftop包..."
                sudo yum install -y iftop || print_warning "安装iftop失败"
            fi
            
            # 安装net-tools（包含netstat）
            if [[ " ${MISSING_TOOLS[*]} " =~ " netstat " ]]; then
                print_info "安装net-tools包..."
                sudo yum install -y net-tools || print_warning "安装net-tools失败"
            fi
            
            # 安装iproute（包含ss）
            if [[ " ${MISSING_TOOLS[*]} " =~ " ss " ]]; then
                print_info "安装iproute包..."
                sudo yum install -y iproute || print_warning "安装iproute失败"
            fi
            
            # 安装lsof
            if [[ " ${MISSING_TOOLS[*]} " =~ " lsof " ]]; then
                print_info "安装lsof包..."
                sudo yum install -y lsof || print_warning "安装lsof失败"
            fi
            
            # 安装bc
            if [[ " ${MISSING_TOOLS[*]} " =~ " bc " ]]; then
                print_info "安装bc包..."
                sudo yum install -y bc || print_warning "安装bc失败"
            fi
            ;;
            
        "dnf")
            # 安装sysstat包（包含mpstat和iostat）
            if [[ " ${MISSING_TOOLS[*]} " =~ " mpstat " ]] || [[ " ${MISSING_TOOLS[*]} " =~ " iostat " ]]; then
                print_info "安装sysstat包..."
                sudo dnf install -y sysstat || print_warning "安装sysstat失败"
            fi
            
            # 安装dstat
            if [[ " ${MISSING_TOOLS[*]} " =~ " dstat " ]]; then
                print_info "安装dstat包..."
                sudo dnf install -y dstat || print_warning "安装dstat失败"
            fi
            
            # 安装iftop
            if [[ " ${MISSING_TOOLS[*]} " =~ " iftop " ]]; then
                print_info "安装iftop包..."
                sudo dnf install -y iftop || print_warning "安装iftop失败"
            fi
            
            # 安装net-tools（包含netstat）
            if [[ " ${MISSING_TOOLS[*]} " =~ " netstat " ]]; then
                print_info "安装net-tools包..."
                sudo dnf install -y net-tools || print_warning "安装net-tools失败"
            fi
            
            # 安装iproute（包含ss）
           
            if [[ " ${MISSING_TOOLS[*]} " =~ " ss " ]]; then
                print_info "安装iproute包..."
                sudo dnf install -y iproute || print_warning "安装iproute失败"
            fi
            
            # 安装lsof
            if [[ " ${MISSING_TOOLS[*]} " =~ " lsof " ]]; then
                print_info "安装lsof包..."
                sudo dnf install -y lsof || print_warning "安装lsof失败"
            fi
            
            # 安装bc
            if [[ " ${MISSING_TOOLS[*]} " =~ " bc " ]]; then
                print_info "安装bc包..."
                sudo dnf install -y bc || print_warning "安装bc失败"
            fi
            ;;
            
        "pacman")
            # 安装sysstat包（包含mpstat和iostat）
            if [[ " ${MISSING_TOOLS[*]} " =~ " mpstat " ]] || [[ " ${MISSING_TOOLS[*]} " =~ " iostat " ]]; then
                print_info "安装sysstat包..."
                sudo pacman -S --noconfirm sysstat || print_warning "安装sysstat失败"
            fi
            
            # 安装dstat
            if [[ " ${MISSING_TOOLS[*]} " =~ " dstat " ]]; then
                print_info "安装dstat包..."
                sudo pacman -S --noconfirm dstat || print_warning "安装dstat失败"
            fi
            
            # 安装iftop
            if [[ " ${MISSING_TOOLS[*]} " =~ " iftop " ]]; then
                print_info "安装iftop包..."
                sudo pacman -S --noconfirm iftop || print_warning "安装iftop失败"
            fi
            
            # 安装net-tools（包含netstat）
            if [[ " ${MISSING_TOOLS[*]} " =~ " netstat " ]]; then
                print_info "安装net-tools包..."
                sudo pacman -S --noconfirm net-tools || print_warning "安装net-tools失败"
            fi
            
            # 安装iproute2（包含ss）
            if [[ " ${MISSING_TOOLS[*]} " =~ " ss " ]]; then
                print_info "安装iproute2包..."
                sudo pacman -S --noconfirm iproute2 || print_warning "安装iproute2失败"
            fi
            
            # 安装lsof
            if [[ " ${MISSING_TOOLS[*]} " =~ " lsof " ]]; then
                print_info "安装lsof包..."
                sudo pacman -S --noconfirm lsof || print_warning "安装lsof失败"
            fi
            
            # 安装bc
            if [[ " ${MISSING_TOOLS[*]} " =~ " bc " ]]; then
                print_info "安装bc包..."
                sudo pacman -S --noconfirm bc || print_warning "安装bc失败"
            fi
            ;;
            
        "zypper")
            # 安装sysstat包（包含mpstat和iostat）
            if [[ " ${MISSING_TOOLS[*]} " =~ " mpstat " ]] || [[ " ${MISSING_TOOLS[*]} " =~ " iostat " ]]; then
                print_info "安装sysstat包..."
                sudo zypper install -y sysstat || print_warning "安装sysstat失败"
            fi
            
            # 安装dstat
            if [[ " ${MISSING_TOOLS[*]} " =~ " dstat " ]]; then
                print_info "安装dstat包..."
                sudo zypper install -y dstat || print_warning "安装dstat失败"
            fi
            
            # 安装iftop
            if [[ " ${MISSING_TOOLS[*]} " =~ " iftop " ]]; then
                print_info "安装iftop包..."
                sudo zypper install -y iftop || print_warning "安装iftop失败"
            fi
            
            # 安装net-tools（包含netstat）
            if [[ " ${MISSING_TOOLS[*]} " =~ " netstat " ]]; then
                print_info "安装net-tools包..."
                sudo zypper install -y net-tools || print_warning "安装net-tools失败"
            fi
            
            # 安装iproute2（包含ss）
            if [[ " ${MISSING_TOOLS[*]} " =~ " ss " ]]; then
                print_info "安装iproute2包..."
                sudo zypper install -y iproute2 || print_warning "安装iproute2失败"
            fi
            
            # 安装lsof
            if [[ " ${MISSING_TOOLS[*]} " =~ " lsof " ]]; then
                print_info "安装lsof包..."
                sudo zypper install -y lsof || print_warning "安装lsof失败"
            fi
            
            # 安装bc
            if [[ " ${MISSING_TOOLS[*]} " =~ " bc " ]]; then
                print_info "安装bc包..."
                sudo zypper install -y bc || print_warning "安装bc失败"
            fi
            ;;
    esac
    
    print_info "工具包安装完成"
}

# 默认刷新间隔（秒）
INTERVAL=-1

# 监控项目标志
MONITOR_CPU=false
MONITOR_MEMORY=false
MONITOR_DISK=false
MONITOR_NETWORK=false
MONITOR_CONNECTIONS=false
MONITOR_PROCESS=false

# 函数：显示帮助信息
show_help() {
    echo "Linux资源监控脚本"
    echo ""
    echo "用法: $0 [选项] [监控项目] [刷新间隔]"
    echo ""
    echo "选项:"
    echo "  -h, --help        显示此帮助信息"
    echo "  -h cpu            显示CPU相关监控基础命令"
    echo "  -h mem, memory    显示内存相关监控基础命令"
    echo "  -h io, disk       显示磁盘I/O相关监控基础命令"
    echo "  -h network, net   显示网络相关监控基础命令"
    echo "  -h conn, connections 显示网络连接相关监控基础命令"
    echo "  -h proc, process  显示进程相关监控基础命令"
    echo "  -h port           显示端口相关监控基础命令"
    echo ""
    echo "监控项目 (可多选):"
    echo "  cpu, c            监控CPU使用情况"
    echo "  memory, mem, m    监控内存使用情况"
    echo "  disk, io, d       监控磁盘I/O情况"
    echo "  network, net, n   监控网络带宽和数据包"
    echo "  connections, conn 监控网络连接状态"
    echo "  process, proc, p  监控进程和线程信息"
    echo ""
    echo "刷新间隔:"
    echo "  数字              刷新间隔秒数 (默认: 5秒)"
    echo ""
    echo "示例:"
    echo "  $0 cpu 5          监控CPU信息，每5秒刷新"
    echo "  $0 cpu io 10      监控CPU和磁盘I/O，每10秒刷新"
    echo "  $0                监控所有项目，每5秒刷新"
    echo ""
}

# 函数：显示CPU相关基础命令介绍
show_cpu_commands() {
    echo "CPU相关监控基础命令介绍"
    echo ""
    echo "1. 查看CPU使用率:"
    echo "   top -bn1 | grep 'Cpu(s)'"
    echo "   # 显示当前CPU使用率，包括用户态、系统态、空闲等"
    echo ""
    echo "2. 查看CPU核心数:"
    echo "   nproc"
    echo "   # 显示逻辑CPU核心数量"
    echo ""
    echo "3. 查看CPU详细信息:"
    echo "   lscpu"
    echo "   # 显示CPU架构、型号、核心数、线程数等详细信息"
    echo ""
    echo "4. 查看每个CPU核心的使用情况:"
    echo "   mpstat -P ALL 1 1"
    echo "   # 显示每个CPU核心的使用率，每秒更新一次，共2次"
    echo ""
    echo "5. 查看系统负载:"
    echo "   uptime"
    echo "   # 显示系统负载平均值，包括1分钟、5分钟、15分钟的负载"
    echo ""
    echo "6. 查看CPU频率:"
    echo "   cpufreq-info"
    echo "   # 显示CPU当前频率和可调整范围"
    echo ""
    echo "7. 查看进程CPU使用情况:"
    echo "   ps -eo pid,ppid,user,%cpu,%mem,cmd --sort=-%cpu | head -11"
    echo "   # 显示CPU使用率最高的10个进程"
    echo ""
}

# 函数：显示磁盘I/O相关基础命令介绍
show_io_commands() {
    echo "磁盘I/O相关监控基础命令介绍"
    echo ""
    echo "1. 查看磁盘空间使用情况:"
    echo "   df -h"
    echo "   # 以人类可读格式显示各分区的空间使用情况"
    echo ""
    echo "2. 查看磁盘I/O统计:"
    echo "   iostat -d -x 1 2"
    echo "   # 显示磁盘I/O统计信息，包括每秒读写操作数、吞吐量等"
    echo ""
    echo "3. 查看磁盘读写速度:"
    echo "   dstat -d 1 3"
    echo "   # 显示磁盘读写速度，每秒更新一次，共3次"
    echo ""
    echo "4. 查看磁盘分区信息:"
    echo "   fdisk -l"
    echo "   # 显示所有磁盘分区的详细信息"
    echo ""
    echo "5. 查看文件系统类型:"
    echo "   lsblk -f"
    echo "   # 显示块设备信息及其文件系统类型"
    echo ""
    echo "6. 查看inode使用情况:"
    echo "   df -i"
    echo "   # 显示各分区的inode使用情况"
    echo ""
    echo "7. 查看磁盘性能:"
    echo "   hdparm -Tt /dev/sda"
    echo "   # 测试磁盘缓存和直接读取性能"
    echo ""
}

# 函数：显示网络相关基础命令介绍
show_network_commands() {
    echo "网络相关监控基础命令介绍"
    echo ""
    echo "1. 查看网络接口信息:"
    echo "   ip addr show"
    echo "   # 显示所有网络接口的IP地址、MAC地址等信息"
    echo ""
    echo "2. 查看网络带宽使用情况:"
    echo "   iftop -t -s 5 -n -P"
    echo "   # 显示网络带宽使用情况，运行5秒收集数据"
    echo ""
    echo "3. 查看网络接口统计数据:"
    echo "   cat /proc/net/dev"
    echo "   # 显示网络接口的收发包数量、字节数等统计信息"
    echo ""
    echo "4. 查看网络数据包统计:"
    echo "   netstat -s"
    echo "   # 显示网络协议的统计信息，包括IP、ICMP、TCP、UDP等"
    echo ""
    echo "5. 查看路由表:"
    echo "   ip route show"
    echo "   # 显示系统路由表信息"
    echo ""
    echo "6. 查看网络连接:"
    echo "   ss -tuln"
    echo "   # 显示所有TCP和UDP的监听连接"
    echo ""
    echo "7. 查看网络丢包情况:"
    echo "   ping -c 4 google.com"
    echo "   # 发送4个ICMP包测试网络连通性和丢包率"
    echo ""
}

# 函数：显示端口相关基础命令介绍
show_port_commands() {
    echo "端口相关监控基础命令介绍"
    echo ""
    echo "1. 查看所有监听端口:"
    echo "   ss -tlnp"
    echo "   # 显示所有TCP监听端口及其关联的进程"
    echo ""
    echo "2. 查看已建立的连接:"
    echo "   ss -tnp | grep ESTAB"
    echo "   # 显示所有已建立的TCP连接及其关联的进程"
    echo ""
    echo "3. 查看特定端口状态:"
    echo "   netstat -tulnp | grep :80"
    echo "   # 查看80端口的状态及其关联的进程"
    echo ""
    echo "4. 查看端口使用情况:"
    echo "   lsof -i :80"
    echo "   # 查看使用80端口的进程详情"
    echo ""
    echo "5. 查看所有端口连接数:"
    echo "   netstat -an | grep :80 | wc -l"
    echo "   # 统计80端口的连接数"
    echo ""
    echo "6. 查看UDP端口:"
    echo "   ss -ulnp"
    echo "   # 显示所有UDP监听端口及其关联的进程"
    echo ""
    echo "7. 查看端口流量:"
    echo "   tcpdump -i eth0 port 80"
    echo "   # 捕获通过80端口的网络流量（需要root权限）"
    echo ""
}

# 函数：显示内存相关基础命令介绍
show_memory_commands() {
    echo "内存相关监控基础命令介绍"
    echo ""
    echo "1. 查看内存使用情况:"
    echo "   free -h"
    echo "   # 以人类可读格式显示内存使用情况"
    echo ""
    echo "2. 查看内存详细信息:"
    echo "   cat /proc/meminfo"
    echo "   # 显示详细的内存使用信息，包括缓冲区、缓存等"
    echo ""
    echo "3. 查看进程内存使用情况:"
    echo "   ps -eo pid,ppid,user,%cpu,%mem,cmd --sort=-%mem | head -11"
    echo "   # 显示内存使用率最高的10个进程"
    echo ""
    echo "4. 查看内存映射:"
    echo "   pmap -x <PID>"
    echo "   # 显示指定进程的详细内存映射信息"
    echo ""
    echo "5. 查看内存使用趋势:"
    echo "   vmstat 1 10"
    echo "   # 每秒显示一次系统内存使用情况，共10次"
    echo ""
    echo "6. 查看交换分区使用情况:"
    echo "   swapon -s"
    echo "   # 显示交换分区的使用情况"
    echo ""
    echo "7. 查看内存使用率最高的进程:"
    echo "   top -o %MEM"
    echo "   # 按内存使用率排序显示进程"
    echo ""
}

# 函数：显示网络连接相关基础命令介绍
show_connections_commands() {
    echo "网络连接相关监控基础命令介绍"
    echo ""
    echo "1. 查看所有网络连接:"
    echo "   ss -tuln"
    echo "   # 显示所有TCP和UDP的监听连接"
    echo ""
    echo "2. 查看已建立的连接:"
    echo "   ss -tnp | grep ESTAB"
    echo "   # 显示所有已建立的TCP连接及其关联的进程"
    echo ""
    echo "3. 查看连接状态统计:"
    echo "   ss -s"
    echo "   # 显示各种状态的连接数量统计"
    echo ""
    echo "4. 查看连接数最多的进程:"
    echo "   ss -tp | awk '{print $7}' | cut -d'\"' -f2 | sort | uniq -c | sort -nr | head -10"
    echo "   # 显示连接数最多的10个进程"
    echo ""
    echo "5. 查看TIME_WAIT状态的连接:"
    echo "   ss -an | grep TIME_WAIT"
    echo "   # 显示所有TIME_WAIT状态的连接"
    echo ""
    echo "6. 查看特定端口的连接:"
    echo "   ss -tnp | grep :80"
    echo "   # 显示80端口的所有连接"
    echo ""
    echo "7. 监控连接变化:"
    echo "   watch -n 1 'ss -s'"
    echo "   # 每秒刷新一次连接统计信息"
    echo ""
}

# 函数：显示进程相关基础命令介绍
show_process_commands() {
    echo "进程相关监控基础命令介绍"
    echo ""
    echo "1. 查看所有进程:"
    echo "   ps aux"
    echo "   # 显示所有运行中的进程详细信息"
    echo ""
    echo "2. 查看进程树:"
    echo "   pstree -p"
    echo "   # 以树形结构显示进程及其关系"
    echo ""
    echo "3. 查看系统负载和进程统计:"
    echo "   uptime"
    echo "   # 显示系统负载和运行时间"
    echo ""
    echo "4. 查看CPU使用率最高的进程:"
    echo "   ps -eo pid,ppid,user,%cpu,%mem,cmd --sort=-%cpu | head -11"
    echo "   # 显示CPU使用率最高的10个进程"
    echo ""
    echo "5. 查看特定用户的进程:"
    echo "   ps -u username"
    echo "   # 显示指定用户的所有进程"
    echo ""
    echo "6. 查看线程信息:"
    echo "   ps -eLf"
    echo "   # 显示所有进程的线程信息"
    echo ""
    echo "7. 查看进程打开的文件:"
    echo "   lsof -p <PID>"
    echo "   # 显示指定进程打开的所有文件"
    echo ""
}

# 函数：解析命令行参数
parse_args() {
    # 检查是否请求帮助
    if [[ "$1" == "-h" || "$1" == "--help" ]]; then
        # 检查是否有第二个参数
        if [[ "$2" == "cpu" ]]; then
            show_cpu_commands
            exit 0
        elif [[ "$2" == "mem" ]] || [[ "$2" == "memory" ]]; then
            show_memory_commands
            exit 0
        elif [[ "$2" == "io" ]] || [[ "$2" == "disk" ]]; then
            show_io_commands
            exit 0
        elif [[ "$2" == "network" ]] || [[ "$2" == "net" ]]; then
            show_network_commands
            exit 0
        elif [[ "$2" == "conn" ]] || [[ "$2" == "connections" ]]; then
            show_connections_commands
            exit 0
        elif [[ "$2" == "proc" ]] || [[ "$2" == "process" ]]; then
            show_process_commands
            exit 0
        elif [[ "$2" == "port" ]]; then
            show_port_commands
            exit 0
        else
            show_help
            exit 0
        fi
    fi
    
    # 如果没有提供参数，默认监控所有项目
    if [ $# -eq 0 ]; then
        MONITOR_CPU=true
        MONITOR_MEMORY=true
        MONITOR_DISK=true
        MONITOR_NETWORK=true
        MONITOR_CONNECTIONS=true
        MONITOR_PROCESS=true
        return
    fi
    
    # 解析监控项目
    while [ $# -gt 0 ]; do
        case "$1" in
            cpu|c)
                MONITOR_CPU=true
                ;;
            memory|mem|m)
                MONITOR_MEMORY=true
                ;;
            disk|io|d)
                MONITOR_DISK=true
                ;;
            network|net|n)
                MONITOR_NETWORK=true
                ;;
            connections|conn)
                MONITOR_CONNECTIONS=true
                ;;
            process|proc|p)
                MONITOR_PROCESS=true
                ;;
            *[0-9]*)
                # 检查是否为数字，如果是则作为刷新间隔
                if [[ "$1" =~ ^[0-9]+$ ]]; then
                    INTERVAL=$1
                fi
                ;;
        esac
        shift
    done
    
    # 如果没有指定任何监控项目，默认监控所有
    if [ "$MONITOR_CPU" = false ] && [ "$MONITOR_MEMORY" = false ] && \
       [ "$MONITOR_DISK" = false ] && [ "$MONITOR_NETWORK" = false ] && \
       [ "$MONITOR_CONNECTIONS" = false ] && [ "$MONITOR_PROCESS" = false ]; then
        MONITOR_CPU=true
        MONITOR_MEMORY=true
        MONITOR_DISK=true
        MONITOR_NETWORK=true
        MONITOR_CONNECTIONS=true
        MONITOR_PROCESS=true
    fi
}

# 颜色定义
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# 函数：打印带颜色的标题
print_title() {
    echo -e "${BLUE}========================================${NC}"
    echo -e "${BLUE}$1${NC}"
    echo -e "${BLUE}========================================${NC}"
    echo "========================================" >> "$LOG_FILE"
    echo "$1" >> "$LOG_FILE"
    echo "========================================" >> "$LOG_FILE"
}

# 函数：打印带颜色的信息
print_info() {
    echo -e "${GREEN}[INFO]${NC} $1"
    echo "[INFO] $1" >> "$LOG_FILE"
}

# 函数：打印警告信息
print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
    echo "[WARNING] $1" >> "$LOG_FILE"
}

# 函数：打印错误信息
print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
    echo "[ERROR] $1" >> "$LOG_FILE"
}

# 函数：获取CPU使用率
get_cpu_usage() {
    print_title "CPU使用情况"
    
    # 获取CPU使用率
    CPU_USAGE=$(top -bn1 | grep "Cpu(s)" | sed "s/.*, *\([0-9.]*\)%* id.*/\1/" | awk '{print 100 - $1}')
    print_info "当前CPU使用率: $CPU_USAGE%"
    
    # 获取CPU核心数
    CPU_CORES=$(nproc)
    print_info "CPU核心数: $CPU_CORES"
    
    # 获取CPU负载平均值
    LOAD_AVG=$(uptime | awk -F'load average:' '{print $2}')
    print_info "系统负载平均值:$LOAD_AVG"
    
    # 获取每个核心的详细使用情况
    print_info "各CPU核心使用情况:"
    mpstat -P ALL 1 1 | grep -E "CPU|all" | tee -a "$LOG_FILE"
}

# 函数：获取内存使用情况
get_memory_usage() {
    print_title "内存使用情况"
    
    # 获取内存使用情况
    free -h | tee -a "$LOG_FILE"
    
    # 获取更详细的内存信息
    MEM_INFO=$(free -m | grep Mem)
    TOTAL_MEM=$(echo "$MEM_INFO" | awk '{print $2}')
    USED_MEM=$(echo "$MEM_INFO" | awk '{print $3}')
    FREE_MEM=$(echo "$MEM_INFO" | awk '{print $4}')
    BUFF_CACHE=$(echo "$MEM_INFO" | awk '{print $6}')
    
    MEM_USAGE_PERCENT=$(awk "BEGIN {printf \"%.2f\", ($USED_MEM/$TOTAL_MEM)*100}")
    
    print_info "总内存: ${TOTAL_MEM}MB"
    print_info "已使用内存: ${USED_MEM}MB (${MEM_USAGE_PERCENT}%)"
    print_info "空闲内存: ${FREE_MEM}MB"
    print_info "缓冲/缓存: ${BUFF_CACHE}MB"
    
    # 检查交换分区使用情况
    SWAP_INFO=$(free -m | grep Swap)
    TOTAL_SWAP=$(echo "$SWAP_INFO" | awk '{print $2}')
    USED_SWAP=$(echo "$SWAP_INFO" | awk '{print $3}')
    
    if [ "$TOTAL_SWAP" -gt 0 ]; then
        SWAP_USAGE_PERCENT=$(awk "BEGIN {printf \"%.2f\", ($USED_SWAP/$TOTAL_SWAP)*100}")
        print_info "总交换分区: ${TOTAL_SWAP}MB"
        print_info "已使用交换分区: ${USED_SWAP}MB (${SWAP_USAGE_PERCENT}%)"
        
        if [ "$(echo "$SWAP_USAGE_PERCENT > 80" | bc)" -eq 1 ]; then
            print_warning "交换分区使用率超过80%!"
        fi
    else
        print_info "系统没有配置交换分区"
    fi
}

# 函数：获取磁盘I/O情况
get_disk_io() {
    print_title "磁盘I/O情况"
    
    # 显示磁盘使用情况
    print_info "磁盘空间使用情况:"
    df -h | tee -a "$LOG_FILE"
    
    # 显示I/O统计
    print_info "磁盘I/O统计:"
    if command -v iostat &> /dev/null; then
        iostat -d -x 1 2 | tee -a "$LOG_FILE"
    else
        print_warning "iostat命令不可用，尝试使用/proc/diskstats"
        cat /proc/diskstats | head -10 | tee -a "$LOG_FILE"
    fi
    
    # 显示磁盘读写速度
    print_info "磁盘读写速度:"
    if command -v dstat &> /dev/null; then
        dstat -d 1 3 | tee -a "$LOG_FILE"
    else
        print_warning "dstat命令不可用"
    fi
}

# 函数：获取网络带宽和数据包情况
get_network_stats() {
    print_title "网络统计信息"
    
    # 显示网络接口
    print_info "网络接口信息:"
    ip addr show | tee -a "$LOG_FILE"
    
    # 显示网络带宽使用情况
    print_info "网络带宽使用情况:"
    if command -v iftop &> /dev/null; then
        # iftop需要一段时间来收集数据
        print_info "运行iftop 5秒收集数据..."
        iftop -t -s 5 -n -P | tee -a "$LOG_FILE"
    else
        print_warning "iftop命令不可用，尝试使用/proc/net/dev"
        print_info "网络接口统计数据:"
        cat /proc/net/dev | grep -E "eth|ens|enp|wlan" | tee -a "$LOG_FILE"
    fi
    
    # 显示网络数据包统计
    print_info "网络数据包统计:"
    if command -v netstat &> /dev/null; then
        netstat -s | tee -a "$LOG_FILE"
    else
        print_warning "netstat命令不可用，尝试使用/proc/net/snmp"
        cat /proc/net/snmp | grep -E "Ip|Icmp|Tcp|Udp" | head -20 | tee -a "$LOG_FILE"
    fi
}

# 函数：获取网络连接状态
get_network_connections() {
    print_title "网络连接状态"
    
    # 显示所有网络连接
    print_info "所有网络连接:"
    if command -v ss &> /dev/null; then
        ss -tuln | tee -a "$LOG_FILE"
    else
        netstat -tuln | tee -a "$LOG_FILE"
    fi
    
    # 显示监听的端口
    print_info "监听的端口:"
    if command -v ss &> /dev/null; then
        ss -tlnp | tee -a "$LOG_FILE"
    else
        netstat -tlnp | tee -a "$LOG_FILE"
    fi
    
    # 显示已建立的连接
    print_info "已建立的连接:"
    if command -v ss &> /dev/null; then
        ss -tnp | grep ESTAB | head -20 | tee -a "$LOG_FILE"
    else
        netstat -tnp | grep ESTAB | head -20 | tee -a "$LOG_FILE"
    fi
}

# 函数：获取系统进程和线程信息
get_process_info() {
    print_title "系统进程和线程信息"
    
    # 获取系统总体信息
    print_info "系统总体信息:"
    uptime | tee -a "$LOG_FILE"
    
    # 获取进程总数
    TOTAL_PROCS=$(ps -e | wc -l)
    print_info "系统总进程数: $TOTAL_PROCS"
    
    # 获取运行中的进程数
    RUNNING_PROCS=$(ps r | wc -l)
    print_info "运行中的进程数: $RUNNING_PROCS"
    
    # 获取线程总数
    if [ -d /proc ]; then
        TOTAL_THREADS=$(ls /proc/*/task 2>/dev/null | wc -l)
        print_info "系统总线程数: $TOTAL_THREADS"
    else
        print_warning "无法获取线程总数信息"
    fi
    
    # 获取用户进程数
    print_info "各用户进程数:"
    ps -eo user | sort | uniq -c | sort -nr | head -10 | tee -a "$LOG_FILE"
    
    # 获取CPU使用率最高的进程
    print_info "CPU使用率最高的10个进程:"
    ps -eo pid,ppid,user,%cpu,%mem,cmd --sort=-%cpu | head -11 | tee -a "$LOG_FILE"
    
    # 获取内存使用率最高的进程
    print_info "内存使用率最高的10个进程:"
    ps -eo pid,ppid,user,%cpu,%mem,cmd --sort=-%mem | head -11 | tee -a "$LOG_FILE"
    
    # 获取打开文件描述符最多的进程
    print_info "打开文件描述符最多的10个进程:"
    if command -v lsof &> /dev/null; then
        lsof -n | awk '{print $2}' | sort | uniq -c | sort -nr | head -10 | tee -a "$LOG_FILE"
    else
        print_warning "lsof命令不可用"
    fi
}

# 函数：执行监控
run_monitoring() {
    # 清屏
    clear
    
    # 显示时间戳和监控参数
    echo -e "${BLUE}Linux资源监控脚本 - $(date)${NC}"
    echo -e "${BLUE}监控项目: $MONITOR_ITEMS${NC}"
    
    # 根据刷新间隔显示不同的提示信息
    if [ "$INTERVAL" -eq -1 ]; then
        echo -e "${BLUE}刷新模式: 手动刷新${NC}"
        echo -e "${BLUE}按 Enter 键刷新数据，按 Ctrl+C 退出监控${NC}"
    else
        echo -e "${BLUE}刷新间隔: $INTERVAL 秒${NC}"
        echo -e "${BLUE}按 Ctrl+C 退出监控${NC}"
    fi
    echo ""
    
    # 写入日志文件头部
    echo "Linux资源监控脚本 - $(date)" >> "$LOG_FILE"
    echo "监控项目: $MONITOR_ITEMS" >> "$LOG_FILE"
    echo "刷新间隔: $INTERVAL 秒" >> "$LOG_FILE"
    echo "" >> "$LOG_FILE"
    
    # 根据设置的标志调用相应的监控函数
    if [ "$MONITOR_CPU" = true ]; then
        get_cpu_usage
        echo "" | tee -a "$LOG_FILE"
    fi
    
    if [ "$MONITOR_MEMORY" = true ]; then
        get_memory_usage
        echo "" | tee -a "$LOG_FILE"
    fi
    
    if [ "$MONITOR_DISK" = true ]; then
        get_disk_io
        echo "" | tee -a "$LOG_FILE"
    fi
    
    if [ "$MONITOR_NETWORK" = true ]; then
        get_network_stats
        echo "" | tee -a "$LOG_FILE"
    fi
    
    if [ "$MONITOR_CONNECTIONS" = true ]; then
        get_network_connections
        echo "" | tee -a "$LOG_FILE"
    fi
    
    if [ "$MONITOR_PROCESS" = true ]; then
        get_process_info
        echo "" | tee -a "$LOG_FILE"
    fi
    
    print_title "一轮监控完成"
    print_info "监控日志已保存到: $LOG_FILE"
}

# 主函数
main() {
    # 解析命令行参数
    parse_args "$@"
    
    # 检查并安装所需工具包
    check_and_install_tools
    echo "" | tee -a "$LOG_FILE"
    
    # 构建监控项目字符串用于显示
    MONITOR_ITEMS=""
    if [ "$MONITOR_CPU" = true ]; then
        MONITOR_ITEMS="${MONITOR_ITEMS}CPU "
    fi
    if [ "$MONITOR_MEMORY" = true ]; then
        MONITOR_ITEMS="${MONITOR_ITEMS}内存 "
    fi
    if [ "$MONITOR_DISK" = true ]; then
        MONITOR_ITEMS="${MONITOR_ITEMS}磁盘I/O "
    fi
    if [ "$MONITOR_NETWORK" = true ]; then
        MONITOR_ITEMS="${MONITOR_ITEMS}网络统计 "
    fi
    if [ "$MONITOR_CONNECTIONS" = true ]; then
        MONITOR_ITEMS="${MONITOR_ITEMS}网络连接 "
    fi
    if [ "$MONITOR_PROCESS" = true ]; then
        MONITOR_ITEMS="${MONITOR_ITEMS}进程信息 "
    fi
    
    # 设置陷阱，在脚本退出时显示消息
    trap 'echo -e "\n${YELLOW}监控已停止${NC}"; exit 0' INT TERM
    
    # 根据刷新间隔决定是手动刷新还是自动刷新
    if [ "$INTERVAL" -eq -1 ]; then
        # 手动刷新模式，等待用户按Enter键
        while true; do
            run_monitoring
            echo -e "${YELLOW}按 Enter 键刷新数据，按 Ctrl+C 退出监控...${NC}"
            read -r  # 等待用户按Enter键
        done
    else
        # 自动刷新模式
        while true; do
            run_monitoring
            sleep $INTERVAL
        done
    fi
}

# 执行主函数
main "$@"
    