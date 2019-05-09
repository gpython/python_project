history | cut -c 8-
history | awk '{$1="";print substr($0,2)}'
history | sed 's/^[ ]*[0-9]\+[ ]*//'

alias history="history | sed 's/^[ ]*[0-9]\+[ ]*//'"
history | cut -d' ' -f4- | sed 's/^ \(.*$\)/\1/g'

#安装killall
yum install psmisc
killall -0 nginx > /tmp/nginx.log
killall -0 nginx
  #发0信号 探测nginx 服务是否启动
  #$?返回0 服务启动无问题 返回非0 服务启动有问题
  $!保存着最近一个后台进程的PID
  $$ 表示当前脚本的进程 ID

 set –x：在执行时显示参数和命令。
 set +x：禁止调试


 $1是第一个参数。
 $2是第二个参数。
 $n是第n个参数。
 "$@" 被扩展成 "$1" "$2" "$3"等。
 "$*" 被扩展成 "$1c$2c$3"，其中c是IFS的第一个字符。
 "$@" 要比"$*"用得多。由于 "$*"将所有的参数当做单个字符串，因此它很少被使用




pgrep
  直接获取某个 具体名称 应用的pid
  pgrep nginx
  pidof nginx

cat /proc/12501/environ
  每一个变量以name=value的形式来描述，彼此之间由null字符（\0）分隔

  cat /proc/$$/environ | tr '\0' '\n'

export命令用来设置环境变量。至此之后，从当前shell脚本执行的任何应用程序都会继承这个变量

要列出占用CPU最多的10个进程
ps -eo comm,pcpu --sort -pcpu | head
ps -eo user,pid,comm,pcpu,pmem --sort -pcpu | head

选项 –L 在ps输出中显示线程的相关信息
NLWP和NLP。NLWP是进程的线程数量，NLP是ps输出中每个条目的线程ID






获取字符床长度
var=googogoogogogog
length=${#var}

检查是否为超级用户
echo ${UID}

在Bash shell环境中，可以利用let、(( ))和[]执行基本的算术操作。而在进行高级操作时，
expr和bc这两个工具也会非常有用
r=10
echo $[$r+10]
echo $(($r+10))
echo `expr $r + 10`

cat > /tmp/t.log << TOM
dsfs
sd
fsd
f
TOM

cat << TOM > /tmp/t.log
sdfds
f
sdf
sd
f
TOM


date -d "1 days ago" +"%F %T %s"
date -d @1556287925 +"%F %T"


子shell本身就是独立的进程。可以使用()操作符来定义一个子shell

#重复执行 延迟等待
repeat() { while :; do $@ && return; sleep 30; done }
repeat wget -c http://www.example.com/software-0.1.tar.gz

字段分隔符和迭代器
内部字段分隔符（Internal Field Separator，IFS）
我们需要迭代一个字符串或逗号分隔型数值（Comma Separated Value，CSV）中
的单词。如果是前一种，则使用IFS="."；如果是后一种，则使用IFS=","
```
#!/bin/bash
data="name.sex.google.yahoo.heooo.linux.ssss"

oldIFS=$IFS
IFS=.

for item in $data
do
  echo item: ${item}
done

IFS=$oldIFS
```

for((i=0;i<10;i++))
{
 commands; #使用变量$i
}

 ########算术比较######

对变量或值进行算术条件判断：
[ $var -eq 0 ] #当 $var 等于 0 时，返回真
[ $var -ne 0 ] #当 $var 为非 0 时，返回真
其他重要的操作符如下所示。
 -gt：大于。
 -lt：小于。
 -ge：大于或等于。
 -le：小于或等于。
[ $var1 -ne 0 -a $var2 -gt 2 ] #使用逻辑与-a
[ $var1 -ne 0 -o var2 -gt 2 ] #逻辑或 -o

 文件系统相关测试
我们可以使用不同的条件标志测试不同的文件系统相关的属性。
 [ -f $file_var ]：如果给定的变量包含正常的文件路径或文件名，则返回真。
 [ -x $var ]：如果给定的变量包含的文件可执行，则返回真。
 [ -d $var ]：如果给定的变量包含的是目录，则返回真。
 [ -e $var ]：如果给定的变量包含的文件存在，则返回真。
 [ -c $var ]：如果给定的变量包含的是一个字符设备文件的路径，则返回真。
 [ -b $var ]：如果给定的变量包含的是一个块设备文件的路径，则返回真。
 [ -w $var ]：如果给定的变量包含的文件可写，则返回真。
 [ -r $var ]：如果给定的变量包含的文件可读，则返回真。
 [ -L $var ]：如果给定的变量包含的是一个符号链接，则返回真。

test命令可以用来执行条件检测。用test可以避免使用过多的括号

test -f /etc/passwssd && echo "google" || echo "yahoo"

例如：
if [ $var -eq 0 ]; then echo "True"; fi
也可以写成：
if test $var -eq 0 ; then echo "True"; fi



 字符串比较 最好用双中括号

 [[ $str1 = $str2 ]]：当str1等于str2时，返回真。也就是说，str1和str2包含
的文本是一模一样的。
 [[ $str1 == $str2 ]]：这是检查字符串是否相等的另一种写法。
也可以检查两个字符串是否不同。
 [[ $str1 != $str2 ]]：如果str1和str2不相同，则返回真。
我们还可以检查字符串的字母序情况，具体如下所示。
 [[ $str1 > $str2 ]]：如果str1的字母序比str2大，则返回真。
 [[ $str1 < $str2 ]]：如果str1的字母序比str2小，则返回真。
 [[ -z $str1 ]]：如果str1包含的是空字符串，则返回真。
 [[ -n $str1 ]]：如果str1包含的是非空字符串，则返回真。

if [[ -n $str1 ]] && [[ -z $str2 ]] ;
then
 commands;
fi


用cat将来自输入文件的内容与标准输入拼接在一起
echo googogogogo | cat - /etc/passwd


find
  -print0指明使用'\0'作为匹配的文件名之间的定界符。当文件名中包含换行符时，这个方法就有用武之地了
  find . -type f \( -name "*,mp4" -o -name "*.flv" \) -print
  find ./ -maxdepth 2 -type f \( -name "*.mp4" -o -name "*.flv" \) -print
  find ./ -type f -name "*.vim" -user root -perm 644 -exec cat {} \; >./ttt.cc


在Unix中并没有所谓“创建时间”的概念
天 计量单位
 访问时间（-atime）：用户最近一次访问文件的时间。
 修改时间（-mtime）：文件内容最后一次被修改的时间。
 变化时间（-ctime）：文件元数据（例如权限或所有权）最后一次改变的时间

分钟 计量单位
 -amin（访问时间）
 -mmin（修改时间）
 -cmin（变化时间）



xargs命令把从stdin接收到的数据重新格式化，再将其作为参数提供给其他命令
  指定每行最大的参数数量n
  用-d选项为输入指定一个定制的定界符

  将 -print0与find结合使用，以字符null（'\0'）来分隔输出 xargs -0将\0作为输入定界符
  find . -type f -name "*.txt" -print0 | xargs -0 rm -f

sort
  -n 数组排序
  -r 逆序排序
  -k 指定了排序应该按照哪一个键（key）来进行


扩展名切分
  file_jpg="sample.jpg"
  name=${file_jpg%.*}
  echo File name is: $name
  extension=${file_jpg#*.}


for ip in 192.168.0.{1..255} ;
do
 (
 ping $ip -c2 &> /dev/null ;

 if [ $? -eq 0 ];
 then
 echo $ip is alive
 fi
 )&
 done
wait

要使ping命令可以并行执行，可将循环体放入( )&。( )中的命令作为子shell
来运行，而&会将其置入后台
要想等所有子进程结束之后
再终止脚本，就得使用wait命令。将wait放在脚本最后，它就会一直等到所有的子脚本进程全
部结束


time
 Real时间指的是挂钟时间（wall clock time），也就是命令从开始执行到结束的时间。这段
时间包括其他进程所占用的时间片（time slice）以及进程被阻塞时所花费的时间（例如，
为等待I/O操作完成所用的时间）。

 User时间是指进程花费在用户模式（内核之外）中的CPU时间。这是唯一真正用于执行
进程所花费的时间。执行其他进程以及花费在阻塞状态中的时间并没有计算在内。

 Sys时间是指进程花费在内核中的CPU时间。它代表在内核中执行系统调用所使用的时
间，这和库代码（library code）不同，后者仍旧运行在用户空间。与“user时间”类似，
这也是真正由进程使用的CPU时间。



netstat -antp |tail -n +3 | awk '{ S[$6]++; }END{ for(i in S){print i,S[i]} }'





Nginx

1)、轮询（默认） 
      每个请求按时间顺序逐一分配到不同的后端服务器，如果后端服务器down掉，能自动剔除。 
2)、weight 
      指定轮询几率，weight和访问比率成正比，用于后端服务器性能不均的情况。 
3)、ip_hash 
      每个请求按访问ip的hash结果分配，这样每个访客固定访问一个后端服务器，可以解决session的问题


worker_processes
  worker_processes用来设置Nginx服务的进程数

worker_connections
  设置一个进程理论允许的最大连接数

worker_rlimit_nofile
  设置毎个进程的最大文件打开数

accept_mutex
  惊群
  当某一时刻只有一个网络连接到来时，多个睡眠进程会被同时叫醒，但只有一个进程可获得连接，如果每次唤醒的进程数目太多，会影响一部分系统性能。

sendfile
  使用开启或关闭是否使用sendfile()传输文件，普通应用应该设为on，下载等IO重负荷的应用应该设为off，因为大文件不适合放到buffer中。
  传统文件传输中（read／write方式）在实现上3其实是比较复杂的，需要经过多次上下文切换，当需要对一个文件传输时，传统方式是：

  调用read函数，文件数据被copy到内核缓冲区
  read函数返回，数据从内核缓冲区copy到用户缓冲区
  write函数调用，将文件数据从用户缓冲区copy到内核与socket相关的缓冲区
  数据从socket缓冲区copy到相关协议引擎

  从上面可以看出来，传统readwrite进行网络文件传输的方式，在过程中经历了四次copy操作。

  硬盘－>内核buffer->用户buffer->socket相关缓冲区->协议引擎

  而sendfile系统调用则提供了一种减少多次copy，提高文件传输性能的方法。流程如下：

  sendfile系统效用，文件数据被copy至内核缓冲区
  记录数据文职和长度相关的数据保存到socket相关缓存区
  实际数据由DMA模块直接发送到协议引擎

tcp_nopush
  sendfile为on时这里也应该设为on，数据包会累积一下再一起传输，可以提高一些传输效率

tcp_nodelay
  小的数据包不等待直接传输。默认为on。
  看上去是和tcp_nopush相反的功能，但是两边都为on时nginx也可以平衡这两个功能的使用。

Select
  对于一个描述符，可以关注其上面的Read事件、Write事件以及Exception事件
  创建三类事件描述符集合，分别用来处理Read事件的描述符、Write事件的描述符、Exception事件的描述符
  调用底层的select()函数，等待事件发生，轮询所有事件描述符集合的每一个事件描述符，检查是否有事件发生，有的话就处理

Epoll
  poll库跟select库都是创建一个待处理的事件列表，然后把这个列表发给内核，返回的时候，再去轮询检查这个列表，以判断事件是否发生
  比较好的方式是把列表的管理交由内核负责，一旦某种事件发生，内核就把发生事件的描述符列表通知给进程，这样就避免了轮询整个描述符列表

Cookie Session
  cookie机制采用的是在客户端保持状态的方案，
  而session机制采用的是在服务器端保持状态的方案
  由于服务器端保持状态的方案在客户端也需要保存一个标识，所以session机制可能需要借助于cookie机制来达到保存标识的目的

物理层
  把二进制转换成电流，把电流转换成二进制

数据链路层
  与数据链路层有关的设备：交换机
  通过电脑MAC地址（MAC地址由网卡决定）

网络层
  数据链路层中使用的物理地址（如MAC地址）仅解决 网络内部的寻址 问题
  不同 子网之间通信 时，为了识别和找到网络中的设备，每一子网中的设备都会被分配一个唯一的地址

传输层
  OSI下3层的主要任务是数据通信，上3层的任务是数据处理
  传输层（Transport Layer）是OSI模型的第4层 通信子网 和 资源子网 的接口和桥梁
  定义了一些传输数据的协议和端口号 TCP UDP 从下层接收的数据进行分段和传输，到达目的地址后再进行重组

会话层
  用户应用程序和网络之间的接口
  数据的传输是在会话层完成的，而不是传输层，传输层只是定义了数据传输的协议

表示层
  数据格式转换

应用层

  一个是TCP/UDP协议：对于网络管理的网络安全具有至关重要的意义
  一个是Socket：是应用层与传输层之间的桥梁

rsync可以对位于不同位置的文件和目录进行同步，它利用差异计
算以及压缩技术来最小化数据传输量。相对于cp命令，rsync的优势在于使用了高效的差异算法。
另外，它还支持网络数据传输。在进行复制的同时，rsync会比较源端和目的端的文件，只有当
文件有更新时才进行复制。rsync也支持压缩、加密等多种特性


