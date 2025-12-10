#!/bin/bash

# help.sh - 显示 shell 基础命令的提示帮助
#chmod +x ./help.sh
#echo "alias help='/your_path/help.sh'" >> ~/.bashrc && source ~/.bashrc

# ===== 已实现命令帮助的命令列表 =====
#
# 基础命令 (BASIC_COMMAND_HELP):
# 网络相关: ip, ping, netstat, ss, curl, wget
# 文件操作: ls, cd, pwd, mkdir, rm, cp, mv, find, grep, cat, less, head, tail, awk, cut, wc, vim
# 系统信息: uname, df, du, free, top, ps, kill, history
# 其他常用: tar, zip, ssh, scp, rsync, crontab, alias, which, man, echo, export, date, reboot，set
#
# 应用级命令 (APP_COMMAND_HELP):
# Docker相关: docker, docker-compose, docker-common
# Kubernetes相关: kubectl, kuber, helm
#
# =======================================

# 颜色定义
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

# 基础命令列表
BASIC_CMDS=(
    "ip" "ping" "netstat" "ss" "curl" "wget" "ls" "cd" 
    "pwd" "mkdir" "rm" "cp" "mv" "find" "grep" "cat" 
    "less" "head" "tail" "chmod" "chown" "uname" "df" "du" 
    "free" "top" "ps" "kill" "history" "tar" "zip" "ssh" 
    "scp" "rsync" "crontab" "alias" "which" "man" "echo" 
    "export" "date" "reboot" "set" "awk" "cut" "wc" "vim"
    )

# 应用级命令列表
APP_CMDS=(
    "docker" "docker-compose" "docker-common" "kubectl" "kuber" "helm"
    )

# 基础命令帮助数据库
declare -A BASIC_COMMAND_HELP

# 应用命令帮助数据库
declare -A APP_COMMAND_HELP

# 命令列表缓存
declare -A COMMAND_DESCRIPTIONS

############################################################################################
#                              命令描述缓存
############################################################################################
init_command_cache() {
    # 基础命令描述缓存
    COMMAND_DESCRIPTIONS["ip"]="ip - 显示/操作路由、网络设备、策略路由和隧道"
    COMMAND_DESCRIPTIONS["ping"]="ping - 发送ICMP回显请求到网络主机"
    COMMAND_DESCRIPTIONS["netstat"]="netstat - 显示网络连接、路由表、接口统计等"
    COMMAND_DESCRIPTIONS["ss"]="ss - 显示套接字统计信息，替代netstat"
    COMMAND_DESCRIPTIONS["curl"]="curl - 传输数据URL语法"
    COMMAND_DESCRIPTIONS["wget"]="wget - 从网络下载文件"
    COMMAND_DESCRIPTIONS["ls"]="ls - 列出目录内容"
    COMMAND_DESCRIPTIONS["cd"]="cd - 更改当前工作目录"
    COMMAND_DESCRIPTIONS["pwd"]="pwd - 打印当前工作目录"
    COMMAND_DESCRIPTIONS["mkdir"]="mkdir - 创建目录"
    COMMAND_DESCRIPTIONS["rm"]="rm - 删除文件和目录"
    COMMAND_DESCRIPTIONS["cp"]="cp - 复制文件和目录"
    COMMAND_DESCRIPTIONS["mv"]="mv - 移动或重命名文件和目录"
    COMMAND_DESCRIPTIONS["find"]="find - 搜索目录树中的文件"
    COMMAND_DESCRIPTIONS["grep"]="grep - 搜索文本模式"
    COMMAND_DESCRIPTIONS["cat"]="cat - 连接文件并打印到标准输出"
    COMMAND_DESCRIPTIONS["less"]="less - 浏览文件内容"
    COMMAND_DESCRIPTIONS["head"]="head - 输出文件的开头部分"
    COMMAND_DESCRIPTIONS["tail"]="tail - 输出文件的结尾部分"
    COMMAND_DESCRIPTIONS["chmod"]="chmod - 更改文件权限"
    COMMAND_DESCRIPTIONS["chown"]="chown - 更改文件所有者和组"
    COMMAND_DESCRIPTIONS["uname"]="uname - 显示系统信息"
    COMMAND_DESCRIPTIONS["df"]="df - 显示磁盘空间使用情况"
    COMMAND_DESCRIPTIONS["du"]="du - 估算文件空间使用情况"
    COMMAND_DESCRIPTIONS["free"]="free - 显示内存使用情况"
    COMMAND_DESCRIPTIONS["top"]="top - 显示运行中的进程"
    COMMAND_DESCRIPTIONS["ps"]="ps - 显示当前进程"
    COMMAND_DESCRIPTIONS["kill"]="kill - 终止进程"
    COMMAND_DESCRIPTIONS["history"]="history - 显示命令历史"
    COMMAND_DESCRIPTIONS["tar"]="tar - 归档工具"
    COMMAND_DESCRIPTIONS["zip"]="zip - 压缩和打包文件"
    COMMAND_DESCRIPTIONS["ssh"]="ssh - 安全远程登录"
    COMMAND_DESCRIPTIONS["scp"]="scp - 通过SSH安全复制文件"
    COMMAND_DESCRIPTIONS["rsync"]="rsync - 远程同步文件和目录"
    COMMAND_DESCRIPTIONS["crontab"]="crontab - 安装、卸载或列出用于驱动cron守护进程的表"
    COMMAND_DESCRIPTIONS["alias"]="alias - 创建或显示别名"
    COMMAND_DESCRIPTIONS["which"]="which - 显示可执行文件的路径"
    COMMAND_DESCRIPTIONS["man"]="man - 格式化并显示在线手册页"
    COMMAND_DESCRIPTIONS["echo"]="echo - 显示一行文本"
    COMMAND_DESCRIPTIONS["export"]="export - 设置环境变量"
    COMMAND_DESCRIPTIONS["date"]="date - 显示或设置系统日期和时间"
    COMMAND_DESCRIPTIONS["reboot"]="reboot - 重新启动系统"
    COMMAND_DESCRIPTIONS["set"]="set - 设置或显示 shell 选项和位置参数"
    COMMAND_DESCRIPTIONS["awk"]="awk - 模式扫描和处理语言"
    COMMAND_DESCRIPTIONS["cut"]="cut - 从文件每行中移除部分"
    COMMAND_DESCRIPTIONS["wc"]="wc - 统计文件的行数、字数和字节数"
    COMMAND_DESCRIPTIONS["vim"]="vim - 高级文本编辑器"
    
    # 应用级命令描述缓存
    COMMAND_DESCRIPTIONS["docker"]="docker - Docker 是一个开源的容器化平台，用于开发、交付和运行应用程序"
    COMMAND_DESCRIPTIONS["docker-compose"]="docker-compose - 使用 YAML 文件定义和运行多容器 Docker 应用程序"
    COMMAND_DESCRIPTIONS["docker-common"]="docker-common - Docker 常用命令组合"
    COMMAND_DESCRIPTIONS["kubectl"]="kubectl - Kubernetes 命令行工具，用于控制 Kubernetes 集群"
    COMMAND_DESCRIPTIONS["kuber"]="kuber - Kubernetes 常用命令集合（kubectl 的简写别名）"
    COMMAND_DESCRIPTIONS["helm"]="helm - Kubernetes 的包管理器，用于管理预配置的 Kubernetes 资源包"
}

############################################################################################
#                              基础命令帮助数据库
############################################################################################
init_basic_help_db() {
    # 网络相关命令
    BASIC_COMMAND_HELP["ip"]="ip - 显示/操作路由、网络设备、策略路由和隧道

用法: ip [选项] OBJECT { COMMAND | help }
       ip [选项] -V | --version
       ip [选项] -0 | -family { inet | inet6 | link } | -4 | -6
       ip -0 [选项] OBJECT

OBJECT := { link | address | addr | neighbor | neigh | route | rule | maddr | mroute | mrule | monitor | xfrm }
选项 := { -V[ersion] | -s[tatistics] | -d[etails] | -r[esolve] | -h[uman-readable] |
         -iec | -f[amily] { inet | inet6 | link } | -4 | -6 | -o[neline] |
         -t[imestamp] | -b[atch] [filename] | -rc[vd] [filename] }

常用用法:
  ${CYAN}ip addr show${NC}         - 显示所有网络接口的地址信息
  ${CYAN}ip link show${NC}         - 显示所有网络接口
  ${CYAN}ip route show${NC}        - 显示路由表
  ${CYAN}ip -s link show${NC}      - 显示网络接口统计信息
  
示例:
  ${YELLOW}ip addr add 192.168.1.100/24 dev eth0${NC}  - 为eth0添加IP地址
  ${YELLOW}ip link set eth0 up${NC}                    - 启用eth0接口
  ${YELLOW}ip route add default via 192.168.1.1${NC}   - 添加默认路由

建议:
  - 使用 ${CYAN}ip -details${NC} 可以获取更详细的信息
  - 使用 ${CYAN}ip -statistics${NC} 可以查看统计信息
  - 使用 ${CYAN}ip -color${NC} 可以让输出更有可读性"

    BASIC_COMMAND_HELP["ping"]="ping - 发送ICMP回显请求到网络主机
    
常用用法:
  ${CYAN}ping hostname${NC}        - ping指定主机
  ${CYAN}ping -c 4 hostname${NC}   - 只发送4个ping包
  ${CYAN}ping -i 2 hostname${NC}   - 每2秒发送一个ping包
  
示例:
  ${YELLOW}ping -c 4 google.com${NC}    - 测试与google.com的连接
  ${YELLOW}ping -s 1024 hostname${NC}   - 发送1024字节的数据包"

    BASIC_COMMAND_HELP["netstat"]="netstat - 显示网络连接、路由表、接口统计等
    
常用用法:
  ${CYAN}netstat -a${NC}           - 显示所有连接
  ${CYAN}netstat -t${NC}           - 显示TCP连接
  ${CYAN}netstat -u${NC}           - 显示UDP连接
  ${CYAN}netstat -l${NC}           - 显示只监听的端口
  ${CYAN}netstat -p${NC}           - 显示进程ID和名称
  
示例:
  ${YELLOW}netstat -tuln${NC}       - 显示所有监听的TCP和UDP端口
  ${YELLOW}netstat -an | grep ESTABLISHED${NC}  - 显示所有已建立的连接"

    BASIC_COMMAND_HELP["ss"]="ss - 显示套接字统计信息，替代netstat
    
常用用法:
  ${CYAN}ss -t${NC}               - 显示TCP套接字
  ${CYAN}ss -u${NC}               - 显示UDP套接字
  ${CYAN}ss -l${NC}               - 显示监听套接字
  ${CYAN}ss -a${NC}               - 显示所有套接字
  ${CYAN}ss -p${NC}               - 显示使用套接字的进程
  
示例:
  ${YELLOW}ss -tuln${NC}           - 显示所有监听的TCP和UDP端口
  ${YELLOW}ss -tp${NC}             - 显示TCP连接及其进程"

    BASIC_COMMAND_HELP["curl"]="curl - 传输数据URL语法
    
常用用法:
  ${CYAN}curl URL${NC}             - 获取URL内容
  ${CYAN}curl -o file URL${NC}     - 下载并保存到文件
  ${CYAN}curl -I URL${NC}          - 只获取HTTP头
  ${CYAN}curl -X POST URL${NC}     - 发送POST请求
  
示例:
  ${YELLOW}curl -O https://example.com/file.txt${NC}  - 下载文件
  ${YELLOW}curl -H 'Content-Type: application/json' -d '{"key":"value"}' URL${NC}  - 发送JSON数据"

    BASIC_COMMAND_HELP["wget"]="wget - 从网络下载文件
    
常用用法:
  ${CYAN}wget URL${NC}             - 下载文件
  ${CYAN}wget -O file URL${NC}     - 下载并保存为指定文件名
  ${CYAN}wget -c URL${NC}          - 断点续传下载
  ${CYAN}wget -r URL${NC}          - 递归下载
  
示例:
  ${YELLOW}wget -q https://example.com/file.zip${NC}  - 静默下载
  ${YELLOW}wget --limit-rate=100k URL${NC}            - 限制下载速度"

    # 文件操作命令
    BASIC_COMMAND_HELP["ls"]="ls - 列出目录内容

用法: ls [选项] [文件]...
列出有关 FILE 的信息（默认为当前目录）。
按字母顺序排序条目，如果设置了 LC_COLLATE，则按区域设置排序。

常用选项:
  -a, --all                  不忽略以 . 开头的条目
  -A, --almost-all           不列出隐含的 . 和 ..
  -b, --escape               以八进制转义表示不可打印的字符
      --block-size=SIZE      将 SIZE 用于块大小；例如：'--block-size=M'；
                              见 SIZE 格式如下
  -B, --ignore-backups       不列出以 ~ 结尾的隐含条目
  -c                         按 ctime（文件状态最后更改时间）排序；
                              使用 -l 显示 ctime
  -C                         按列列出条目
      --color[=WHEN]         控制颜色输出；WHEN 可以是'never'、'always'或'auto'；
                              更多信息见下文
  -d, --directory            列出目录本身，而不是其内容
  -D, --dired                生成为 Emacs 的 dired 模式设计的输出
  -f                         不排序，启用 -aU，禁用 -ls --color
  -F, --classify             在条目后添加指示符（*/=>@| 之一）
      --file-type           类似，但不执行'*'
      --format=WORD          横跨 -x，逗号分隔 -m，水平 -x，长 -l，
                              单列 -1，详细 -l，垂直 -C
      --full-time            类似 -l --time-style=full-iso
  -g                         类似 -l，但不列出所有者
      --group-directories-first
                             在文件之前对目录分组；
                              可以通过 --no-group-directories-first 禁用
  -G, --no-group             在长格式列表中不输出组名
  -h, --human-readable       与 -l 一起使用时，以人类可读的格式
                              显示文件大小（例如 1K 234M 2G）
      --si                   类似，但使用 1000 的幂而不是 1024
  -H, --dereference-command-line
                             跟随命令行上列出的符号链接
      --dereference-command-line-symlink-to-dir
                             跟随每个指向目录的命令行符号链接
      --hide=PATTERN         不显示与 shell PATTERN 匹配的隐含条目
                              (被 -a 或 -A 覆盖)
      --indicator-style=WORD 附加指示符到条目名称：none (默认)，
                              slash (-p)，file-type (--file-type),
                              classify (-F)
  -i, --inode               打印每个文件的索引号
  -I, --ignore=PATTERN       不列出与 shell PATTERN 匹配的隐含条目
  -k, --kibibytes            默认使用 1024 字节的块大小用于磁盘使用；
                              仅与 -s 和按大小排序一起使用时有效
  -l                         使用长列表格式
  -L, --dereference         当显示符号链接的文件信息时，跟随符号链接
  -m                         填充宽度，用逗号分隔条目
  -n, --numeric-uid-gid      类似 -l，但列出数字用户和组 ID
  -N, --literal              打印原始条目名称（例如不特别处理控制字符）
  -o                         类似 -l，但不列出组信息
  -p, --indicator-style=slash
                             在目录后附加 / 指示符
  -q, --hide-control-chars   以 ? 打印不可打印的字符
      --show-control-chars  按原样显示不可打印的字符（默认设置，
                              除非程序是'ls'并且输出是终端）
  -Q, --quote-name           将条目名称括在双引号中
      --quoting-style=WORD  使用引号样式 WORD 作为条目名称：
                              literal, locale, shell, shell-always,
                              shell-escape, shell-always-escape, c, escape
  -r, --reverse             反转排序顺序
  -R, --recursive           递归列出子目录
  -s, --size                以块为单位打印每个文件的分配大小
  -S                         按文件大小排序
      --sort=WORD           按词而不是名称排序：none (-U), size (-S),
                              time (-t), version (-v), extension (-X)
      --time=WORD           用词代替修改时间：atime (-u),
                              access (-u), use (-u), ctime (-c)
                              或 status (-c)；使用指定的时间作为排序键
                              如果使用 --time-style，则作为长格式的时间
      --time-style=STYLE    使用 -l 的时间样式：full-iso,
                              long-iso, iso, locale, +FORMAT。
                              FORMAT 的解释类似于'date'；如果 FORMAT
                              是 FORMAT1<newline>FORMAT2，则 FORMAT1
                              适用于非最近文件，FORMAT2 适用于最近文件；
                              如果 STYLE 以'posix-'为前缀，
                              STYLE 仅在 POSIX 区域设置之外生效
  -t                         按修改时间排序，最新的优先
  -T, --tabsize=COLS        假定制表符在每个 COLS 而不是 8 停止
  -u                         与 -lt 一起使用：按访问时间排序并显示
                              与 -l 一起使用：显示访问时间并按名称排序
                              否则：按访问时间排序
  -U                         不排序；按目录顺序列出条目
  -v                         按版本排序
  -w, --width=COLS          假定屏幕宽度为 COLS 而不是当前值
  -x                         按行而不是按列列出条目
  -X                         按条目扩展名按字母顺序排序
  -1, --format=single-column  每行列出一个条目
      --help                显示此帮助信息并退出
      --version             输出版本信息并退出

常用用法:
  ${CYAN}ls${NC}                  - 列出当前目录内容
  ${CYAN}ls -l${NC}                - 使用长格式列出
  ${CYAN}ls -a${NC}                - 显示隐藏文件
  ${CYAN}ls -h${NC}                - 以人类可读格式显示文件大小
  ${CYAN}ls -t${NC}                - 按修改时间排序
  
示例:
  ${YELLOW}ls -la${NC}              - 显示所有文件（包括隐藏文件）的详细信息
  ${YELLOW}ls -lh --sort=size${NC} - 按文件大小排序并显示人类可读格式

建议:
  - 使用 ${CYAN}ls --color=auto${NC} 可以让输出更有可读性（文件类型用不同颜色）
  - 使用 ${CYAN}ls -ltr${NC} 可以按修改时间反向排序（最新的在最后）
  - 使用 ${CYAN}ls -F${NC} 可以在文件名后添加类型指示符（如目录显示为/）
  - 使用 ${CYAN}ls --group-directories-first${NC} 可以先显示目录再显示文件"

    BASIC_COMMAND_HELP["cd"]="cd - 更改当前工作目录
    
常用用法:
  ${CYAN}cd directory${NC}         - 切换到指定目录
  ${CYAN}cd ..${NC}                - 切换到上一级目录
  ${CYAN}cd ~${NC}                 - 切换到用户主目录
  ${CYAN}cd -${NC}                 - 切换到上一个工作目录
  
示例:
  ${YELLOW}cd /var/log${NC}        - 切换到/var/log目录
  ${YELLOW}cd ~/Documents${NC}     - 切换到用户文档目录"

    BASIC_COMMAND_HELP["pwd"]="pwd - 打印当前工作目录
    
常用用法:
  ${CYAN}pwd${NC}                  - 显示当前工作目录
  ${CYAN}pwd -P${NC}               - 显示物理路径（解析所有符号链接）
  
示例:
  ${YELLOW}pwd${NC}                - 显示当前目录路径
  ${YELLOW}pwd -P${NC}             - 显示真实路径（不含符号链接）"

    BASIC_COMMAND_HELP["mkdir"]="mkdir - 创建目录
    
常用用法:
  ${CYAN}mkdir directory${NC}      - 创建新目录
  ${CYAN}mkdir -p dir1/dir2${NC}   - 创建嵌套目录（包括父目录）
  ${CYAN}mkdir -m 755 dir${NC}     - 创建具有特定权限的目录
  
示例:
  ${YELLOW}mkdir -p project/src${NC}  - 创建嵌套目录结构
  ${YELLOW}mkdir -m 700 private${NC}  - 创建只有所有者可访问的目录"

    BASIC_COMMAND_HELP["rm"]="rm - 删除文件和目录
    
常用用法:
  ${CYAN}rm file${NC}              - 删除文件
  ${CYAN}rm -r directory${NC}      - 递归删除目录及其内容
  ${CYAN}rm -f file${NC}           - 强制删除文件，不提示
  ${CYAN}rm -i file${NC}           - 删除前提示确认
  
示例:
  ${YELLOW}rm -rf temp_dir${NC}    - 强制递归删除目录及其内容
  ${YELLOW}rm -i *.txt${NC}        - 删除所有.txt文件，每个都提示确认"

    BASIC_COMMAND_HELP["cp"]="cp - 复制文件和目录
    
常用用法:
  ${CYAN}cp source dest${NC}       - 复制文件
  ${CYAN}cp -r source_dir dest_dir${NC} - 递归复制目录
  ${CYAN}cp -p source dest${NC}    - 保留文件属性
  ${CYAN}cp -i source dest${NC}    - 覆盖前提示
  
示例:
  ${YELLOW}cp -r backup/* .${NC}   - 复制backup目录中的所有内容到当前目录
  ${YELLOW}cp -p file.txt file_backup.txt${NC}  - 复制文件并保留所有属性"

    BASIC_COMMAND_HELP["mv"]="mv - 移动或重命名文件和目录
    
常用用法:
  ${CYAN}mv source dest${NC}       - 移动/重命名文件
  ${CYAN}mv -i source dest${NC}    - 覆盖前提示
  ${CYAN}mv -u source dest${NC}    - 只在源文件比目标文件新时更新
  
示例:
  ${YELLOW}mv old_name new_name${NC} - 重命名文件
  ${YELLOW}mv file.txt ~/Documents/${NC} - 移动文件到Documents目录"

    BASIC_COMMAND_HELP["find"]="find - 搜索目录树中的文件

用法: find [-H] [-L] [-P] [-D debugopts] [-Olevel] [path...] [expression]

默认路径是当前目录；默认表达式是 -print
表达式可能包含：操作符、选项、测试和操作。

操作符（按优先级降序排列）:
  ( EXPR )   ! EXPR  -not EXPR  EXPR1 -a EXPR2  EXPR1 -and EXPR2
  EXPR1 -o EXPR2  EXPR1 -or EXPR2  EXPR1 , EXPR2

位置选项（始终为真）:
  -daystart    -follow     -regextype
  -warn        -nowarn
  -depth       -xdev       -ignore_readdir_race
  -noignore_readdir_race
  -maxdepth LEVELS
  -mindepth LEVELS
  -mount       -noleaf

正常选项（始终为真，在其他地方指定）:
  -version     -help       -xdev
  -mindepth LEVELS
  -maxdepth LEVELS
  -depth       -mount
  -noleaf      -follow
  -regextype TYPE
  -ignore_readdir_race
  -noignore_readdir_race

测试（N 可以是 +N 或 -N 或 N）:
  -amin N         -anewer FILE       -atime N
  -cmin N         -cnewer FILE       -ctime N
  -empty          -false             -fstype TYPE
  -gid N          -group NAME        -ilname PATTERN
  -iname PATTERN  -inum N            -iwholename PATTERN
  -iregex PATTERN -links N           -lname PATTERN
  -mmin N         -mtime N           -name PATTERN
  -newer FILE     -nogroup           -nouser
  -path PATTERN   -perm [/|-]MODE    -regex PATTERN
  -readable       -writable         -executable
  -wholename PATTERN
  -size N[bcwkMG]  -true             -type [bcdpflsD]
  -uid N          -used N            -user NAME
  -xtype [bcdpfls]
  -context CONTEXT

操作:
  -delete         -print0            -printf FORMAT
  -fprintf FILE FORMAT -print         -fprint0 FILE
  -fprint FILE    -ls                -fls FILE
  -prune          -quit              -exec COMMAND ;
  -exec COMMAND {} +                 -ok COMMAND ;
  -execdir COMMAND ;                -execdir COMMAND {} +
  -okdir COMMAND ;                  -execdir COMMAND {} +
  -okdir COMMAND {} +               -execdir COMMAND {} +
  -ok COMMAND ;                     -exec COMMAND {} +
  -exec COMMAND {} +                -ok COMMAND {} +
  -execdir COMMAND {} +             -okdir COMMAND {} +

常用用法:
  ${CYAN}find directory -name pattern${NC} - 按名称搜索
  ${CYAN}find directory -type f${NC}        - 只搜索文件
  ${CYAN}find directory -type d${NC}        - 只搜索目录
  ${CYAN}find directory -size +1M${NC}      - 搜索大于1MB的文件
  
示例:
  ${YELLOW}find . -name '*.log' -mtime +7${NC} - 查找7天前修改过的.log文件
  ${YELLOW}find /home -user username${NC}     - 查找属于指定用户的文件
  ${YELLOW}find /var/log -name '*.log' -size +10M -delete${NC} - 查找并删除大于10MB的日志文件
  ${YELLOW}find . -type f -name '*.sh' -exec chmod +x {} \;${NC} - 查找所有.sh文件并添加执行权限
  ${YELLOW}find /tmp -type f -empty${NC}     - 查找/tmp目录下的空文件

建议:
  - 使用 ${CYAN}find . -maxdepth 1${NC} 可以限制搜索深度为当前目录
  - 使用 ${CYAN}find . -name '*.tmp' -ok rm {} \;${NC} 可以在删除前确认
  - 使用 ${CYAN}find . -type f -exec grep -l 'pattern' {} \;${NC} 可以查找包含特定文本的文件
  - 使用 ${CYAN}find . -mtime -7${NC} 可以查找最近7天内修改过的文件"

    BASIC_COMMAND_HELP["grep"]="grep - 搜索文本模式

用法: grep [选项]... PATTERN [文件]...
在每个文件或标准输入中搜索 PATTERN。
默认情况下，PATTERN 是一个基本正则表达式 (BRE)。
示例: grep -i 'hello world' menu.h main.c

正则表达式选择和解释:
  -E, --extended-regexp     PATTERN 是扩展正则表达式 (ERE)
  -F, --fixed-strings       PATTERN 是一组由换行符分隔的固定字符串
  -G, --basic-regexp        PATTERN 是基本正则表达式 (BRE)
  -P, --perl-regexp         PATTERN 是 Perl 正则表达式
  -e, --regexp=PATTERN      使用 PATTERN 进行匹配
  -f, --file=FILE           从 FILE 获取 PATTERN
  -i, --ignore-case         忽略大小写区别
  -w, --word-regexp         强制 PATTERN 只匹配整个单词
  -x, --line-regexp         强制 PATTERN 只匹配整行
  -z, --null-data           数据行以 0 字节结束，而不是换行符

杂项:
  -s, --no-messages         抑制错误消息
  -v, --invert-match        选择不匹配的行
  -V, --version             显示版本信息并退出
      --help                显示此帮助文本并退出

输出控制:
  -m, --max-count=NUM       在 NUM 次匹配后停止
  -b, --byte-offset         输出行时打印字节偏移
  -n, --line-number         输出行时打印行号
      --line-buffered       每行刷新输出
  -H, --with-filename       为每次匹配打印文件名
  -h, --no-filename         输出时禁止文件名前缀
      --label=LABEL         将 LABEL 用作标准输入文件名前缀
  -o, --only-matching       只显示行中匹配 PATTERN 的部分
  -q, --quiet, --silent     抑制所有正常输出
      --binary-files=TYPE   假定二进制文件是 TYPE；
                            TYPE 是 'binary'、'text' 或 'without-match'
  -a, --text                等同于 --binary-files=text
  -I                        等同于 --binary-files=without-match
  -d, --directories=ACTION  如何处理目录；
                            ACTION 是 'read'、'recurse' 或 'skip'
  -D, --devices=ACTION      如何处理设备、FIFO 和套接字；
                            ACTION 是 'read' 或 'skip'
  -r, --recursive           等同于 --directories=recurse
  -R, --dereference-recursive
                            同上，但跟随所有符号链接
      --include=FILE_PATTERN
                            只搜索匹配 FILE_PATTERN 的文件
      --exclude=FILE_PATTERN
                            跳过匹配 FILE_PATTERN 的文件和目录
      --exclude-from=FILE   跳过匹配 FILE 中任何文件模式的文件
      --exclude-dir=PATTERN 跳过匹配 PATTERN 的目录
  -L, --files-without-match 只打印不包含匹配的 FILE 名称
  -l, --files-with-matches  只打印包含匹配的 FILE 名称
  -c, --count               只为每个 FILE 打印匹配的行数
  -T, --initial-tab         使制表符对齐（如果需要）
  -Z, --null                在 FILE 名后打印 0 字节

上下文控制:
  -B, --before-context=NUM  打印 NUM 行前导上下文
  -A, --after-context=NUM   打印 NUM 行尾随上下文
  -C, --context=NUM         打印 NUM 行输出上下文
  -NUM                      等同于 --context=NUM
      --group-separator=SEP 使用 SEP 作为组分隔符
      --no-group-separator  使用空字符串作为组分隔符
      --color[=WHEN],
      --colour[=WHEN]       使用标记突出显示匹配的字符串；
                            WHEN 是 'always'、'never' 或 'auto'
  -U, --binary              不剥离 EOL 处的 CR 字符 (MSDOS/Windows)
  -u, --unix-byte-offsets   报告偏移量，就像 CR 不存在一样
                            (MSDOS/Windows)

常用用法:
  ${CYAN}grep pattern file${NC}    - 在文件中搜索模式
  ${CYAN}grep -i pattern file${NC} - 不区分大小写搜索
  ${CYAN}grep -r pattern dir${NC}  - 递归搜索目录
  ${CYAN}grep -v pattern file${NC} - 显示不匹配模式的行
  
示例:
  ${YELLOW}grep -r 'error' /var/log${NC} - 在/var/log中递归搜索'error'
  ${YELLOW}grep -i 'warning' *.log${NC}   - 在所有.log文件中不区分大小写搜索'warning'

建议:
  - 使用 ${CYAN}grep --color=auto${NC} 可以高亮显示匹配的文本
  - 使用 ${CYAN}grep -n${NC} 可以显示行号，便于定位
  - 使用 ${CYAN}grep -B2 -A2${NC} 可以显示匹配行前后各2行的上下文
  - 使用 ${CYAN}grep -E${NC} 可以使用扩展正则表达式，支持更复杂的模式
  - 使用 ${CYAN}grep -F${NC} 可以搜索固定字符串，提高性能"

    BASIC_COMMAND_HELP["cat"]="cat - 连接文件并打印到标准输出
    
常用用法:
  ${CYAN}cat file${NC}             - 显示文件内容
  ${CYAN}cat file1 file2${NC}      - 连接多个文件并显示
  ${CYAN}cat -n file${NC}          - 显示行号
  ${CYAN}cat -A file${NC}          - 显示所有字符（包括制表符和行结束符）
  
示例:
  ${YELLOW}cat -n file.txt${NC}    - 带行号显示文件内容
  ${YELLOW}cat file1.txt file2.txt > combined.txt${NC} - 合并两个文件"

    BASIC_COMMAND_HELP["less"]="less - 浏览文件内容
    
常用用法:
  ${CYAN}less file${NC}            - 打开文件浏览
  ${CYAN}less +F file${NC}         - 实时跟踪文件（类似tail -f）
  
在less中:
  ${GREEN}q${NC}                   - 退出
  ${GREEN}/pattern${NC}            - 向前搜索
  ${GREEN}?pattern${NC}            - 向后搜索
  ${GREEN}n${NC}                   - 重复上次搜索
  ${GREEN}N${NC}                   - 反向重复上次搜索
  ${GREEN}G${NC}                   - 到文件末尾
  ${GREEN}g${NC}                   - 到文件开头
  
示例:
  ${YELLOW}less +F /var/log/syslog${NC} - 实时查看系统日志"

    BASIC_COMMAND_HELP["head"]="head - 输出文件的开头部分
    
常用用法:
  ${CYAN}head file${NC}            - 显示文件前10行
  ${CYAN}head -n 20 file${NC}      - 显示文件前20行
  ${CYAN}head -c 100 file${NC}     - 显示文件前100字节
  
示例:
  ${YELLOW}head -n 5 /var/log/syslog${NC} - 显示系统日志的前5行"

    BASIC_COMMAND_HELP["tail"]="tail - 输出文件的结尾部分
    
常用用法:
  ${CYAN}tail file${NC}            - 显示文件最后10行
  ${CYAN}tail -n 20 file${NC}      - 显示文件最后20行
  ${CYAN}tail -f file${NC}         - 实时跟踪文件变化
  ${CYAN}tail -c 100 file${NC}     - 显示文件最后100字节
  
示例:
  ${YELLOW}tail -f /var/log/syslog${NC} - 实时查看系统日志更新"

    BASIC_COMMAND_HELP["chmod"]="chmod - 更改文件权限
    
常用用法:
  ${CYAN}chmod 755 file${NC}       - 设置文件权限为755
  ${CYAN}chmod u+x file${NC}       - 为文件所有者添加执行权限
  ${CYAN}chmod -R 755 dir${NC}     - 递归更改目录权限
  
权限数字:
  ${CYAN}4${NC} = 读(r), ${CYAN}2${NC} = 写(w), ${CYAN}1${NC} = 执行(x)
  ${CYAN}7${NC} = rwx, ${CYAN}6${NC} = rw-, ${CYAN}5${NC} = r-x, ${CYAN}4${NC} = r--
  
示例:
  ${YELLOW}chmod 644 file.txt${NC}  - 设置文件权限为所有者可读写，其他只读
  ${YELLOW}chmod -R go+rX dir${NC}  - 为目录和子目录添加组和其他用户的读和执行权限"

    BASIC_COMMAND_HELP["chown"]="chown - 更改文件所有者和组
    
常用用法:
  ${CYAN}chown owner file${NC}     - 更改文件所有者
  ${CYAN}chown owner:group file${NC} - 更改文件所有者和组
  ${CYAN}chown :group file${NC}    - 只更改文件组
  ${CYAN}chown -R owner dir${NC}   - 递归更改目录所有者
  
示例:
  ${YELLOW}chown user:group file.txt${NC} - 更改文件所有者和组
  ${YELLOW}chown -R www-data /var/www${NC} - 递归更改网站目录所有者"

    # 系统信息命令
    BASIC_COMMAND_HELP["uname"]="uname - 显示系统信息
    
常用用法:
  ${CYAN}uname${NC}                - 显示内核名称
  ${CYAN}uname -a${NC}             - 显示所有可用信息
  ${CYAN}uname -r${NC}             - 显示内核版本
  ${CYAN}uname -m${NC}             - 显示机器硬件架构
  
示例:
  ${YELLOW}uname -a${NC}            - 显示完整的系统信息"

    BASIC_COMMAND_HELP["df"]="df - 显示磁盘空间使用情况
    
常用用法:
  ${CYAN}df${NC}                  - 显示所有挂载点的磁盘使用情况
  ${CYAN}df -h${NC}                - 以人类可读格式显示
  ${CYAN}df -T${NC}                - 显示文件系统类型
  ${CYAN}df -i${NC}                - 显示inode使用情况
  
示例:
  ${YELLOW}df -h${NC}              - 以GB、MB等易读格式显示磁盘使用情况"

    BASIC_COMMAND_HELP["du"]="du - 估算文件空间使用情况
    
常用用法:
  ${CYAN}du${NC}                  - 显示当前目录下所有文件和目录的磁盘使用情况
  ${CYAN}du -h${NC}                - 以人类可读格式显示
  ${CYAN}du -s${NC}                - 显示总计
  ${CYAN}du -sh *${NC}             - 显示当前目录下每个项目的总计
  
示例:
  ${YELLOW}du -sh * | sort -h${NC} - 显示当前目录下每个项目的大小并按大小排序"

    BASIC_COMMAND_HELP["free"]="free - 显示内存使用情况
    
常用用法:
  ${CYAN}free${NC}                 - 显示内存使用情况（以KB为单位）
  ${CYAN}free -h${NC}              - 以人类可读格式显示
  ${CYAN}free -m${NC}              - 以MB为单位显示
  ${CYAN}free -g${NC}              - 以GB为单位显示
  
示例:
  ${YELLOW}free -h${NC}            - 以GB、MB等易读格式显示内存使用情况"

    BASIC_COMMAND_HELP["top"]="top - 显示运行中的进程
    
常用用法:
  ${CYAN}top${NC}                  - 启动top
  ${CYAN}top -p PID${NC}           - 监视特定进程
  ${CYAN}top -u username${NC}      - 显示特定用户的进程
  
在top中:
  ${GREEN}q${NC}                   - 退出
  ${GREEN}M${NC}                   - 按内存使用排序
  ${GREEN}P${NC}                   - 按CPU使用排序
  ${GREEN}k${NC}                   - 终止进程
  ${GREEN}r${NC}                   - 重新设置进程优先级
  
示例:
  ${YELLOW}top -u www-data${NC}    - 只显示www-data用户的进程"

    BASIC_COMMAND_HELP["ps"]="ps - 显示当前进程

用法: ps [选项]

基本选项:
  -a               显示所有进程，除了会话领队和与终端无关的进程
  -A, -e           显示所有进程
  -a               显示所有进程，包括其他用户的进程
  -d               显示所有进程，但不包括会话领队
  -N, --deselect   反向选择
  -r               只显示正在运行的进程
  -T               显示此终端的所有进程
  x                 显示没有控制终端的进程

常用选项:
  --cols, --columns, --width
                   设置屏幕宽度
  --headers        重复标题行
  --no-headers     不打印标题行
  --lines, --rows  设置屏幕高度

输出格式控制:
  -C, --columns    自定义列
  -c               显示不同的调度信息
  -F               额外的完整格式
  -f               完整格式
  -j, j            作业格式
  -l, l            长格式
  -O, --format     用户定义格式
  -o, o, --format  用户定义格式
  -s, s, --format  信号格式
  -u, u            用户格式
  -U, --user       按用户显示
  -X               旧版 Linux i386 寄存器格式
  -y                不显示标志；显示 rss 而不是 addr
  --context        显示安全上下文
  --forest         以树状格式显示进程
  --format        用户定义格式
  --html           HTML 输出
  --info           打印调试信息
  --last, --n      只显示最近的 N 个进程
  --no-headers     不打印标题行
  --rows, --lines  设置屏幕高度
  --sort           排序
  --version        打印版本信息
  --width          设置屏幕宽度

显示信息:
  -c               显示命令名称
  -e               显示命令后的环境
  -f               ASCII 艺术进程层次结构
  -H               显示进程层次结构
  -L, L            显示线程，可能是 LWP
  -M, Z            显示安全数据
  -O               按用户定义格式排序
  -O, --sort       按用户定义格式排序
  -m               显示所有线程
  -n               数值输出 for USER and WCHAN
  -S, S, --cumulative 包括一些死子进程数据

常用用法:
  ${CYAN}ps${NC}                   - 显示当前用户的进程
  ${CYAN}ps aux${NC}               - 显示所有运行中的进程
  ${CYAN}ps -ef${NC}               - 显示所有进程详细信息
  ${CYAN}ps aux | grep process${NC} - 查找特定进程
  
示例:
  ${YELLOW}ps aux --sort=-%cpu${NC} - 显示所有进程并按CPU使用率降序排列
  ${YELLOW}ps -ef | grep nginx${NC} - 查找nginx相关进程
  ${YELLOW}ps -eo pid,ppid,cmd,%mem,%cpu --sort=-%mem${NC} - 显示进程的PID、PPID、命令、内存和CPU使用情况，并按内存使用排序
  ${YELLOW}ps -u username${NC}      - 显示特定用户的进程
  ${YELLOW}ps -p 1234${NC}          - 显示PID为1234的进程信息

建议:
  - 使用 ${CYAN}ps aux --sort=-%cpu | head${NC} 可以查看CPU使用率最高的几个进程
  - 使用 ${CYAN}ps -eo pid,user,comm${NC} 可以只显示PID、用户和命令名
  - 使用 ${CYAN}ps -C processname${NC} 可以查找特定名称的进程
  - 使用 ${CYAN}ps --forest${NC} 可以以树状结构显示进程层次关系"

    BASIC_COMMAND_HELP["kill"]="kill - 终止进程
    
常用用法:
  ${CYAN}kill PID${NC}             - 终止指定进程ID的进程
  ${CYAN}kill -9 PID${NC}          - 强制终止进程
  ${CYAN}killall process_name${NC} - 终止所有同名进程
  
示例:
  ${YELLOW}kill 1234${NC}          - 终止PID为1234的进程
  ${YELLOW}killall -9 nginx${NC}   - 强制终止所有nginx进程"

    BASIC_COMMAND_HELP["history"]="history - 显示命令历史
    
常用用法:
  ${CYAN}history${NC}              - 显示命令历史列表
  ${CYAN}history N${NC}            - 显示最近的N条命令
  ${CYAN}history -c${NC}           - 清除命令历史
  ${CYAN}!N${NC}                   - 执行历史命令编号为N的命令
  
示例:
  ${YELLOW}history | grep 'ssh'${NC} - 查找包含ssh的历史命令
  ${YELLOW}!123${NC}               - 执行历史命令中编号为123的命令"

    # 其他常用命令
    BASIC_COMMAND_HELP["tar"]="tar - 归档工具
    
常用用法:
  ${CYAN}tar -cvf archive.tar file1 file2${NC}  - 创建tar归档
  ${CYAN}tar -xvf archive.tar${NC}              - 解压tar归档
  ${CYAN}tar -tvf archive.tar${NC}              - 列出tar归档内容
  ${CYAN}tar -czvf archive.tar.gz dir${NC}      - 创建gzip压缩的tar归档

  ${CYAN}tar -xzvf archive.tar.gz${NC}          - 解压gzip压缩的tar归档
  
示例:
  ${YELLOW}tar -czvf backup.tar.gz /home/user/docs${NC} - 压缩并备份docs目录
  ${YELLOW}tar -tzvf backup.tar.gz${NC}          - 查看压缩归档内容不解压"

    BASIC_COMMAND_HELP["zip"]="zip - 压缩和打包文件
    
常用用法:
  ${CYAN}zip archive.zip file1 file2${NC}        - 创建zip归档
  ${CYAN}zip -r archive.zip directory${NC}      - 递归压缩目录
  ${CYAN}unzip archive.zip${NC}                 - 解压zip归档
  ${CYAN}unzip -l archive.zip${NC}              - 列出zip归档内容
  
示例:
  ${YELLOW}zip -r project.zip project/${NC}     - 将project目录压缩为project.zip
  ${YELLOW}unzip -q archive.zip -d dest_dir${NC} - 解压到指定目录"

    BASIC_COMMAND_HELP["ssh"]="ssh - 安全远程登录
    
常用用法:
  ${CYAN}ssh user@host${NC}       - 连接到远程主机
  ${CYAN}ssh -p port user@host${NC} - 指定端口连接
  ${CYAN}ssh -i keyfile user@host${NC} - 使用特定密钥文件
  
示例:
  ${YELLOW}ssh user@example.com${NC}  - 连接到example.com服务器
  ${YELLOW}ssh -L 8080:localhost:80 user@host${NC} - 设置端口转发"

    BASIC_COMMAND_HELP["scp"]="scp - 通过SSH安全复制文件
    
常用用法:
  ${CYAN}scp file user@host:/path${NC}     - 复制本地文件到远程主机
  ${CYAN}scp user@host:/path/file .${NC}   - 复制远程文件到当前目录
  ${CYAN}scp -r dir user@host:/path${NC}   - 递归复制目录
  
示例:
  ${YELLOW}scp file.txt user@example.com:/home/user/${NC}  - 复制文件到远程服务器
  ${YELLOW}scp -r project/ user@example.com:/home/user/${NC} - 复制整个目录"

    BASIC_COMMAND_HELP["rsync"]="rsync - 远程同步文件和目录
    
常用用法:
  ${CYAN}rsync source dest${NC}          - 同步本地文件
  ${CYAN}rsync -av source/ dest/${NC}    - 归档模式同步，保留属性
  ${CYAN}rsync source user@host:/path${NC} - 同步到远程主机
  ${CYAN}rsync -e ssh source user@host:/path${NC} - 通过SSH同步
  
示例:
  ${YELLOW}rsync -avz --progress src/ dest/${NC} - 压缩传输并显示进度
  ${YELLOW}rsync -av --delete src/ dest/${NC}  - 同步并删除目标中源没有的文件"

    BASIC_COMMAND_HELP["crontab"]="crontab - 安装、卸载或列出用于驱动cron守护进程的表
    
常用用法:
  ${CYAN}crontab -l${NC}            - 列出当前用户的cron任务
  ${CYAN}crontab -e${NC}            - 编辑当前用户的cron任务
  ${CYAN}crontab -r${NC}            - 删除当前用户的cron任务
  
cron格式:
  ${CYAN}分钟 小时 日 月 星期 命令${NC}
  
示例:
  ${YELLOW}crontab -e${NC}          - 编辑cron任务表
  ${YELLOW}0 2 * * * /home/user/backup.sh${NC}  - 每天凌晨2点执行备份脚本"

    BASIC_COMMAND_HELP["alias"]="alias - 创建或显示别名
    
常用用法:
  ${CYAN}alias${NC}                 - 显示所有别名
  ${CYAN}alias name='command'${NC}  - 创建别名
  ${CYAN}unalias name${NC}          - 删除别名
  
示例:
  ${YELLOW}alias ll='ls -la'${NC}   - 创建ll别名显示所有文件的详细信息
  ${YELLOW}alias ..='cd ..'${NC}    - 创建..别名用于返回上一级目录"

    BASIC_COMMAND_HELP["which"]="which - 显示可执行文件的路径
    
常用用法:
  ${CYAN}which command${NC}         - 显示命令的完整路径
  ${CYAN}which -a command${NC}      - 显示所有匹配的路径
  
示例:
  ${YELLOW}which python${NC}        - 显示python解释器的路径
  ${YELLOW}which -a python${NC}     - 显示所有可用的python解释器路径"

    BASIC_COMMAND_HELP["man"]="man - 格式化并显示在线手册页
    
常用用法:
  ${CYAN}man command${NC}           - 显示命令的手册页
  ${CYAN}man 5 file${NC}            - 显示文件格式的手册页
  ${CYAN}man -k keyword${NC}        - 搜索包含关键词的手册页
  
示例:
  ${YELLOW}man ls${NC}              - 显示ls命令的手册页
  ${YELLOW}man -k 'copy files'${NC} - 搜索与复制文件相关的手册页"

    BASIC_COMMAND_HELP["echo"]="echo - 显示一行文本
    
常用用法:
  ${CYAN}echo text${NC}             - 显示文本
  ${CYAN}echo -e text${NC}          - 启用反斜杠转义解释
  ${CYAN}echo -n text${NC}          - 不输出尾随换行符
  
示例:
  ${YELLOW}echo 'Hello, World!'${NC} - 显示Hello, World!
  ${YELLOW}echo -e 'Line1\nLine2'${NC} - 显示两行文本
  ${YELLOW}echo 'export PATH=$PATH:/new/path' >> ~/.bashrc${NC} - 将文本追加到文件"

    BASIC_COMMAND_HELP["export"]="export - 设置环境变量
    
常用用法:
  ${CYAN}export VAR=value${NC}      - 设置环境变量
  ${CYAN}export -p${NC}             - 显示所有环境变量
  
示例:
  ${YELLOW}export PATH=$PATH:/usr/local/bin${NC} - 添加目录到PATH
  ${YELLOW}export EDITOR=vim${NC}   - 设置默认编辑器为vim"

    BASIC_COMMAND_HELP["date"]="date - 显示或设置系统日期和时间
    
常用用法:
  ${CYAN}date${NC}                  - 显示当前日期和时间
  ${CYAN}date '+format'${NC}        - 以指定格式显示日期
  ${CYAN}date -d 'date string'${NC} - 显示指定日期字符串的日期
  
示例:
  ${YELLOW}date '+%Y-%m-%d %H:%M:%S'${NC} - 以YYYY-MM-DD HH:MM:SS格式显示
  ${CYAN}tar -xzvf archive.tar.gz${NC}          - 解压gzip压缩的tar归档
  
示例:
  ${YELLOW}tar -czvf backup.tar.gz /home/user/docs${NC} - 压缩并备份docs目录
  ${YELLOW}tar -tzvf backup.tar.gz${NC}          - 查看压缩归档内容不解压"

    BASIC_COMMAND_HELP["zip"]="zip - 压缩和打包文件
    
常用用法:
  ${CYAN}zip archive.zip file1 file2${NC}        - 创建zip归档
  ${CYAN}zip -r archive.zip directory${NC}      - 递归压缩目录
  ${CYAN}unzip archive.zip${NC}                 - 解压zip归档
  ${CYAN}unzip -l archive.zip${NC}              - 列出zip归档内容
  
示例:
  ${YELLOW}zip -r project.zip project/${NC}     - 将project目录压缩为project.zip
  ${YELLOW}unzip -q archive.zip -d dest_dir${NC} - 解压到指定目录"

    BASIC_COMMAND_HELP["ssh"]="ssh - 安全远程登录
    
常用用法:
  ${CYAN}ssh user@host${NC}       - 连接到远程主机
  ${CYAN}ssh -p port user@host${NC} - 指定端口连接
  ${CYAN}ssh -i keyfile user@host${NC} - 使用特定密钥文件
  
示例:
  ${YELLOW}ssh user@example.com${NC}  - 连接到example.com服务器
  ${YELLOW}ssh -L 8080:localhost:80 user@host${NC} - 设置端口转发"

    BASIC_COMMAND_HELP["scp"]="scp - 通过SSH安全复制文件
    
常用用法:
  ${CYAN}scp file user@host:/path${NC}     - 复制本地文件到远程主机
  ${CYAN}scp user@host:/path/file .${NC}   - 复制远程文件到当前目录
  ${CYAN}scp -r dir user@host:/path${NC}   - 递归复制目录
  
示例:
  ${YELLOW}scp file.txt user@example.com:/home/user/${NC}  - 复制文件到远程服务器
  ${YELLOW}scp -r project/ user@example.com:/home/user/${NC} - 复制整个目录"

    BASIC_COMMAND_HELP["rsync"]="rsync - 远程同步文件和目录
    
常用用法:
  ${CYAN}rsync source dest${NC}          - 同步本地文件
  ${CYAN}rsync -av source/ dest/${NC}    - 归档模式同步，保留属性
  ${CYAN}rsync source user@host:/path${NC} - 同步到远程主机
  ${CYAN}rsync -e ssh source user@host:/path${NC} - 通过SSH同步
  
示例:
  ${YELLOW}rsync -avz --progress src/ dest/${NC} - 压缩传输并显示进度
  ${YELLOW}rsync -av --delete src/ dest/${NC}  - 同步并删除目标中源没有的文件"

    BASIC_COMMAND_HELP["crontab"]="crontab - 安装、卸载或列出用于驱动cron守护进程的表
    
常用用法:
  ${CYAN}crontab -l${NC}            - 列出当前用户的cron任务
  ${CYAN}crontab -e${NC}            - 编辑当前用户的cron任务
  ${CYAN}crontab -r${NC}            - 删除当前用户的cron任务
  
cron格式:
  ${CYAN}分钟 小时 日 月 星期 命令${NC}
  
示例:
  ${YELLOW}crontab -e${NC}          - 编辑cron任务表
  ${YELLOW}0 2 * * * /home/user/backup.sh${NC}  - 每天凌晨2点执行备份脚本"

    BASIC_COMMAND_HELP["alias"]="alias - 创建或显示别名
    
常用用法:
  ${CYAN}alias${NC}                 - 显示所有别名
  ${CYAN}alias name='command'${NC}  - 创建别名
  ${CYAN}unalias name${NC}          - 删除别名
  
示例:
  ${YELLOW}alias ll='ls -la'${NC}   - 创建ll别名显示所有文件的详细信息
  ${YELLOW}alias ..='cd ..'${NC}    - 创建..别名用于返回上一级目录"

    BASIC_COMMAND_HELP["which"]="which - 显示可执行文件的路径
    
常用用法:
  ${CYAN}which command${NC}         - 显示命令的完整路径
  ${CYAN}which -a command${NC}      - 显示所有匹配的路径
  
示例:
  ${YELLOW}which python${NC}        - 显示python解释器的路径
  ${YELLOW}which -a python${NC}     - 显示所有可用的python解释器路径"

    BASIC_COMMAND_HELP["man"]="man - 格式化并显示在线手册页
    
常用用法:
  ${CYAN}man command${NC}           - 显示命令的手册页
  ${CYAN}man 5 file${NC}            - 显示文件格式的手册页
  ${CYAN}man -k keyword${NC}        - 搜索包含关键词的手册页
  
示例:
  ${YELLOW}man ls${NC}              - 显示ls命令的手册页
  ${YELLOW}man -k 'copy files'${NC} - 搜索与复制文件相关的手册页"

    BASIC_COMMAND_HELP["echo"]="echo - 显示一行文本
    
常用用法:
  ${CYAN}echo text${NC}             - 显示文本
  ${CYAN}echo -e text${NC}          - 启用反斜杠转义解释
  ${CYAN}echo -n text${NC}          - 不输出尾随换行符
  
示例:
  ${YELLOW}echo 'Hello, World!'${NC} - 显示Hello, World!
  ${YELLOW}echo -e 'Line1\nLine2'${NC} - 显示两行文本
  ${YELLOW}echo 'export PATH=$PATH:/new/path' >> ~/.bashrc${NC} - 将文本追加到文件"

    BASIC_COMMAND_HELP["export"]="export - 设置环境变量
    
常用用法:
  ${CYAN}export VAR=value${NC}      - 设置环境变量
  ${CYAN}export -p${NC}             - 显示所有环境变量
  
示例:
  ${YELLOW}export PATH=$PATH:/usr/local/bin${NC} - 添加目录到PATH
  ${YELLOW}export EDITOR=vim${NC}   - 设置默认编辑器为vim"

    BASIC_COMMAND_HELP["date"]="date - 显示或设置系统日期和时间
    
常用用法:
  ${CYAN}date${NC}                  - 显示当前日期和时间
  ${CYAN}date '+format'${NC}        - 以指定格式显示日期
  ${CYAN}date -d 'date string'${NC} - 显示指定日期字符串的日期
  
示例:
  ${YELLOW}date '+%Y-%m-%d %H:%M:%S'${NC} - 以YYYY-MM-DD HH:MM:SS格式显示
  ${YELLOW}date -d \"2025-12-12 12:12:12\" +%s%3N${NC} - 获取时间戳（秒级）
  ${YELLOW}date -d '1 day ago'${NC}  - 显示昨天的日期"

    BASIC_COMMAND_HELP["reboot"]="reboot - 重新启动系统
    
常用用法:
  ${CYAN}reboot${NC}               - 立即重启系统
  ${CYAN}reboot -f${NC}            - 强制重启，不调用shutdown
  ${CYAN}reboot -h${NC}            - 关闭系统而不是重启
  
示例:
  ${YELLOW}sudo reboot${NC}         - 使用sudo权限重启系统"


    BASIC_COMMAND_HELP["set"]="set - 设置或显示 shell 选项和位置参数
    
常用用法:
  ${CYAN}set${NC}                  - 显示所有 shell 选项和变量
  ${CYAN}set -e${NC}               - 遇到错误时立即退出
  ${CYAN}set -x${NC}               - 显示执行的命令（调试模式）
  ${CYAN}set -u${NC}               - 使用未定义变量时报错
  ${CYAN}set -o option${NC}       - 设置特定选项
    
常用选项:
  ${CYAN}set -e${NC}               - 遇到错误时立即退出
  ${CYAN}set -u${NC}               - 使用未定义变量时报错
  ${CYAN}set -o pipefail${NC}      - 管道中任何命令失败时整个管道失败
  ${CYAN}set -x${NC}               - 显示执行的命令（调试模式）
  ${CYAN}set +a${NC}              - 启用数组自动追加到索引
  ${CYAN}set +o noclobber${NC}     - 防止覆盖现有文件
    
示例:
  ${YELLOW}set -euxo pipefail${NC}  - 严格模式：遇错退出、未定义变量报错、显示命令、管道失败时报错
  ${YELLOW}set -- ${YELLOW}$(date +%Y%m%d)${NC} - 设置位置参数为当前日期"

    BASIC_COMMAND_HELP["awk"]="awk - 模式扫描和处理语言
    
    用法: awk [选项] '程序文件' 文件...
          awk [选项] -f 程序文件 文件...
    
常用用法:
  ${CYAN}awk '{print $1}' file${NC}      - 打印每行的第一个字段
  ${CYAN}awk -F: '{print $1}' file${NC} - 使用冒号作为分隔符，打印第一个字段
  ${CYAN}awk '{sum+=$1} END {print sum}'${NC} - 计算第一列的总和
  ${CYAN}awk '{if ($1 > 100) print $0}'${NC} - 只显示第一列大于100的行
    
示例:
  ${YELLOW}awk -F: '{print $1, $5}' /etc/passwd${NC} - 从passwd文件提取用户名和用户ID
  ${YELLOW}awk '{sum+=$3} END {print "Average:", sum/NR}' file${NC} - 计算第三列的平均值
  ${YELLOW}awk 'BEGIN {print "Start"} {print $0} END {print "End"}'${NC} - 在处理前后添加标记
    
建议:
  ${YELLOW}- 使用 ${CYAN}awk -f script.awk file${NC} 可以从文件读取awk程序
  ${YELLOW}- 使用 ${CYAN}awk 'NR==5'${NC} 可以只显示第5行
  ${YELLOW}- 使用 ${CYAN}awk '{print NR, $0}'${NC} 可以显示带行号的内容"

    BASIC_COMMAND_HELP["cut"]="cut - 从文件每行中移除部分
    
    用法: cut 选项 [文件]...
    
常用法:
  ${CYAN}cut -c 1-5 file${NC}       - 提取每行的第1到5个字符
  ${CYAN}cut -d: -f 1 file${NC}     - 使用冒号作为分隔符，提取第一个字段
  ${CYAN}cut -f 1,3 file${NC}       - 提取第1和第3个字段（默认分隔符为制表符）
  ${CYAN}cut -d' ' -f 1 file${NC}    - 使用空格作为分隔符，提取第一个字段
    
常用选项:
  ${CYAN}-b, --bytes=LIST${NC}        - 按字节提取
  ${CYAN}-c, --characters=LIST${NC}   - 按字符提取
  ${CYAN}-d, --delimiter=DELIM${NC}  - 指定字段分隔符
  ${CYAN}-f, --fields=LIST${NC}      - 提取指定字段
  ${CYAN}--complement${NC}             - 提取除指定字段外的所有字段
  ${CYAN}-s, --only-delimited${NC}   - 只包含分隔符的行
    
示例:
  ${YELLOW}cut -d: -f 1,5 /etc/passwd${NC} - 从passwd文件提取用户名和用户ID
  ${YELLOW}cut -c 1-10,20-30 file${NC} - 提取每行的1-10和20-30字符
  ${YELLOW}cut -d' ' -f 2 file${NC}   - 提取每行的第二个单词（空格分隔）
  ${YELLOW}ls -l | cut -c 44-55${NC}  - 提取文件大小字段
    
建议:
  ${YELLOW}- 使用 ${CYAN}cut -d: -f 1 file | sort | uniq${NC} 可以提取唯一字段
  ${YELLOW}- 使用 ${CYAN}grep pattern file | cut -f 1${NC} 可以先筛选后提取字段"

    BASIC_COMMAND_HELP["wc"]="wc - 统计文件的行数、字数和字节数
    
常用用法:
  ${CYAN}wc file${NC}              - 显示文件的行数、字数和字节数
  ${CYAN}wc -l file${NC}            - 只显示行数
  ${CYAN}wc -w file${NC}            - 只显示字数
  ${CYAN}wc -c file${NC}            - 只显示字节数
  ${CYAN}wc -m file${NC}            - 只显示字符数
    
常用选项:
  ${CYAN}-l, --lines${NC}            - 显示行数
  ${CYAN}-w, --words${NC}           - 显示字数
  ${CYAN}-c, --bytes${NC}           - 显示字节数
  ${CYAN}-m, --chars${NC}            - 显示字符数
  ${CYAN}-L, --max-line-length${NC}  - 显示最长行的长度
    
示例:
  ${YELLOW}wc -l *.txt${NC}           - 统计所有.txt文件的总行数
  ${YELLOW}find . -name '*.py' | xargs wc -l${NC} - 统计所有Python文件的总行数
  ${YELLOW}wc -L file${NC}           - 显示文件中最长行的长度
  ${YELLOW}cat file | wc -w${NC}      - 统计管道输出的字数
    
建议:
  ${YELLOW}- 使用 ${CYAN}wc -l file | awk '{print $1}'${NC} 可以只获取行数用于脚本
  ${YELLOW}- 使用 ${CYAN}wc -c * | sort -n${NC} 可以按文件大小排序
  ${YELLOW}- 使用 ${CYAN}wc -w *.md${NC} 可以统计所有Markdown文件的总字数"


    BASIC_COMMAND_HELP["vim"]="vim - 高级文本编辑器

   用法: vim [选项] [文件...]

常用用法:
    ${CYAN}vim file${NC}             - 打开文件进行编辑
    ${CYAN}vim + file${NC}           - 打开文件并定位到文件末尾
    ${CYAN}vim +/pattern file${NC}   - 打开文件并定位到第一个匹配模式的位置
    ${CYAN}vim -R file${NC}          - 以只读模式打开文件
    ${CYAN}vim -O file1 file2${NC}   - 在分割窗口中打开多个文件

在 vim 中:
    ${GREEN}i${NC}                   - 进入插入模式
    ${GREEN}ESC${NC}                 - 返回普通模式
    ${GREEN}:w${NC}                  - 保存文件
    ${GREEN}:q${NC}                  - 退出 vim
    ${GREEN}:wq${NC}                 - 保存并退出
    ${GREEN}:q!${NC}                 - 强制退出不保存
    ${GREEN}/pattern${NC}            - 向前搜索模式
    ${GREEN}?pattern${NC}            - 向后搜索模式
    ${GREEN}n${NC}                   - 重复上一次搜索
    ${GREEN}N${NC}                   - 反向重复上一次搜索
    ${GREEN}:%s/old/new/g${NC}       - 全局替换
    ${GREEN}:set number${NC}         - 显示行号
    ${GREEN}:set nonumber${NC}       - 隐藏行号
    ${GREEN}:syntax on${NC}          - 启用语法高亮
    ${GREEN}:syntax off${NC}         - 禁用语法高亮

常用选项:
    ${CYAN}-b${NC} binary                - 以二进制模式打开文件
    ${CYAN}-c${NC} command               - 打开文件后执行指定命令
    ${CYAN}-d${NC} device                - 编辑特定设备文件
    ${CYAN}-o${NC}                       - 只允许一个窗口打开
    ${CYAN}-R${NC} readonly              - 以只读模式打开
    ${CYAN}-v${NC} verbose               - 启动时显示版本信息
    ${CYAN}-x${NC}                       - 使用加密写入文件交换

示例:
    ${YELLOW}vim +123 file.txt${NC}            - 打开文件并定位到第123行
    ${YELLOW}vim +/error log.txt${NC}          - 打开文件并定位到第一个"error"出现的位置
    ${YELLOW}vim -O file1.txt file2.txt${NC}   - 在水平分割窗口中打开两个文件
    ${YELLOW}vim -c \":set nu\" file.txt${NC}  - 打开文件并启用行号显示

高级功能:
    ${YELLOW}可视模式${NC} - 按 v 进入字符可视模式，按 V 进入行可视模式，按 Ctrl+v 进入块可视模式
    ${YELLOW}分屏操作${NC} - :split 水平分屏，:vsplit 垂直分屏，Ctrl+w 切换窗口
    ${YELLOW}标签页${NC}   - :tabnew 新建标签页，:tabnext 切换到下一个标签页，gt 切换标签页
    ${YELLOW}宏录制${NC}   - qa 开始录制宏到寄存器 a，q 停止录制，@a 执行宏 a
    ${YELLOW}折叠${NC}     - zf 创建折叠，zo 打开折叠，zc 关闭折叠

建议:
    ${YELLOW}- 使用 ${CYAN}vimtutor${NC} 可以学习 vim 的基本操作
    ${YELLOW}- 使用 ${CYAN}:help${NC} 可以在 vim 内部查看帮助
    ${YELLOW}- 使用 ${CYAN}:set paste${NC} 可以在粘贴代码时保持格式
    ${YELLOW}- 使用 ${CYAN}:colorscheme colors_name${NC} 可以更改配色方案
    ${YELLOW}- 使用 ${CYAN}:set autoindent${NC} 可以自动缩进
    ${YELLOW}- 使用 ${CYAN}:set ignorecase${NC} 可以在搜索时忽略大小写"
}

############################################################################################
#                              应用命令帮助数据库
############################################################################################
init_app_help_db() {
    # Docker 相关命令
    APP_COMMAND_HELP["docker"]="docker - Docker 是一个开源的容器化平台，用于开发、交付和运行应用程序

常用用法:
  ${CYAN}docker${NC}                  - 显示所有 Docker 命令
  ${CYAN}docker command --help${NC}   - 显示特定命令的帮助信息

容器生命周期管理:
  ${CYAN}docker run [options] image [command]${NC} - 使用镜像创建并启动一个新容器
  ${CYAN}docker start/stop/restart container${NC}  - 启动/停止/重启容器
  ${CYAN}docker rm container${NC}                  - 删除容器
  ${CYAN}docker kill container${NC}                - 强制停止容器
  
容器操作:
  ${CYAN}docker ps [options]${NC}                     - 列出容器
  ${CYAN}docker exec [options] container command${NC} - 在运行中的容器中执行命令
  ${CYAN}docker logs [options] container${NC}         - 获取容器的日志
  ${CYAN}docker inspect container${NC}                - 返回容器或镜像的底层信息
  
镜像管理:
  ${CYAN}docker images [options]${NC}          - 列出镜像
  ${CYAN}docker pull [options] name[:tag]${NC} - 从仓库拉取镜像
  ${CYAN}docker push [options] name[:tag]${NC} - 推送镜像到仓库
  ${CYAN}docker rmi [options] image${NC}       - 删除镜像

示例:
  ${YELLOW}docker run -it ubuntu /bin/bash${NC}                - 启动一个交互式 Ubuntu 容器
  ${YELLOW}docker run -d --name mynginx -p 8080:80 nginx${NC}  - 后台运行 Nginx 容器并映射端口
  ${YELLOW}docker exec -it mynginx /bin/bash${NC}              - 进入运行中的 mynginx 容器
  ${YELLOW}docker run -v /host/path:/container/path image${NC} - 挂载主机目录到容器
  ${YELLOW}docker run --rm image${NC}               - 容器退出时自动删除
  ${YELLOW}docker run -e VAR=value image${NC}       - 设置环境变量
  ${YELLOW}docker build -t myimage:tag .${NC}       - 从当前目录的 Dockerfile 构建镜像
  ${YELLOW}docker commit container myimage:tag${NC} - 将容器保存为新镜像
  
进入容器的方法:
  ${YELLOW}docker exec -it container_name /bin/bash${NC}    - 进入正在运行的容器（推荐）
  ${YELLOW}docker attach container_name${NC}                - 连接到容器的主进程（退出会停止容器）
  ${YELLOW}docker run -it --entrypoint /bin/bash image${NC} - 使用 bash 作为入口点启动容器
  
使用镜像创建容器:
  ${YELLOW}docker run -d --name webserver nginx:latest${NC}    - 使用最新版 nginx 镜像创建名为 webserver 的容器
  ${YELLOW}docker run -d -p 80:80 --restart always nginx${NC}  - 创建容器并设置自动重启
  ${YELLOW}docker run -d --network=host myimage${NC}           - 使用主机网络模式创建容器
  ${YELLOW}docker run -d --memory=512m --cpus=1 myimage${NC}   - 限制容器内存和CPU使用
  
建议:
  - 使用 ${CYAN}docker --version${NC} 查看 Docker 版本
  - 使用 ${CYAN}docker info${NC} 查看 Docker 系统信息
  - 使用 ${CYAN}docker stats${NC} 查看容器资源使用情况
  - 使用 ${CYAN}docker system prune${NC} 清理未使用的 Docker 对象
  - 使用 ${CYAN}docker update --memory=1g container${NC} 更新运行中容器的资源限制"

    APP_COMMAND_HELP["docker-common"]="docker-common - Docker 常用命令组合

常用用法:
  ${CYAN}docker ps -a${NC}              - 列出所有容器（包括停止的）
  ${CYAN}docker images -a${NC}          - 列出所有镜像（包括中间层）
  ${CYAN}docker system df${NC}          - 显示 Docker 磁盘使用情况
  ${CYAN}docker system prune${NC}       - 清理未使用的 Docker 对象
  
示例:
  ${YELLOW}docker run -d -p 8080:80 nginx${NC}           - 后台运行 Nginx 并将容器 80 端口映射到主机 8080 端口
  ${YELLOW}docker exec -it container_id bash${NC}        - 在运行中的容器中执行交互式 bash
  ${YELLOW}docker commit container_id my-image:tag${NC}  - 将容器保存为新镜像
  ${YELLOW}docker save -o my-image.tar my-image:tag${NC} - 将镜像保存为 tar 文件
  ${YELLOW}docker load -i my-image.tar${NC}              - 从 tar 文件加载镜像
  
建议:
  - 使用 ${CYAN}docker inspect container_id${NC} 查看容器详细信息
  - 使用 ${CYAN}docker logs container_id${NC} 查看容器日志
  - 使用 ${CYAN}docker port container_id${NC} 查看容器的端口映射"

    # Kubernetes 相关命令
    APP_COMMAND_HELP["kubectl"]="kubectl - Kubernetes 命令行工具，用于控制 Kubernetes 集群

常用用法:
  ${CYAN}kubectl get pods${NC}         - 列出所有 Pod
  ${CYAN}kubectl get services${NC}     - 列出所有服务
  ${CYAN}kubectl get deployments${NC}  - 列出所有部署
  ${CYAN}kubectl describe pod pod_name${NC} - 显示 Pod 的详细信息
  ${CYAN}kubectl logs pod_name${NC}    - 查看 Pod 的日志
  ${CYAN}kubectl exec -it pod_name bash${NC} - 在 Pod 中执行交互式 bash
  
示例:
  ${YELLOW}kubectl create -f deployment.yaml${NC}   - 从文件创建资源
  ${YELLOW}kubectl apply -f deployment.yaml${NC}    - 应用配置到资源
  ${YELLOW}kubectl delete pod pod_name${NC}         - 删除指定的 Pod
  ${YELLOW}kubectl scale deployment deploy_name --replicas=3${NC} - 扩展部署
  ${YELLOW}kubectl port-forward pod_name 8080:80${NC}             - 将 Pod 的 80 端口转发到本地 8080 端口
  
建议:
  - 使用 ${CYAN}kubectl get all${NC} 查看所有资源
  - 使用 ${CYAN}kubectl cluster-info${NC} 查看集群信息
  - 使用 ${CYAN}kubectl config view${NC} 查看当前配置
  - 使用 ${CYAN}kubectl version${NC} 查看 Kubernetes 版本"

    APP_COMMAND_HELP["kuber"]="kuber - Kubernetes 常用命令集合（kubectl 的简写别名）

常用用法:
  ${CYAN}kuber get pods${NC}           - 列出所有 Pod
  ${CYAN}kuber get svc${NC}            - 列出所有服务
  ${CYAN}kuber get deploy${NC}         - 列出所有部署
  ${CYAN}kuber describe pod pod_name${NC} - 显示 Pod 的详细信息
  ${CYAN}kuber logs pod_name${NC}      - 查看 Pod 的日志
  
示例:
  ${YELLOW}kuber create -f deployment.yaml${NC}  - 从文件创建资源
  ${YELLOW}kuber apply -f deployment.yaml${NC}   - 应用配置到资源
  ${YELLOW}kuber delete pod pod_name${NC}        - 删除指定的 Pod
  ${YELLOW}kuber scale deploy deploy_name --replicas=3${NC} - 扩展部署
  
建议:
  - 使用 ${CYAN}alias kuber=kubectl${NC} 设置 kuber 为 kubectl 的别名
  - 使用 ${CYAN}kuber get all${NC} 查看所有资源
  - 使用 ${CYAN}kuber cluster-info${NC} 查看集群信息"

    APP_COMMAND_HELP["helm"]="helm - Kubernetes 的包管理器，用于管理预配置的 Kubernetes 资源包

常用用法:
  ${CYAN}helm search hub${NC}                      - 在 Helm Hub 中搜索 charts
  ${CYAN}helm install release_name chart_name${NC} - 安装 chart
  ${CYAN}helm list${NC}                            - 列出所有 releases
  ${CYAN}helm status release_name${NC}             - 显示 release 状态
  ${CYAN}helm uninstall release_name${NC}          - 卸载 release
  
示例:
  ${YELLOW}helm repo add stable https://charts.helm.sh/stable${NC} - 添加 stable 仓库
  ${YELLOW}helm install my-nginx stable/nginx-ingress${NC}         - 安装 nginx-ingress chart
  ${YELLOW}helm upgrade my-release chart_name${NC}                 - 升级 release
  ${YELLOW}helm rollback my-release 1${NC}                         - 回滚 release 到版本 1
  ${YELLOW}helm pull chart_name --untar${NC}                       - 下载并解压 chart
  
建议:
  - 使用 ${CYAN}helm version${NC} 查看 Helm 版本
  - 使用 ${CYAN}helm repo list${NC} 列出已配置的仓库
  - 使用 ${CYAN}helm inspect chart chart_name${NC} 查看 chart 详细信息
  - 使用 ${CYAN}helm dependency update${NC} 更新 chart 依赖"
}

############################################################################################
#                                      搜索相关
############################################################################################
# 模糊搜索命令
fuzzy_search_commands() {
    local pattern="$1"
    
    # 只初始化命令描述缓存，不加载完整的帮助数据库
    init_command_cache
    
    echo -e "${GREEN}匹配 '$pattern' 的命令:${NC}"
    echo -e "${CYAN}================================================================================${NC}"
    
    # 搜索基础命令
    echo -e "${BLUE}基础命令:${NC}"
    echo -e "${CYAN}----------------------------------------${NC}"
    
    local found=0
    
    # 将通配符模式转换为正则表达式
    local regex_pattern="${pattern//\*/.*}"
    
    for cmd in "${BASIC_CMDS[@]}"; do
        if [[ "$cmd" =~ ^${regex_pattern} ]]; then
            local description="${COMMAND_DESCRIPTIONS[$cmd]}"
            printf "${YELLOW}%-15s${NC} ${BLUE}%s${NC}\n" "$cmd" "$description"
            found=1
        fi
    done
    
    # 搜索应用级命令
    echo -e ""
    echo -e "${BLUE}应用级命令:${NC}"
    echo -e "${CYAN}----------------------------------------${NC}"
    
    for cmd in "${APP_CMDS[@]}"; do
        if [[ "$cmd" =~ ^${regex_pattern} ]]; then
            local description="${COMMAND_DESCRIPTIONS[$cmd]}"
            printf "${YELLOW}%-15s${NC} ${BLUE}%s${NC}\n" "$cmd" "$description"
            found=1
        fi
    done
    
    echo -e "${CYAN}================================================================================${NC}"
    
    if [[ $found -eq 0 ]]; then
        echo -e "${RED}没有找到匹配 '$pattern' 的命令${NC}"
    fi
}

############################################################################################
#                                      显示相关
############################################################################################


# 显示分类推荐信息
show_category_recommendations() {
    local category="$1"
    
    echo -e "${GREEN}推荐 '$category' 相关命令:${NC}"
    echo -e "${CYAN}================================================================================${NC}"
    
    # 根据分类显示推荐信息
    case "$category" in
        "网络"|"网络相关"|"network")
            echo -e "${BLUE}网络相关命令推荐:${NC}"
            echo -e "${CYAN}----------------------------------------${NC}"
            echo -e "${YELLOW}推荐使用场景:${NC} 网络诊断、连接测试、网络配置、数据传输"
            echo ""
            echo -e "${GREEN}基础网络命令:${NC}"
            for cmd in "ip" "ping" "netstat" "ss" "curl" "wget"; do
                if [[ " ${BASIC_CMDS[@]} " =~ " $cmd " ]]; then
                    local description="${COMMAND_DESCRIPTIONS[$cmd]}"
                    printf "${YELLOW}%-15s${NC} ${BLUE}%s${NC}\n" "$cmd" "$description"
                fi
            done
            echo ""
            echo -e "${GREEN}远程连接命令:${NC}"
            for cmd in "ssh" "scp"; do
                if [[ " ${BASIC_CMDS[@]} " =~ " $cmd " ]]; then
                    local description="${COMMAND_DESCRIPTIONS[$cmd]}"
                    printf "${YELLOW}%-15s${NC} ${BLUE}%s${NC}\n" "$cmd" "$description"
                fi
            done
            echo ""
            echo -e "${PURPLE}网络命令使用技巧:${NC}"
            echo -e "  1. 使用 ${CYAN}ip addr${NC} 替代传统的 ${CYAN}ifconfig${NC} 命令查看网络接口"
            echo -e "  2. 使用 ${CYAN}ping -c 4${NC} 限制ping包数量，避免无限ping"
            echo -e "  3. 使用 ${CYAN}ss -tuln${NC} 替代 ${CYAN}netstat -tuln${NC} 查看监听端口，性能更好"
            echo -e "  4. 使用 ${CYAN}curl -I${NC} 只获取HTTP头信息，不下载内容"
            echo -e "  5. 使用 ${CYAN}wget -c${NC} 支持断点续传下载大文件"
            echo -e "  6. 使用 ${CYAN}ssh -i keyfile${NC} 指定密钥文件进行安全连接"
            echo -e "  7. 使用 ${CYAN}scp -r${NC} 递归复制整个目录到远程主机"
            ;;
        "文件"|"文件操作"|"字符串"|"file"|"string")
            echo -e "${BLUE}文件操作命令推荐:${NC}"
            echo -e "${CYAN}----------------------------------------${NC}"
            echo -e "${YELLOW}推荐使用场景:${NC} 文件查找、内容查看、编辑、权限管理"
            echo ""
            echo -e "${GREEN}基础文件操作命令:${NC}"
            for cmd in "ls" "cd" "pwd" "mkdir" "rm" "cp" "mv"; do
                if [[ " ${BASIC_CMDS[@]} " =~ " $cmd " ]]; then
                    local description="${COMMAND_DESCRIPTIONS[$cmd]}"
                    printf "${YELLOW}%-15s${NC} ${BLUE}%s${NC}\n" "$cmd" "$description"
                fi
            done
            echo ""
            echo -e "${GREEN}文件查找与内容查看:${NC}"
            for cmd in "find" "grep" "cat" "less" "head" "tail"; do
                if [[ " ${BASIC_CMDS[@]} " =~ " $cmd " ]]; then
                    local description="${COMMAND_DESCRIPTIONS[$cmd]}"
                    printf "${YELLOW}%-15s${NC} ${BLUE}%s${NC}\n" "$cmd" "$description"
                fi
            done
            echo ""
            echo -e "${GREEN}文本处理与编辑:${NC}"
            for cmd in "awk" "cut" "wc" "vim"; do
                if [[ " ${BASIC_CMDS[@]} " =~ " $cmd " ]]; then
                    local description="${COMMAND_DESCRIPTIONS[$cmd]}"
                    printf "${YELLOW}%-15s${NC} ${BLUE}%s${NC}\n" "$cmd" "$description"
                fi
            done
            echo ""
            echo -e "${PURPLE}文件操作技巧:${NC}"
            echo -e "  1. 使用 ${CYAN}ls -lh${NC} 以人类可读格式显示文件大小"
            echo -e "  2. 使用 ${CYAN}find . -name '*.log' -mtime +7${NC} 查找7天前修改的日志文件"
            echo -e "  3. 使用 ${CYAN}grep -r 'error' /var/log${NC} 递归搜索日志中的错误"
            echo -e "  4. 使用 ${CYAN}less +F file${NC} 实时跟踪文件变化（类似tail -f）"
            echo -e "  5. 使用 ${CYAN}vimtutor${NC} 学习vim基本操作"
            echo -e "  6. 使用 ${CYAN}awk '{print $1}' file${NC} 提取每行第一个字段"
            echo -e "  7. 使用 ${CYAN}wc -l *.py${NC} 统计所有Python文件的总行数"
            ;;
        "系统"|"系统信息"|"system")
            echo -e "${BLUE}系统信息命令推荐:${NC}"
            echo -e "${CYAN}----------------------------------------${NC}"
            echo -e "${YELLOW}推荐使用场景:${NC} 系统监控、性能分析、进程管理"
            echo ""
            echo -e "${GREEN}系统信息查看:${NC}"
            for cmd in "uname" "df" "du" "free"; do
                if [[ " ${BASIC_CMDS[@]} " =~ " $cmd " ]]; then
                    local description="${COMMAND_DESCRIPTIONS[$cmd]}"
                    printf "${YELLOW}%-15s${NC} ${BLUE}%s${NC}\n" "$cmd" "$description"
                fi
            done
            echo ""
            echo -e "${GREEN}进程管理:${NC}"
            for cmd in "top" "ps" "kill"; do
                if [[ " ${BASIC_CMDS[@]} " =~ " $cmd " ]]; then
                    local description="${COMMAND_DESCRIPTIONS[$cmd]}"
                    printf "${YELLOW}%-15s${NC} ${BLUE}%s${NC}\n" "$cmd" "$description"
                fi
            done
            echo ""
            echo -e "${PURPLE}系统监控技巧:${NC}"
            echo -e "  1. 使用 ${CYAN}free -h${NC} 以人类可读格式查看内存使用情况"
            echo -e "  2. 使用 ${CYAN}df -h${NC} 查看磁盘空间使用情况"
            echo -e "  3. 使用 ${CYAN}du -sh *${NC} 查看当前目录下各项目大小"
            echo -e "  4. 使用 ${CYAN}top -u username${NC} 只查看特定用户的进程"
            echo -e "  5. 使用 ${CYAN}ps aux --sort=-%cpu${NC} 按CPU使用率排序进程"
            echo -e "  6. 使用 ${CYAN}kill -9 PID${NC} 强制终止无响应进程"
            echo -e "  7. 使用 ${CYAN}uname -a${NC} 查看完整系统信息"
            ;;
        "压缩"|"解压"|"压缩解压"|"compress")
            echo -e "${BLUE}压缩解压命令推荐:${NC}"
            echo -e "${CYAN}----------------------------------------${NC}"
            echo -e "${YELLOW}推荐使用场景:${NC} 文件打包、压缩、备份、解压"
            echo ""
            echo -e "${GREEN}压缩解压命令:${NC}"
            for cmd in "tar" "zip"; do
                if [[ " ${BASIC_CMDS[@]} " =~ " $cmd " ]]; then
                    local description="${COMMAND_DESCRIPTIONS[$cmd]}"
                    printf "${YELLOW}%-15s${NC} ${BLUE}%s${NC}\n" "$cmd" "$description"
                fi
            done
            echo ""
            echo -e "${PURPLE}压缩解压技巧:${NC}"
            echo -e "  1. 使用 ${CYAN}tar -czvf archive.tar.gz dir${NC} 创建gzip压缩的tar归档"
            echo -e "  2. 使用 ${CYAN}tar -xzvf archive.tar.gz${NC} 解压gzip压缩的tar归档"
            echo -e "  3. 使用 ${CYAN}tar -tzvf archive.tar.gz${NC} 查看压缩归档内容不解压"
            echo -e "  4. 使用 ${CYAN}zip -r archive.zip directory${NC} 递归压缩目录"
            echo -e "  5. 使用 ${CYAN}unzip -l archive.zip${NC} 列出zip归档内容"
            echo -e "  6. 使用 ${CYAN}tar -cvf archive.tar file1 file2${NC} 创建未压缩的tar归档"
            echo -e "  7. 使用 ${CYAN}zip -r -e secure.zip secret/${NC} 创建加密的zip文件"
            ;;
        "传输"|"传输同步"|"transfer")
            echo -e "${BLUE}传输同步命令推荐:${NC}"
            echo -e "${CYAN}----------------------------------------${NC}"
            echo -e "${YELLOW}推荐使用场景:${NC} 文件传输、远程同步、备份"
            echo ""
            echo -e "${GREEN}传输同步命令:${NC}"
            for cmd in "ssh" "scp" "rsync"; do
                if [[ " ${BASIC_CMDS[@]} " =~ " $cmd " ]]; then
                    local description="${COMMAND_DESCRIPTIONS[$cmd]}"
                    printf "${YELLOW}%-15s${NC} ${BLUE}%s${NC}\n" "$cmd" "$description"
                fi
            done
            echo ""
            echo -e "${PURPLE}传输同步技巧:${NC}"
            echo -e "  1. 使用 ${CYAN}ssh -p port user@host${NC} 指定端口连接远程主机"
            echo -e "  2. 使用 ${CYAN}scp -r dir user@host:/path${NC} 递归复制整个目录"
            echo -e "  3. 使用 ${CYAN}rsync -avz --progress src/ dest/${NC} 压缩传输并显示进度"
            echo -e "  4. 使用 ${CYAN}rsync -av --delete src/ dest/${NC} 同步并删除目标中源没有的文件"
            echo -e "  5. 使用 ${CYAN}ssh -L 8080:localhost:80 user@host${NC} 设置端口转发"
            echo -e "  6. 使用 ${CYAN}rsync -e ssh source user@host:/path${NC} 通过SSH同步"
            echo -e "  7. 使用 ${CYAN}scp -i keyfile file user@host:/path${NC} 使用密钥文件安全传输"
            ;;
        *)
            echo -e "${RED}未知的分类 '$category'${NC}"
            echo -e "${YELLOW}支持的分类:${NC}"
            echo -e "${CYAN}网络, 文件, 系统, 压缩, 传输${NC}"
            echo ""
            echo -e "${GREEN}使用示例:${NC}"
            echo -e "  $0 -h network      显示网络相关命令推荐"
            echo -e "  $0 -h file         显示文件操作命令推荐"
            echo -e "  $0 -h system       显示系统信息命令推荐"
            echo -e "  $0 -h compress     显示压缩解压命令推荐"
            echo -e "  $0 -h transfer     显示传输同步命令推荐"
            ;;
    esac
    
    echo -e "${CYAN}================================================================================${NC}"
}

# 显示所有支持的命令
list_commands() {
    echo -e "${GREEN}支持的命令列表:${NC}"
    echo -e "${CYAN}================================================================================${NC}"

    # 显示基础命令
    echo -e "${BLUE}基础命令:${NC}"
    echo -e "${CYAN}----------------------------------------${NC}"
    
    # 对命令进行排序
    IFS=$'\n' sorted_basic=($(sort <<<"${BASIC_CMDS[*]}"))
    unset IFS
    
    for cmd in "${sorted_basic[@]}"; do
        # 直接从缓存中获取描述
        local description="${COMMAND_DESCRIPTIONS[$cmd]}"
        # 格式化输出，命令名左对齐，宽度为15，然后是说明
        printf "${YELLOW}%-15s${NC} ${BLUE}%s${NC}\n" "$cmd" "$description"
    done

    # 显示应用级命令
    echo -e ""
    echo -e "${BLUE}应用级命令:${NC}"
    echo -e "${CYAN}----------------------------------------${NC}"
       
    # 对命令进行排序
    IFS=$'\n' sorted_app=($(sort <<<"${APP_CMDS[*]}"))
    unset IFS
    
    # 显示应用级命令及其简要说明
    for cmd in "${sorted_app[@]}"; do
        # 直接从缓存中获取描述
        local description="${COMMAND_DESCRIPTIONS[$cmd]}"
        # 格式化输出，命令名左对齐，宽度为15，然后是说明
        printf "${YELLOW}%-15s${NC} ${BLUE}%s${NC}\n" "$cmd" "$description"
    done

    echo -e "${CYAN}================================================================================${NC}"
    echo -e "${GREEN}使用: $0 <命令> [命令2] [命令3] ...${NC}"
    echo -e "${GREEN}例如: $0 ip grep${NC}"
}

# 显示命令帮助
show_help() {
    for cmd in "$@"; do
        if [[ -n "${BASIC_COMMAND_HELP[$cmd]}" ]]; then
            echo -e "${GREEN}=== $cmd 命令帮助 ===${NC}"
            echo -e "${BASIC_COMMAND_HELP[$cmd]}"
            echo ""
        elif [[ -n "${APP_COMMAND_HELP[$cmd]}" ]]; then
            echo -e "${GREEN}=== $cmd 命令帮助 ===${NC}"
            echo -e "${APP_COMMAND_HELP[$cmd]}"
            echo ""
        else
            echo -e "${RED}错误: 没有找到 '$cmd' 的帮助信息${NC}"
            echo -e "${YELLOW}使用 '$0 -l' 查看所有支持的命令${NC}"
            echo ""
        fi
    done
}

# 显示使用说明
show_usage() {
    echo -e "${GREEN}Shell 命令帮助工具${NC}"
    echo -e "${CYAN}用法: $0 [选项] [命令1] [命令2] ...${NC}"
    echo ""
    echo -e "${YELLOW}选项:${NC}"
    echo -e "  ${BLUE}-l${NC}         列出所有支持的命令"
    echo -e "  ${BLUE}-h [分类]${NC}  显示帮助信息或分类推荐信息"
    echo ""
    echo -e "${YELLOW}示例:${NC}"
    echo -e "  $0 ip                  显示ip命令的帮助"
    echo -e "  $0 ip grep             显示ip和grep命令的帮助"
    echo -e "  $0 -l                  列出所有支持的命令"
    echo ""
    echo -e "${YELLOW}分类推荐示例:${NC}"
    echo -e "  $0 -h network          显示网络相关命令推荐"
    echo -e "  $0 -h file             显示文件操作命令推荐"
    echo -e "  $0 -h system           显示系统信息命令推荐"
    echo -e "  $0 -h compress         显示压缩解压命令推荐"
    echo -e "  $0 -h transfer         显示传输同步命令推荐"
}

############################################################################################
#                                        main
############################################################################################
main() {  
    # 处理命令行参数
    if [[ $# -eq 0 ]]; then
        show_usage
        exit 1
    fi
    
    case "$1" in
        -l|-list|--list)
            # 只初始化命令描述缓存，不加载完整的帮助数据库
            init_command_cache
            list_commands
            ;;
        -h|-help|--help)
            # 检查是否有额外参数
            if [[ $# -gt 1 ]]; then
                # 初始化命令描述缓存
                init_command_cache
                # 显示分类推荐信息
                show_category_recommendations "$2"
            else
                show_usage
            fi
            ;;
        *\**)
            # 处理模糊搜索模式（如 s*）
            fuzzy_search_commands "$1"
            ;;
        *)
            # 初始化完整的帮助数据库以显示详细的命令帮助
            init_basic_help_db
            init_app_help_db
            show_help "$@"
            ;;
    esac
}

# 执行主函数
main "$@"