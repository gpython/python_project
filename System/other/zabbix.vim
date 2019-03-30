#主机监控
Host name:      被监控主机 主机名 agent_host_name
Visible name:   自定义 容易理解名称

Agent interface: 客户机的 IP 端口
Description: 描述

#中文更改字符集 /usr/share/fonts/dejavu
默认字符集文件 DejaVuSans.tff  备份
将微软雅黑 字符集更名为 DejaVuSans.tff


items监控项 监控的item 指标 有一个唯一的key
Applications应用集 监控项的组
Triggers触发器 表达式
Graphs图形 多个item值 变成图形
Web zabbix自带web方式监控
Interface 客户端IP:port xxx:10050
info 被监控主机有问题时 会显示


User Profile: zabbix 用户信息
password
Language
Theme

Url 登录后页面跳转到的URL (Screen)


#报警
Administration -> Media Type -> Email
UserProfile -> Media ->
Configuration -> Action


#自定义配置监控
Include=/etc/zabbix_agentd.conf.d/
UnsafeUserParameters=1

#                key                     执行的命令
UserParameter=nginx.alive.curl, curl --head -s http://127.0.0.1:8888  | grep '200 OK' | wc -l
#key名称为 nginx.alive.curl 此key的结果就是 执行命令 返回的结果


自定义item
Key: UserParameter key 填写在此
Unis: 默认情况值超过1000 变为k 然后为M
Use custom multiple: 用户自定义倍数 (收到的数值乘以多少) 方便观看和可读性增强
Update interval(in sec): 数值更新时间 60 300
Custom intervals: 自定义更新间隔
History storage period (in days): 历史数据保留天数
Trend storage period (in days)

Store value: 存储的数据 要做的处理
    AS is    默认不做处理
Show value: 展示的时候 要做的处理
    As is:   默认不做处理

New application: 新的应用集 把自定义item 放到某一个自定义应用集中
Applications: 从已经存在应用集中选择

Populates host inventory field: 资产自动填充

Administration -> Queue: 所有item更新的时间 如果zabbix server有问题的话
#Server太繁忙 agent item更新延迟多长时间


zabbix监控 主动 被动模式

被动模式
  zabbix_agent 配置zabbix_server IP 地址 Server定期来获取agent数据
  Server定期 轮询询问 每个agent 的所有item 的值
  10050端口是在被动模式下 需要server连接此端口

主动模式
  agent定期向Server发送 agent数据
  agent 第一次启动的时候就 会 主动连接server Server会把需要检测item的列表给agent
  相当于agent清单 每隔多少时间把检测的item值 发送给Server
  agent 定期把agent清单item值发送给Server 减轻Server压力

  默认模板的item监控type 为Zabbix agent 可以full clone 一个新模板 取名为Active
  选中所有item项目 Mass Update 全部更新type 为 Zabbix agent(active) 则此时新模板
  的大部分item的监控type 都是Active 主动监控类型了



zabbix_proxy 也会做item收集 主动发送给server机器

ProxyMode=0
  #0 默认0主动模式
  #1 被动模式
  #proxy主动连接server将数据发送到Server

ProxyLocalBuffer
  #proxy缓存数据时间 0不缓存
  #proxy收集到数据后先把数据缓存到本地 然后在一定时间在传给server

ProxyOfflineBuffer
  #连接不到server时 数据在本地缓存的时间


percona mysql template


