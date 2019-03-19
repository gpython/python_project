
#####Git Gitlab Jenkins安装 使用
#时间同步

yum update
yum remove git
yum install curl-devel expat-devel gettext-devel openssl-devel zlib-devel gcc perl-ExtUtils-MakeMaker

#使用最新版本git
wget https://github.com/git/git/archive/v2.21.0.zip

unzip v2.21.0.zip
cd git-2.21.0

make prefix=/usr/local/git all
make prefix=/usr/local/git install
rm -rf /usr/bin/git
ln -s /usr/local/git/bin/git /usr/bin/git
git --version


#####git 设置与配置
mkdir /data/git_data
cd /data/git_data/
mkdir g1

git config

#初始化
cd g1
#初始化此目录g1 g1目录被git版本工具所控制
git init
#记录用户信息
git config --global user.name 'root'
git config --global user.email 'root@g.com'

git config --list


#获取


#git四个区域
file_create    add         commit
工作目录  <-->  暂存区  <-->  本地仓库  <-|->  远程仓库


Untracked    unmodified     Modified    Staged


#分支管理
#开发新功能 在分支上开发

#查看分支状态
git status
#创建分支
git branch 分支名称

git branch branch_about

#切换到 指定分支
git checkout branch_about

#列出分支 及 工作所在分支
git branch
git branch -v

#查看哪些分支已经被merged
git branch --merged

#那些分支已经开发 还没有被merge
git branch --no-merged

#删除
git branch -d testing

#切换分支
git checkout

###########
#分支代码合并到主干
git merge

#在master分支上执行
#切换到master分支
git checkout master
git branch -v

#查看其他分支 还没有merged到master的 分支
git branch --no-merged

#查看已经merged到 master的 分支
git branch --merged

#开发分支合并到master主分支
git merge branch_index
git merge branch_about

#查看 merged 和没有merged到master的分支情况
git branch --no-merged
git branch --merged

git log
git stash
git tag


###
# 切换分支
git checkout branch_name
#撤销对文件的修改
#当前分支下 对某个文件修改后 未作add commit操作 想要 回撤到先前的内容状态
#从暂存区拉出来 覆盖 工作目录
git checkout -- file_name
git checkout -- index.html

####慎用
#回滚 慎用
git reset --hard

#分析所有分支的头指针日志 来查找在重写历史上可能丢失的提交
git reflog
#分析某一分支头指针日志
git reflog branch_name


################
git reset --hard fbab0a26f5
git reflog
git reflog branch_about
git checkout eb0ec8e

git status
git branch -v

git branch reset
git checkout reset
git status

git checkout master
git branch --merged
git branch --no-merged

git merge reset

    |<-----------------pull<---------------|

    |                   |<--fetch/clone<---|

workerspace  Index   Repository       Remote

  \--------->add||-->commit||-->push----->|

  \<--------checkout<------|



#######GitLab#####
yum install curl policycoreutils openssh-server openssh-clients
systemctl enable sshd
systemctl start sshd

yum install postfix
systemctl enable postfix
systemctl start postfix

wget https://mirrors.tuna.tsinghua.edu.cn/gitlab-ce/yum/el7/gitlab-ce-8.9.9-ce.0.el7.x86_64.rpm

yum localinstall gitlab-ce-8.9.9-ce.0.el7.x86_64.rpm


#修改配置文件

vim /etc/gitlab/gitlab.rb
external_url 'http://192.168.1.50'

#配置
gitlab-ctl reconfigure

#访问
http://192.168.1.50

#权限
#修改密码 登录 root

gitlab-ctl status
gitlab-ctl start
gitlab-ctl stop
gitlab-ctl restart
#查看组件 日志
gitlab-ctl tail nginx

#目录
/var/opt/gitlab/git-data/repositories/root/ #库默认存储目录
/opt/gitlab/        #应用代码和相应依赖程序
/var/opt/gitlab/    #gitlab-ctl reconfigure 命令编译后应用数据和配置文件 不需要人为修改配置
/etc/gitlab/        #配置文件目录
/var/log/gitlab     #日志目录
/var/opt/gitlab/backups     #备份文件生成的目录

#变更配置文件后要执行操作
gitlab-ctl reconfigure

#验证配置文件
gitlab-ctl show-config

#重启gitlab服务
gitlab-ctl restart


gitlab Deploy key 只能下载代码 不能上传代码 给jenkins使用

################创建里程碑 issues 开发任务流程
#创建里程碑 发布issues 向指定用户分派任务

#用户开始任务 先创建分支 按照里程碑里 issue名称创建分支 开发
#创建分支 并直接切换到相应分支
git checkout -b b_index

#创建文件
vim index.html

git add .
git commit -m "b_index index.html"

#也可以 在commit时候 指定要关闭指定的issues
git commit -m "b_index commit close #1"

#上传到指定分支下
git push origin b_index

#发送merge请求到 指定的管理员 处理
#关闭 issues


#最后 开发者的 master 上需要pull 合并到线上的 项目到本地
git checkout master
git pull

#项目完成 打tag  v1.0 v2.0

#删除没必要的 分支


########备份代码库 及 恢复操作
mkdir /data/backups/gitlab -p
chown -R git.git /data/backups/gitlab

vim /etc/gitlab/gitlab.rb
#备份目录
gitlab_rails['backup_path'] = "/data/backups/gitlab"
#备份保留天数 默认7天
gitlab_rails['backup_keep_time'] = 604800

#
gitlab-ctl reconfigure

gitlab-ctl restart

#手动执行一次备份
/usr/bin/gitlab-rake gitlab:backup:create

#加入定时任务
0 2 * * * /usr/bin/gitlab-rake gitlab:backup:create

#本地保留7天 异地备份永久保存

##恢复
#停止数据写入服务
gitlab-ctl stop unicorn
gitlab-ctl stop sidekiq

cd /data/backups/gitlab/
#BACKUP后边跟备份时间戳
/usr/bin/gitlab-rake gitlab:backup:restore BACKUP=1552918061

#恢复完成 重启所有服务
gitlab-ctl restart


####邮件配置
# gitlab_rails['time_zone'] = 'Asia/Shanghai'
# gitlab_rails['gitlab_email_enabled'] = true
# gitlab_rails['gitlab_email_from'] = 'example@example.com'
# gitlab_rails['gitlab_email_display_name'] = 'Gitlab'
# gitlab_rails['smtp_enable'] = true
# gitlab_rails['smtp_address'] = "smtp.qq.com"
# gitlab_rails['smtp_port'] = 25
# gitlab_rails['smtp_user_name'] = "username"
# gitlab_rails['smtp_password'] = "password"
# gitlab_rails['smtp_domain'] = "163.com"
# gitlab_rails['smtp_authentication'] = "login"


##gitlab性能 监控 查看 (队列 连接数)
Admin Area -> Monitoring

###### 持续集成 #############################
###Jenkins
#维护一个单一的代码库
#构建自动化
#执行测试是构建的一部分
#集成日志及历史记录
#使用统一的依赖包管理库
#每天至少集成一次
#工程师 将代码 push 到代码库中 jenkins 拉取代码 build -> test -> result

yum install java-1.8.0-openjdk java-1.8.0-openjdk-devel

wget https://pkg.jenkins.io/redhat-stable/jenkins-2.32.3-1.1.noarch.rpm

yum localinstall
service jenkins start

#解锁jenkins 默认密码路径
/var/lib/jenkins/secrets/initialAdminPassword

#联网问题 关闭网络 在打开

#插件
#Pipeline  工作流

#常用插件
SSH plugin
Gitlab plugin
Pipeline
Git plugin
Git Parameter Plug-In
Deploy Plugin
Maven integration plugin
Role-based Authorization Strategy
Html reports
performance plugin
jmeter-marven
cobertura
sonarQube
Blue Ocean

#jenkins plugin 目录 可将已有插件 直接解压于此
/var/lib/jenkins/plugins

#jenkins 备份 可以rsync 增量备份
tar zcvf jenkins_`date +"%F"`.tar.gz /var/lib/jenkins

#jenkins 系统管理 -> 系统设置
  执行者数量       5
  用法            尽可能的使用这个节点 (主server选择此项目)
                 只允许运行绑定到这台机器的Job (假若为slave机 选择此项)
  生成前等待时间    10
  SCM签出重试次数   代码迁出重试次数

#jenkins升级
service jenkins stop

#将旧版本jenkins 备份
#将新版本的jenkins war包放在/usr/lib/jenkins/

#启动jenkins
service jenkins start

####PHP
#Jenkins -> 新建任务 -> 输入任务名称 -> 构建自由风格软件
#输入git respositories 可配置jenkins用户为root 方便已经在gitlab中配置的ssh密钥对
#构建 执行shell 在框中命令 执行的目录为 /var/lib/jenkins/workspace/xxxx 目录
#如下 将构建的代码 传输到 另一台机器的 web项目目录下
/usr/bin/rsync -avz --delete --progress * root@10.10.10.51:/data/wwwroot/proj_app1/

#进入工程 点击 立即构建 查看修改记录

###Java Marven 插件 Git Parameter Plug-in

#按版本发布
#安装git parameter plugin 插件
#任务配置中勾选 参数化构建过程
#选择 git parameter
#创建变量名 release
#选择发布类型
  tag 按标签发布
  branch 按分支发布
  Revision 按修订发布


#参数化构建过程 $release 指代tag标签
Name: $release
Parameter Type: Tag
Default Value: origin/master

Repository URL: git地址
Branch Specifier (blank for 'any'): $release

#执行shell
scp target/javaweb-$release.jar 10.10.10.51:/data/wwwroot/
ssh root@10.10.10.51 "java -jar /data/wwwroot/javaweb-$release.jar"

#或者 脚本形式 脚本在环境变量位置 链接到/usr/bin/目录 传不同参数执行
deploy.sh 10.10.10.51 project_name

#deploy.sh 脚本内容如下
host=$1
project_name=$2
scp target/${project_name}-$release.jar ${host}:/data/wwwroot/
ssh root@${host} "java -jar /data/wwwroot/${project_name}-$release.jar"

##################

wget http://mirrors.tuna.tsinghua.edu.cn/apache/maven/maven-3/3.3.9/binaries/apache-maven-3.3.9-bin.tar.gz
tar zxvf apache-maven-3.3.9-bin.tar.gz -C /usr/local/
vim /etc/profile
# maven所在的目录
export M2_HOME=/usr/local/apache-maven-3.3.9
# maven bin所在的目录
export M2=$M2_HOME/bin
# 将maven bin加到PATH变量中
export PATH=$M2:$PATH
# 配置JAVA_HOME所在的目录，注意这个目录下应该有bin文件夹，bin下应该有java等命令
export JAVA_HOME=/usr/lib/jvm/jre-1.7.0