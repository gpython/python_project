MariaDB - Mariabackup热备份工具

自MariaDB10.2.7（含）以上版本，不再支持使用Percona XtraBackup工具在线物理热备份。

MariaDB 10.1引入了MariaDB独有的功能，例如InnoDB页面压缩和静态数据加密。这些独家功能在MariaDB用户中非常受欢迎。但是，来自MySQL生态系统的现有备份解决方案（如Percona XtraBackup）不支持这些功能的完全备份功能。

为了满足用户的需求，MariaDB官方决定开发一个完全支持MariaDB独有功能的备份解决方案。它基于Percona XtraBackup 2.3.8版本改写扩展。

mariabackup工具使用（包含在二进制tar包bin目录下）

############
#备份 
#手动指定需要到的目录位置
mariabackup  --defaults-file=/etc/my.cnf -S /data/mysql/mysql.sock --backup --target-dir=/data/backup/`date +"%F_%H-%M-%S"` --user=root --password=tom.123
