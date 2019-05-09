
配置文件 /etc/ansible/ansible.cfg
主机池  /etc/ansible/hosts

ssh-keygen -t rsa
ssh-copy-id -i ~/.ssh/id_rsa.pub root@192.168.1.81

ansible-doc -l
ansible-doc -s yum

########Ansible执行过程#######
#加载自己的配置文件 默认 /etc/ansible/ansible.cfg
#加载自己对应的模块文件 如command
#通过ansible 将模块命令生成对应的临时py文件 并将文件传输至远程服务器 对应执行用户$HOME/.ansible/tmp/ansible-tmp-数字/xxx.py文件
#给文件+x执行
#执行并返回结果
#删除临时py文件 sleep 0退出

###执行状态
绿色 执行成功并不需要做改变的操作
黄色 执行成功并对目标主机做变更
红色 执行失败

#主机清单 主机列表文件 需要先把主机IP列表放在此文件
/etc/ansible/hosts





ansible <host-pattern> [-f fork] [-m module_name] [-a args]
-f forks 启动的并发线程数
-m module_name 使用的模板
-a args 模块特有参数

cron:
  state:
    state=present #安装
    state=absent  #移除
    disbaled=true/yes #禁用
    disabled=false/no #启用

cron
  #name 名称注释
  #job 执行任务
  ansible all -m cron -a 'minute="*/10" job="/bin/echo hell" name="test_cron_job"'
  ansible all -a 'crontab -l'
  ansible all -m cron -a 'minute="*/10" job="/bin/echo hell" name="test_cron_job" state=absent'

user
  ansible all -m user -a  'user=user1 uid=306 system=yes group=user1'
  ansible all -m user -a  'user="user1" state=absent'
  ansible all -a "tail -n 1 /etc/passwd"

group
  ansible all -m group -a 'name=mysql gid=306 system=yes'

copy
  src = 定义本地源文件路径 相对或绝对
  dest = 定义远程目标文件路径 绝对
  content = 取代src 表示直接用此处指定的信息生成目标文件内容
  ansible all -m copy -a 'src=/etc/passwd dest=/tmp/passwd-ansible backup=yes owner=root mode=644'

file
 = path
   Path to the file being managed.
   (Aliases: dest, name)
  ansible all -m file -a "owner=nobody group=nobody mode=600 path=/tmp/passwd-ansible"
  file 链接文件 pwd-link -> /tmp/passwd-ansible
  ansible all -m file -a "path=/tmp/pwd-link src=/tmp/passwd-ansible state=link"
  ansible all -m file -a "src="/tmp/passwd-ansible dest='/tmp/pwd-link state=link"

service
  enable 开机启动
  name 服务名
  state=started/stopped/reloaded/restarted
  ansible all -m service -a "enabled=true name=httpd state=started"

用户创建 并创建密码
ansible all -m group -a "name=john gid=1000"
ansible all -m user -a "name=john group=john"
ansible all -m shell -a "echo passwd | passwd --stdin john"


command
  在远程主机执行命令 默认模块 可以忽略-m选项
  此命令不支持$varname < > | ; &等命令 shell模块支持

shell
  在远程主机上运行命令 尤其是用到管道等复杂命令
  ansible all -m shell -a "awk -F':' '{print $2}' /etc/passwd"

script
  将本地脚本复制到远程主机并运行 本地脚本相对路径
  ansible all -m script -a "/root/ansible/sc.sh"

yum
  name 软件程序包 可以带版本号
  absent 卸载
  ansible all -m yum -a "name=zsh,tree,unzip"
  ansible all -m yum -a "name=zsh state=absent"

hostname
  ansible 10.10.10.50 -m hostname -a "name=10-10-10-50"




setup
 收集远程主机的facts
 setup变量可以直接 调用 解析 无需声明

          Play1    Task1    Modules                                     Hosts
Ansible-> Play2 -> Task2 -> Custome Modules -> host Inventory -> ssh ->
          Play2    Task3    core Modules                                Networking
                            plugins

######ansible-playbook

Hosts 执行的远程主机列表
Tasks 任务集
Varniables 内置变量或自定义变量在playbook中调用
Templates 模板 可替换模板文件中的变量 并实现一些简单逻辑的文件
Handlers和notify结合使用 由特定条件出发的操作 满足条件方才执行 否则不执行

Tags 标签 执行某条任务执行 tasks 任务里添加tag 将来可以 单独只执行 标签 来执行对应task
  #通过 指定 标签来执行 特定的某一个动作
  #-t 标签,标签

handlers 和 notify结合使用触发条件

handlers 触发器
  是task列表 用于当关注的资源发生变化时 才会采取一定的操作

Notify
  此action可用于在每个play的最后被触发 这样可避免多次有改变发生
  每次都执行指定的操作 仅在所有变化发生完成后一次性的执行指定操作


#--check 只检测可能会发生的改变 但不真正执行操作
  ansible-playbook --check/-C file.yml

#--list-hosts  列出运行任务的主机
  ansible web --list-hosts
  ansible-playbook file.yml --list-hosts

#--limit 主机列表 只针对主机列表中的主机执行
  ansible web -m shell -a 'pwd' --limit 10.10.10.54
  ansible-playbook -C file.yml --limit 10.10.10.55

#--list-tasks 列出任务
  ansible-playbook file.yml --list-tasks

#--list-tags 列出tag
  ansible-playbook file.yml --list-tags

-v -vv -vvv 显示详细过程

##变量 setup模块
 ansible web -m setup
 ansible web -m setup -a "filter=ansible_fqdn"
 ansible web -m setup -a "filter=ansible_fqdn"
 ansible web -m setup -a "filter=*address*"

在/etc/ansible/hosts中定义变量
 针对 主机组中 单个主机 设置单一变量
 针对 整个主机组web 设置公共变量
 [web]
 10.10.10.53 http_port=8080  #<-单个主机单一变量设置 变量对 当前指定主机有效
 10.10.10.53 http_port=8081  #优先级 高于 通用变量
 10.10.10.53 http_port=8082

 [web:vars]                  #<-整个web主机组设置 所有组内主机有效 通用变量
 nodename=www
 domainname=g.com

通过命令行指定变量 临时执行时 指定变量 *优先级最高
 ansible-playbook -e "varname1=value1 varname2=value2"

 在playbook中的定义变量
 vars:
   - var1: value1
   - var2: value2

vars 变量 优先级
  命令行 -e变量 > playbook文件中定义变量 < 主机清单中定义的变量

vars_files: #变量文件
  - vars.yml

template 模板 j2


when 条件测试
  根据变量 facts 或此前任务的执行结果来做为某task执行与否的前提时要用到的条件测试
  通过when语句实现
  在task后添加when子句 即可用于条件测试 when语句支持jinja2表达式语法


with_items 列表循环
for item in with_items:
  item

roles
  层次化 结构化组织playbook roles根据层次机构自动装载 变量文件， tasks， handlers
  要使用roles只需要在playbook中使用include指令即可
  roles就是通过分别将变量 文件 任务 模板 及处理器 放置于单独的目录中
  并可以便捷的include它们的一种机制

  roles/
    nginx/
    mysql/



###########################################
- hosts: web
  remote_user: root
  tasks:
    - name: copy file
      copy: content="{{ ansible_all_ipv4_address }}" dest=/tmp/var.ans
      when: ansible_os_family == "RedHat"
      notify: some_handlers

    - name: dep_soft_install
      yum: name={{ item }}
      with_items:
        - gcc
        - make
        - htop
        - hping3

    - name: add_group
      group: name={{ item }} state=present
      with_items:
        - gp1
        - gp2
        - gp3
    - name: add_user
      user: name={{ item.name }} group={{ item.group }} state=present
      with_items:
        - { name: "user1", group: "gp1" }
        - { name: "user2", group: "gp2" }
        - { name: "user3", group: "gp3"}

  handlers:
    - name: some_handlers
      service: name=nginx state=restarted



yaml
 序列里的项 用 "-" 来表示
 Map 里的键值用 ":" 来表示

- hosts: webnodes
  vars:
    http_port: 80
    max_client: 256
  remote_user: root
  task:
    - name: ensure apache is at latest version
      yum: name=httpd state=latest

    - name:
      copy: src=files/httpd.conf dest=/etc/httpd/conf backup=yes

      #每次有配置文件发生更改 触发 对应名字 的触发器 执行动作
      #触发handlers 对应名字task 的执行
      notify: restart_apache

    - name: ensure apache
      service: name=httpd state=started enabled=yes

  #触发器
  handlers:
    - name: restart_apache
      service: name=httpd state=restarted


       模块名    key value

host 指定要执行指定任务的主机 可以是一个或多个由冒号分割的主机组
remote_user 用于指定远程主机上执行任务的用户
task 任务执行 以此在所有主机上执行完第一个任务再执行第二个任务
service: name=httpd state=restart
模块名    名称 执行状态

只有shell 和command 模块仅需要给定一个列表 无需使用key=value格式

- host: webserver
  remote_user: root
  tasks:
    - name: create nginx group
      group: name=nginx system=yes gid=1001
    - name: create nginx user
      group: name=nginx uid=1001 group=nginx system=yes

- host: dbserver
  remore_user: root
  tasks:
    - name: copy file to dbserver
      copy: src=/etc/passwd dest=/tmp/passwd-an

handlers
 用于当关注的资源发生变化时 采取一定的操作

notify
 这个action 可用于在每个play的最后被触发 这样可以避免多次有改发生时都执行指定的操作
 取而代之 仅在所有的变化都完成后一次性的执行指定操作
 在notify中列出的操作称为handler 也即notify中调用handler中定义的操作

- name: template configuration file
  template: src=template.j2 dest=/etc/foo.cnf
  notify:
    - restart memcached
    - restart apache

所有变化都完成后一次性执行指定操作
notify触发以下handlers中的task
handler是task列表 这些task与前述的task并没有本质上不同

handlers:
  - name: restart memcached
    service: name=memcached state=restarted
  - name: restart apache
    service: name=apache state=restarted


#配置文件发生改变 触发 restart handlers
#变量 vars 下声明 setup中变量可以直接使用 "{{ setup vars }}"
#host中定义的主机变量也可以直接使用

- host: web
  remote_user: root
  vars:
    - package: httpd
    - service: httpd
  tasks:
    - name: install httpd apache
      yum: name={{ package } state=latest

    - name: install config file for httpd
      copy: src=/root/conf/httpd.conf dest=/etc/httpd/conf/httpd.conf
      notify:
        - restart httpd

    - name: start httpd service
      service: enabled=true name={{ service }} state=started

  handlers:
    - name: restart httpd
      service: name={{ service }} state=restarted

条件变量 when
 tasks后添加when条件变量
 when 变量可以是setup中key 无需{{}}包裹

ansible-playbook con.yaml


with_items
 当需要有重复的执行任务时 可以使用迭代机制 格式为将需要迭代的内容定义为item变量引用
 并通过with_items语句来指明迭代元素列表即可

- name: create several users
  user: name={{ item }} starte=present groups=wheel
  with_items:
    - create_user1
    - create_user2

上边语句等同于
- name: create user1
  user: name=create_user1 state=present groups=wheel
- name: create user2
  user: name=create_user2 state=present groups=wheel

with_items 可以使用元素为字典类型
- name: create several users
  user: name={{ item.name }} state=present groups={{ item.groups }}
  with_items:
    - { name: 'create_user1' groups: 'wheel'}
    - { name: 'create_user2' groups: 'wheel'}

tags
 在playbook中可以为某个或某些任务定义一个标签 在执行此playbook时
 通过ansible-playbook命令使用 --tag选项能实现仅运行指定的tasks 而非所有

- name: install config file for httpd
  template: src=/root/httpd/httpd.conf.j2 dest=/etc/httpd/conf/httpd.conf
  tags:
    - conf
特殊tags always  无论任何时候都运行


role
 创建以roles命名的目录
 在roles目录中分别创建以各角色名称的目录 如nginx mysql webserver
 在每个角色命名的目录中分别创建 files handlers meta tasks templates 和vars目录 用不到的可以不创建或为空
 在playbook文件中调用各角色

role中各目录可用文件
 tasks目录 至少包含一个名为main.yml的文件 定义角色任务列表 可以使用include包含其他的位于此目录中的task文件
 files目录 存放有copy或script等模块调用的文件
 templates目录 template模块会自动在此目录中寻找jinja2模板文件
 handlers 此目录中应当包含一个main
 yml文件 用于定义此角色用到的各handler 在handler中使用 include包含的其他的handler文件也应位于此目录
 vars目录 包含一个main.yml文件 用于定义此角色用到的变量
 meta目录 包含一个main.yml文件 用于定义此角色的特殊设定及其他依赖关系
 default目录 为当前角色设定默认变量时使用此目录 应当包含一个mian.yml文件

mkdir -pv ansible_playbooks/rols/{nginx,mysql}/{tasks,files,templates,meta,handlers,vars}

playbook调用角色

###1
- hosts: websrvs
  remote_user: root
  roles:
    - mysql
    - nginx
    - memcached

###2
#传递变量给角色
#键 role用于指定角色名称
#后续 k/v 用于传递变量给角色
#基于条件测试实现角色调用
- hosts:
  remote_user: root
  roles:
    - mysql
    - { role: nginx, user_var1: value1, user_var2: value2 }
    - { role: mysql, username:mysql, when: ansible_distribution_major_version == "7" }

#role playbook tags 使用
ansible-playbook --tags="nginx,mysql,php" common_role.yml

- hosts: web
  remote_user: root
  roles:
    - { role: nginx, tags: ["nginx", "web"], when: ansible_distribution_major_version == "7" }
    - { role: php, tags: ["php", "web"] }
    - { role: mysql, tags: ["mysql", "db"] }
    - { role: redis, tags: ["redis", "db"] }










