配置相关

```
//永不休眠
vi /etc/profile
TMOUT=0
source /etc/proflie

//grep 添加颜色
export GREP_OPTIONS="--color=auto"
```





```
if [ ] then  / 0:true 1:false
fi

-eq /等于
-ne /不等于
-gt /大于
-lt /小于
-ge /大于等于
-le /小于等于

-e filename 如果 filename存在，则为真 
-d filename 如果 filename为目录，则为真  
-f filename 如果 filename为常规文件，则为真 
-L filename 如果 filename为符号链接，则为真 
-r filename 如果 filename可读，则为真  
-w filename 如果 filename可写，则为真  
-x filename 如果 filename可执行，则为真 
-s filename 如果文件长度不为0，则为真 
-h filename 如果文件是软链接，则为真 
filename1 -nt filename2 如果 filename1比 filename2新，则为真。 
filename1 -ot filename2 如果 filename1比 filename2旧，则为真。 
```



# grep

```
grep -option（参数） ‘word’（关键词） file（文本文件）；

-v <str>        #反向查找（除了str之外）
-R/-r <path>    #遍历所有文件查找
-d <file>  #查找目录下所有文件
-n  #显示该行
-f <file> #指定范本文件查找，符合范本文件内容的
-e <string> #指定字符串作为范文文本
-A <n> #显示后n行
-B <n> #显示前n行
-C <n> #侠士前后n行
-c 统计行数
-i #忽略大小写
-w #全字符合的列

--color=auto

```



xargs（需要与其他命令配合使用）

```
xargs ：接收字段作为参数
find test/ -type f | xargs grep “venus”
=  grep “venus”

-a <file> 从文件读取输入
-e flag  遇到flag终止
-n <num> 每次执行时读取的个数
-i/l  一行一行赋值给{},可以用{}代替
	例：
		ls *.jpg | xargs -n1 -I {} cp {} /data/images #复制图片到/data/images
-L <num> 一次读取num行给command
-r no-run-if-empty 为空时xargs停止
-s <num> xargs后面的命令行最大字符数
-d 分隔符，默认是回车，可自定义
-0 将\0作为分隔符（定界符）
```



find

```
find [OPTION]... [路径]【条件】【处理动作】

-type [type]
f 普通文件
l 符号连接
d 目录
c 字符设备
b 块设备
s 套设备

-a|m|ctime(min) +|-n 时间戳【最近访问|内容修改|权限修改】 n天【前|内】


```

find + xargs

```
find . -type f -name “*.php” -print0 | xargs -0 wc -l
```



ps

```
ps 监控进程情况
-e 显示所有进程，环境变量
-f 全格式
-h 不显示标题
-l 长格式
-w 宽输出
-u 选择有效的用户id或者用户名
-a 显示所有进程，包括用户进程
a  显示显示终端上所有进程，包括和用户进程
r  只显示正在运行的进程
x  显示没有控制终端的进程

-ef
-xuf

```



```
realpath 用于获取指定目录或文件的绝对路径。
```

awk

```
常用命令选项
-F fs 指定描绘一行中数据字段的文件分隔符  默认为空格
-f file 指定读取程序的文件名
-v var=value 定义awk程序中使用的变量和默认值

注意：awk 程序脚本由左大括号和右大括号定义。脚本命令必须放置在两个大括号之间。由于awk命令行假定脚本是单文本字符串，所以必须将脚本包
括在单引号内。

awk程序运行优先级是:
    1)BEGIN: 在开始处理数据流之前执行，可选项
    2)program: 如何处理数据流，必选项
    3)END: 处理完数据流后执行，可选项

```





```
#!/bin/bash

#获取当前脚本所在位置  根路径下
cur_dir=$(dirname $(realpath $0))
#日志路径
log_dir=$cur_dir/check.log
echo "cur_dir: $cur_dir"
parent_dir=$(dirname $cur_dir)
#po名称
po_name=$(basename $cur_dir).po
#po文件路径
po_dir=$(find ${cur_dir} -name ${po_name})

#判断日志是否存在
if [ -d ${log_dir}];then
	continue
else
	$(touch ${log_dir})
	echo "create log file with the path: ${log_dir}" >> $log_dir
fi
```



