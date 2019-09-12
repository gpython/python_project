#errno -1
cd /data/htdocs/wwwroot && rsync -artuz -R --delete ./   --include="alternatives.log" --exclude=*  192.168.40.130::wwwroot >/dev/null 2>&1 

#errno -1
cd /data/htdocs/wwwroot && rsync -artuz -R --delete ./   --include="apt/" --include="apt/term.log" --exclude=*  192.168.40.130::wwwroot >/dev/null 2>&1 

#errno -1
cd /data/htdocs/wwwroot && rsync -artuz -R --delete ./   --include="btmp" --exclude=*  192.168.40.130::wwwroot >/dev/null 2>&1 

#errno -1
cd /data/htdocs/wwwroot && rsync -artuz -R --delete ./   --include="faillog" --exclude=*  192.168.40.130::wwwroot >/dev/null 2>&1 

#errno -1
cd /data/htdocs/wwwroot && rsync -artuz -R --delete ./   --include="daemon.log" --exclude=*  192.168.40.130::wwwroot >/dev/null 2>&1 

#errno -1
cd /data/htdocs/wwwroot && rsync -artuz -R --delete ./   --include="apt/" --include="apt/eipp.log.xz" --exclude=*  192.168.40.130::wwwroot >/dev/null 2>&1 

#errno -1
cd /data/htdocs/wwwroot && rsync -artuz -R --delete ./   --include="apt"  --include="apt/***" --exclude=*  192.168.40.130::wwwroot >/dev/null 2>&1 

#errno -1
cd /data/htdocs/wwwroot && rsync -artuz -R --delete ./   --include="debug" --exclude=*  192.168.40.130::wwwroot >/dev/null 2>&1 

#errno -1
cd /data/htdocs/wwwroot && rsync -artuz -R --delete ./   --include="auth.log" --exclude=*  192.168.40.130::wwwroot >/dev/null 2>&1 

#errno -1
cd /data/htdocs/wwwroot && rsync -artuz -R --delete ./   --include="dpkg.log" --exclude=*  192.168.40.130::wwwroot >/dev/null 2>&1 

#errno -1
cd /data/htdocs/wwwroot && rsync -artuz -R --delete ./   --include="installer/" --include="installer/syslog" --exclude=*  192.168.40.130::wwwroot >/dev/null 2>&1 

#errno -1
cd /data/htdocs/wwwroot && rsync -artuz -R --delete ./   --include="installer/" --include="installer/hardware-summary" --exclude=*  192.168.40.130::wwwroot >/dev/null 2>&1 

#errno -1
cd /data/htdocs/wwwroot && rsync -artuz -R --delete ./   --include="installer/" --include="installer/partman" --exclude=*  192.168.40.130::wwwroot >/dev/null 2>&1 

#errno -1
cd /data/htdocs/wwwroot && rsync -artuz -R --delete ./   --include="kern.log" --exclude=*  192.168.40.130::wwwroot >/dev/null 2>&1 

#errno -1
cd /data/htdocs/wwwroot && rsync -artuz -R --delete ./   --include="installer"  --include="installer/***" --exclude=*  192.168.40.130::wwwroot >/dev/null 2>&1 

#errno -1
cd /data/htdocs/wwwroot && rsync -artuz -R --delete ./   --include="lastlog" --exclude=*  192.168.40.130::wwwroot >/dev/null 2>&1 

#errno -1
cd /data/htdocs/wwwroot && rsync -artuz -R --delete ./   --include="popularity-contest" --exclude=*  192.168.40.130::wwwroot >/dev/null 2>&1 

#errno -1
cd /data/htdocs/wwwroot && rsync -artuz -R --delete ./   --include="messages" --exclude=*  192.168.40.130::wwwroot >/dev/null 2>&1 

#errno -1
cd /data/htdocs/wwwroot && rsync -artuz -R --delete ./   --include="popularity-contest.new" --exclude=*  192.168.40.130::wwwroot >/dev/null 2>&1 

#errno -1
cd /data/htdocs/wwwroot && rsync -artuz -R --delete ./   --include="popularity-contest.0" --exclude=*  192.168.40.130::wwwroot >/dev/null 2>&1 

#errno -1
cd /data/htdocs/wwwroot && rsync -artuz -R --delete ./   --include="rsyncd.log" --exclude=*  192.168.40.130::wwwroot >/dev/null 2>&1 

#errno -1
cd /data/htdocs/wwwroot && rsync -artuz -R --delete ./   --include="syslog" --exclude=*  192.168.40.130::wwwroot >/dev/null 2>&1 

#errno -1
cd /data/htdocs/wwwroot && rsync -artuz -R --delete ./   --include="sysstat"  --include="sysstat/***" --exclude=*  192.168.40.130::wwwroot >/dev/null 2>&1 

#errno -1
cd /data/htdocs/wwwroot && rsync -artuz -R --delete ./   --include="user.log" --exclude=*  192.168.40.130::wwwroot >/dev/null 2>&1 

#errno -1
cd /data/htdocs/wwwroot && rsync -artuz -R --delete ./   --include="wtmp" --exclude=*  192.168.40.130::wwwroot >/dev/null 2>&1 

#errno -1
cd /data/htdocs/wwwroot && rsync -artuz -R "./auth.log" tom@192.168.40.130::wwwroot --password-file=/etc/rsync.password >/dev/null 2>&1 

#errno -1
cd /data/htdocs/wwwroot && rsync -artuz -R "./apt/history.log" tom@192.168.40.130::wwwroot --password-file=/etc/rsync.password >/dev/null 2>&1 

#errno -1
cd /data/htdocs/wwwroot && rsync -artuz -R "./debug" tom@192.168.40.130::wwwroot --password-file=/etc/rsync.password >/dev/null 2>&1 

#errno -1
cd /data/htdocs/wwwroot && rsync -artuz -R "./dpkg.log" tom@192.168.40.130::wwwroot --password-file=/etc/rsync.password >/dev/null 2>&1 

#errno -1
cd /data/htdocs/wwwroot && rsync -artuz -R "./apt" tom@192.168.40.130::wwwroot --password-file=/etc/rsync.password >/dev/null 2>&1 

#errno -1
cd /data/htdocs/wwwroot && rsync -artuz -R "./btmp" tom@192.168.40.130::wwwroot --password-file=/etc/rsync.password >/dev/null 2>&1 

#errno -1
cd /data/htdocs/wwwroot && rsync -artuz -R "./installer/partman" tom@192.168.40.130::wwwroot --password-file=/etc/rsync.password >/dev/null 2>&1 

#errno -1
cd /data/htdocs/wwwroot && rsync -artuz -R "./faillog" tom@192.168.40.130::wwwroot --password-file=/etc/rsync.password >/dev/null 2>&1 

#errno -1
cd /data/htdocs/wwwroot && rsync -artuz -R "./installer/hardware-summary" tom@192.168.40.130::wwwroot --password-file=/etc/rsync.password >/dev/null 2>&1 

#errno -1
cd /data/htdocs/wwwroot && rsync -artuz -R "./installer/lsb-release" tom@192.168.40.130::wwwroot --password-file=/etc/rsync.password >/dev/null 2>&1 

#errno -1
cd /data/htdocs/wwwroot && rsync -artuz -R "./lastlog" tom@192.168.40.130::wwwroot --password-file=/etc/rsync.password >/dev/null 2>&1 

#errno -1
cd /data/htdocs/wwwroot && rsync -artuz -R "./installer/syslog" tom@192.168.40.130::wwwroot --password-file=/etc/rsync.password >/dev/null 2>&1 

#errno -1
cd /data/htdocs/wwwroot && rsync -artuz -R "./kern.log" tom@192.168.40.130::wwwroot --password-file=/etc/rsync.password >/dev/null 2>&1 

#errno -1
cd /data/htdocs/wwwroot && rsync -artuz -R "./popularity-contest" tom@192.168.40.130::wwwroot --password-file=/etc/rsync.password >/dev/null 2>&1 

#errno -1
cd /data/htdocs/wwwroot && rsync -artuz -R "./messages" tom@192.168.40.130::wwwroot --password-file=/etc/rsync.password >/dev/null 2>&1 

#errno -1
cd /data/htdocs/wwwroot && rsync -artuz -R "./popularity-contest.new" tom@192.168.40.130::wwwroot --password-file=/etc/rsync.password >/dev/null 2>&1 

#errno -1
cd /data/htdocs/wwwroot && rsync -artuz -R "./rsyncd.log" tom@192.168.40.130::wwwroot --password-file=/etc/rsync.password >/dev/null 2>&1 

#errno -1
cd /data/htdocs/wwwroot && rsync -artuz -R "./popularity-contest.0" tom@192.168.40.130::wwwroot --password-file=/etc/rsync.password >/dev/null 2>&1 

#errno -1
cd /data/htdocs/wwwroot && rsync -artuz -R "./sysstat" tom@192.168.40.130::wwwroot --password-file=/etc/rsync.password >/dev/null 2>&1 

#errno -1
cd /data/htdocs/wwwroot && rsync -artuz -R "./syslog" tom@192.168.40.130::wwwroot --password-file=/etc/rsync.password >/dev/null 2>&1 

#errno -1
cd /data/htdocs/wwwroot && rsync -artuz -R "./user.log" tom@192.168.40.130::wwwroot --password-file=/etc/rsync.password >/dev/null 2>&1 

#errno -1
cd /data/htdocs/wwwroot && rsync -artuz -R "./wtmp" tom@192.168.40.130::wwwroot --password-file=/etc/rsync.password >/dev/null 2>&1 

#errno -1
cd /data/htdocs/wwwroot && rsync -artuz -R "./installer" tom@192.168.40.130::wwwroot --password-file=/etc/rsync.password >/dev/null 2>&1 

#errno -1
cd /data/htdocs/wwwroot && rsync -artuz -R "./installer/cdebconf" tom@192.168.40.130::wwwroot --password-file=/etc/rsync.password >/dev/null 2>&1 

#errno -1
cd /data/htdocs/wwwroot && rsync -artuz -R "./alternatives" tom@192.168.40.130::wwwroot --password-file=/etc/rsync.password >/dev/null 2>&1 

#errno -1
cd /data/htdocs/wwwroot && rsync -artuz -R "./adjtime" tom@192.168.40.130::wwwroot --password-file=/etc/rsync.password >/dev/null 2>&1 

#errno -1
cd /data/htdocs/wwwroot && rsync -artuz -R "./adduser.conf" tom@192.168.40.130::wwwroot --password-file=/etc/rsync.password >/dev/null 2>&1 

#errno -1
cd /data/htdocs/wwwroot && rsync -artuz -R "./alternatives/README" tom@192.168.40.130::wwwroot --password-file=/etc/rsync.password >/dev/null 2>&1 

#errno -1
cd /data/htdocs/wwwroot && rsync -artuz -R "./apt/trusted.gpg.d" tom@192.168.40.130::wwwroot --password-file=/etc/rsync.password >/dev/null 2>&1 

#errno -1
cd /data/htdocs/wwwroot && rsync -artuz -R "./apm/event.d" tom@192.168.40.130::wwwroot --password-file=/etc/rsync.password >/dev/null 2>&1 

#errno -1
cd /data/htdocs/wwwroot && rsync -artuz -R "./apm/event.d/20hdparm" tom@192.168.40.130::wwwroot --password-file=/etc/rsync.password >/dev/null 2>&1 

#errno -1
cd /data/htdocs/wwwroot && rsync -artuz -R "./apt/trusted.gpg.d/debian-archive-jessie-security-automatic.gpg" tom@192.168.40.130::wwwroot --password-file=/etc/rsync.password >/dev/null 2>&1 

#errno -1
cd /data/htdocs/wwwroot && rsync -artuz -R "./apt/trusted.gpg.d/debian-archive-jessie-automatic.gpg" tom@192.168.40.130::wwwroot --password-file=/etc/rsync.password >/dev/null 2>&1 

#errno -1
cd /data/htdocs/wwwroot && rsync -artuz -R "./apm" tom@192.168.40.130::wwwroot --password-file=/etc/rsync.password >/dev/null 2>&1 

#errno -1
cd /data/htdocs/wwwroot && rsync -artuz -R "./apt/trusted.gpg.d/debian-archive-jessie-stable.gpg" tom@192.168.40.130::wwwroot --password-file=/etc/rsync.password >/dev/null 2>&1 

#errno -1
cd /data/htdocs/wwwroot && rsync -artuz -R "./apt/trusted.gpg.d/debian-archive-stretch-security-automatic.gpg" tom@192.168.40.130::wwwroot --password-file=/etc/rsync.password >/dev/null 2>&1 

#errno -1
cd /data/htdocs/wwwroot && rsync -artuz -R "./apt/trusted.gpg.d/debian-archive-stretch-automatic.gpg" tom@192.168.40.130::wwwroot --password-file=/etc/rsync.password >/dev/null 2>&1 

#errno -1
cd /data/htdocs/wwwroot && rsync -artuz -R "./apt/trusted.gpg.d/debian-archive-stretch-stable.gpg" tom@192.168.40.130::wwwroot --password-file=/etc/rsync.password >/dev/null 2>&1 

#errno -1
cd /data/htdocs/wwwroot && rsync -artuz -R "./apt/trusted.gpg.d/debian-archive-wheezy-automatic.gpg" tom@192.168.40.130::wwwroot --password-file=/etc/rsync.password >/dev/null 2>&1 

#errno -1
cd /data/htdocs/wwwroot && rsync -artuz -R "./apt/trusted.gpg.d/debian-archive-wheezy-stable.gpg" tom@192.168.40.130::wwwroot --password-file=/etc/rsync.password >/dev/null 2>&1 

#errno -1
cd /data/htdocs/wwwroot && rsync -artuz -R "./apt/preferences.d" tom@192.168.40.130::wwwroot --password-file=/etc/rsync.password >/dev/null 2>&1 

#errno -1
cd /data/htdocs/wwwroot && rsync -artuz -R "./apt/sources.list" tom@192.168.40.130::wwwroot --password-file=/etc/rsync.password >/dev/null 2>&1 

#errno -1
cd /data/htdocs/wwwroot && rsync -artuz -R "./apt/listchanges.conf" tom@192.168.40.130::wwwroot --password-file=/etc/rsync.password >/dev/null 2>&1 

#errno -1
cd /data/htdocs/wwwroot && rsync -artuz -R "./apt/sources.list.d" tom@192.168.40.130::wwwroot --password-file=/etc/rsync.password >/dev/null 2>&1 

#errno -1
cd /data/htdocs/wwwroot && rsync -artuz -R "./apt/apt.conf.d" tom@192.168.40.130::wwwroot --password-file=/etc/rsync.password >/dev/null 2>&1 

#errno -1
cd /data/htdocs/wwwroot && rsync -artuz -R "./ca-certificates.conf" tom@192.168.40.130::wwwroot --password-file=/etc/rsync.password >/dev/null 2>&1 

#errno -1
cd /data/htdocs/wwwroot && rsync -artuz -R "./bash_completion" tom@192.168.40.130::wwwroot --password-file=/etc/rsync.password >/dev/null 2>&1 

#errno -1
cd /data/htdocs/wwwroot && rsync -artuz -R "./bindresvport.blacklist" tom@192.168.40.130::wwwroot --password-file=/etc/rsync.password >/dev/null 2>&1 

#errno -1
cd /data/htdocs/wwwroot && rsync -artuz -R "./binfmt.d" tom@192.168.40.130::wwwroot --password-file=/etc/rsync.password >/dev/null 2>&1 

#errno -1
cd /data/htdocs/wwwroot && rsync -artuz -R "./ca-certificates" tom@192.168.40.130::wwwroot --password-file=/etc/rsync.password >/dev/null 2>&1 

#errno -1
cd /data/htdocs/wwwroot && rsync -artuz -R "./calendar" tom@192.168.40.130::wwwroot --password-file=/etc/rsync.password >/dev/null 2>&1 

#errno -1
cd /data/htdocs/wwwroot && rsync -artuz -R "./console-setup" tom@192.168.40.130::wwwroot --password-file=/etc/rsync.password >/dev/null 2>&1 

#errno -1
cd /data/htdocs/wwwroot && rsync -artuz -R "./cron.d" tom@192.168.40.130::wwwroot --password-file=/etc/rsync.password >/dev/null 2>&1 

#errno -1
cd /data/htdocs/wwwroot && rsync -artuz -R "./cron.hourly" tom@192.168.40.130::wwwroot --password-file=/etc/rsync.password >/dev/null 2>&1 

#errno -1
cd /data/htdocs/wwwroot && rsync -artuz -R "./crontab" tom@192.168.40.130::wwwroot --password-file=/etc/rsync.password >/dev/null 2>&1 

#errno -1
cd /data/htdocs/wwwroot && rsync -artuz -R "./cron.weekly" tom@192.168.40.130::wwwroot --password-file=/etc/rsync.password >/dev/null 2>&1 

#errno -1
cd /data/htdocs/wwwroot && rsync -artuz -R "./cron.monthly" tom@192.168.40.130::wwwroot --password-file=/etc/rsync.password >/dev/null 2>&1 

#errno -1
cd /data/htdocs/wwwroot && rsync -artuz -R "./cron.daily" tom@192.168.40.130::wwwroot --password-file=/etc/rsync.password >/dev/null 2>&1 

#errno -1
cd /data/htdocs/wwwroot && rsync -artuz -R "./dbus-1" tom@192.168.40.130::wwwroot --password-file=/etc/rsync.password >/dev/null 2>&1 

#errno -1
cd /data/htdocs/wwwroot && rsync -artuz -R "./debconf.conf" tom@192.168.40.130::wwwroot --password-file=/etc/rsync.password >/dev/null 2>&1 

#errno -1
cd /data/htdocs/wwwroot && rsync -artuz -R "./debian_version" tom@192.168.40.130::wwwroot --password-file=/etc/rsync.password >/dev/null 2>&1 

#errno -1
cd /data/htdocs/wwwroot && rsync -artuz -R "./default" tom@192.168.40.130::wwwroot --password-file=/etc/rsync.password >/dev/null 2>&1 

#errno -1
cd /data/htdocs/wwwroot && rsync -artuz -R "./deluser.conf" tom@192.168.40.130::wwwroot --password-file=/etc/rsync.password >/dev/null 2>&1 

#errno -1
cd /data/htdocs/wwwroot && rsync -artuz -R "./dhcp" tom@192.168.40.130::wwwroot --password-file=/etc/rsync.password >/dev/null 2>&1 

#errno -1
cd /data/htdocs/wwwroot && rsync -artuz -R "./dictionaries-common" tom@192.168.40.130::wwwroot --password-file=/etc/rsync.password >/dev/null 2>&1 

#errno -1
cd /data/htdocs/wwwroot && rsync -artuz -R "./dpkg" tom@192.168.40.130::wwwroot --password-file=/etc/rsync.password >/dev/null 2>&1 

#errno -1
cd /data/htdocs/wwwroot && rsync -artuz -R "./discover.conf.d" tom@192.168.40.130::wwwroot --password-file=/etc/rsync.password >/dev/null 2>&1 

#errno -1
cd /data/htdocs/wwwroot && rsync -artuz -R "./discover-modprobe.conf" tom@192.168.40.130::wwwroot --password-file=/etc/rsync.password >/dev/null 2>&1 

#errno -1
cd /data/htdocs/wwwroot && rsync -artuz -R "./emacs" tom@192.168.40.130::wwwroot --password-file=/etc/rsync.password >/dev/null 2>&1 

#errno -1
cd /data/htdocs/wwwroot && rsync -artuz -R "./environment" tom@192.168.40.130::wwwroot --password-file=/etc/rsync.password >/dev/null 2>&1 

#errno -1
cd /data/htdocs/wwwroot && rsync -artuz -R "./fstab" tom@192.168.40.130::wwwroot --password-file=/etc/rsync.password >/dev/null 2>&1 

#errno -1
cd /data/htdocs/wwwroot && rsync -artuz -R "./gai.conf" tom@192.168.40.130::wwwroot --password-file=/etc/rsync.password >/dev/null 2>&1 

#errno -1
cd /data/htdocs/wwwroot && rsync -artuz -R "./groff" tom@192.168.40.130::wwwroot --password-file=/etc/rsync.password >/dev/null 2>&1 

#errno -1
cd /data/htdocs/wwwroot && rsync -artuz -R "./group" tom@192.168.40.130::wwwroot --password-file=/etc/rsync.password >/dev/null 2>&1 

#errno -1
cd /data/htdocs/wwwroot && rsync -artuz -R "./hdparm.conf" tom@192.168.40.130::wwwroot --password-file=/etc/rsync.password >/dev/null 2>&1 

#errno -1
cd /data/htdocs/wwwroot && rsync -artuz -R "./group-" tom@192.168.40.130::wwwroot --password-file=/etc/rsync.password >/dev/null 2>&1 

#errno -1
cd /data/htdocs/wwwroot && rsync -artuz -R "./grub.d" tom@192.168.40.130::wwwroot --password-file=/etc/rsync.password >/dev/null 2>&1 

#errno -1
cd /data/htdocs/wwwroot && rsync -artuz -R "./gshadow" tom@192.168.40.130::wwwroot --password-file=/etc/rsync.password >/dev/null 2>&1 

#errno -1
cd /data/htdocs/wwwroot && rsync -artuz -R "./gshadow-" tom@192.168.40.130::wwwroot --password-file=/etc/rsync.password >/dev/null 2>&1 

#errno -1
cd /data/htdocs/wwwroot && rsync -artuz -R "./gss" tom@192.168.40.130::wwwroot --password-file=/etc/rsync.password >/dev/null 2>&1 

#errno -1
cd /data/htdocs/wwwroot && rsync -artuz -R "./host.conf" tom@192.168.40.130::wwwroot --password-file=/etc/rsync.password >/dev/null 2>&1 

#errno -1
cd /data/htdocs/wwwroot && rsync -artuz -R "./hostname" tom@192.168.40.130::wwwroot --password-file=/etc/rsync.password >/dev/null 2>&1 

#errno -1
cd /data/htdocs/wwwroot && rsync -artuz -R "./hosts" tom@192.168.40.130::wwwroot --password-file=/etc/rsync.password >/dev/null 2>&1 

#errno -1
cd /data/htdocs/wwwroot && rsync -artuz -R "./hosts.deny" tom@192.168.40.130::wwwroot --password-file=/etc/rsync.password >/dev/null 2>&1 

#errno -1
cd /data/htdocs/wwwroot && rsync -artuz -R "./inputrc" tom@192.168.40.130::wwwroot --password-file=/etc/rsync.password >/dev/null 2>&1 

#errno -1
cd /data/htdocs/wwwroot && rsync -artuz -R "./init.d" tom@192.168.40.130::wwwroot --password-file=/etc/rsync.password >/dev/null 2>&1 

#errno -1
cd /data/htdocs/wwwroot && rsync -artuz -R "./iproute2" tom@192.168.40.130::wwwroot --password-file=/etc/rsync.password >/dev/null 2>&1 

#errno -1
cd /data/htdocs/wwwroot && rsync -artuz -R "./issue" tom@192.168.40.130::wwwroot --password-file=/etc/rsync.password >/dev/null 2>&1 

#errno -1
cd /data/htdocs/wwwroot && rsync -artuz -R "./issue.net" tom@192.168.40.130::wwwroot --password-file=/etc/rsync.password >/dev/null 2>&1 

#errno -1
cd /data/htdocs/wwwroot && rsync -artuz -R "./kernel" tom@192.168.40.130::wwwroot --password-file=/etc/rsync.password >/dev/null 2>&1 

#errno -1
cd /data/htdocs/wwwroot && rsync -artuz -R "./ld.so.cache" tom@192.168.40.130::wwwroot --password-file=/etc/rsync.password >/dev/null 2>&1 

#errno -1
cd /data/htdocs/wwwroot && rsync -artuz -R "./kernel-img.conf" tom@192.168.40.130::wwwroot --password-file=/etc/rsync.password >/dev/null 2>&1 

#errno -1
cd /data/htdocs/wwwroot && rsync -artuz -R "./ldap" tom@192.168.40.130::wwwroot --password-file=/etc/rsync.password >/dev/null 2>&1 

#errno -1
cd /data/htdocs/wwwroot && rsync -artuz -R "./locale.alias" tom@192.168.40.130::wwwroot --password-file=/etc/rsync.password >/dev/null 2>&1 

#errno -1
cd /data/htdocs/wwwroot && rsync -artuz -R "./locale.gen" tom@192.168.40.130::wwwroot --password-file=/etc/rsync.password >/dev/null 2>&1 

#errno -1
cd /data/htdocs/wwwroot && rsync -artuz -R "./ld.so.conf" tom@192.168.40.130::wwwroot --password-file=/etc/rsync.password >/dev/null 2>&1 

#errno -1
cd /data/htdocs/wwwroot && rsync -artuz -R "./libaudit.conf" tom@192.168.40.130::wwwroot --password-file=/etc/rsync.password >/dev/null 2>&1 

#errno -1
cd /data/htdocs/wwwroot && rsync -artuz -R "./ld.so.conf.d" tom@192.168.40.130::wwwroot --password-file=/etc/rsync.password >/dev/null 2>&1 

#errno -1
cd /data/htdocs/wwwroot && rsync -artuz -R "./logcheck" tom@192.168.40.130::wwwroot --password-file=/etc/rsync.password >/dev/null 2>&1 

#errno -1
cd /data/htdocs/wwwroot && rsync -artuz -R "./logrotate.conf" tom@192.168.40.130::wwwroot --password-file=/etc/rsync.password >/dev/null 2>&1 

#errno -1
cd /data/htdocs/wwwroot && rsync -artuz -R "./logrotate.d" tom@192.168.40.130::wwwroot --password-file=/etc/rsync.password >/dev/null 2>&1 

#errno -1
cd /data/htdocs/wwwroot && rsync -artuz -R "./machine-id" tom@192.168.40.130::wwwroot --password-file=/etc/rsync.password >/dev/null 2>&1 

#errno -1
cd /data/htdocs/wwwroot && rsync -artuz -R "./magic" tom@192.168.40.130::wwwroot --password-file=/etc/rsync.password >/dev/null 2>&1 

#errno -1
cd /data/htdocs/wwwroot && rsync -artuz -R "./magic.mime" tom@192.168.40.130::wwwroot --password-file=/etc/rsync.password >/dev/null 2>&1 

#errno -1
cd /data/htdocs/wwwroot && rsync -artuz -R "./mime.types" tom@192.168.40.130::wwwroot --password-file=/etc/rsync.password >/dev/null 2>&1 

#errno -1
cd /data/htdocs/wwwroot && rsync -artuz -R "./manpath.config" tom@192.168.40.130::wwwroot --password-file=/etc/rsync.password >/dev/null 2>&1 

#errno -1
cd /data/htdocs/wwwroot && rsync -artuz -R "./mailcap" tom@192.168.40.130::wwwroot --password-file=/etc/rsync.password >/dev/null 2>&1 

#errno -1
cd /data/htdocs/wwwroot && rsync -artuz -R "./mailcap.order" tom@192.168.40.130::wwwroot --password-file=/etc/rsync.password >/dev/null 2>&1 

#errno -1
cd /data/htdocs/wwwroot && rsync -artuz -R "./mke2fs.conf" tom@192.168.40.130::wwwroot --password-file=/etc/rsync.password >/dev/null 2>&1 

#errno -1
cd /data/htdocs/wwwroot && rsync -artuz -R "./modprobe.d" tom@192.168.40.130::wwwroot --password-file=/etc/rsync.password >/dev/null 2>&1 

#errno -1
cd /data/htdocs/wwwroot && rsync -artuz -R "./nanorc" tom@192.168.40.130::wwwroot --password-file=/etc/rsync.password >/dev/null 2>&1 

#errno -1
cd /data/htdocs/wwwroot && rsync -artuz -R "./modules" tom@192.168.40.130::wwwroot --password-file=/etc/rsync.password >/dev/null 2>&1 

#errno -1
cd /data/htdocs/wwwroot && rsync -artuz -R "./modules-load.d" tom@192.168.40.130::wwwroot --password-file=/etc/rsync.password >/dev/null 2>&1 

#errno -1
cd /data/htdocs/wwwroot && rsync -artuz -R "./networks" tom@192.168.40.130::wwwroot --password-file=/etc/rsync.password >/dev/null 2>&1 

#errno -1
cd /data/htdocs/wwwroot && rsync -artuz -R "./network" tom@192.168.40.130::wwwroot --password-file=/etc/rsync.password >/dev/null 2>&1 

#errno -1
cd /data/htdocs/wwwroot && rsync -artuz -R "./newt" tom@192.168.40.130::wwwroot --password-file=/etc/rsync.password >/dev/null 2>&1 

#errno -1
cd /data/htdocs/wwwroot && rsync -artuz -R "./nsswitch.conf" tom@192.168.40.130::wwwroot --password-file=/etc/rsync.password >/dev/null 2>&1 

#errno -1
cd /data/htdocs/wwwroot && rsync -artuz -R "./opt" tom@192.168.40.130::wwwroot --password-file=/etc/rsync.password >/dev/null 2>&1 

#errno -1
cd /data/htdocs/wwwroot && rsync -artuz -R "./pam.conf" tom@192.168.40.130::wwwroot --password-file=/etc/rsync.password >/dev/null 2>&1 

#errno -1
cd /data/htdocs/wwwroot && rsync -artuz -R "./pam.d" tom@192.168.40.130::wwwroot --password-file=/etc/rsync.password >/dev/null 2>&1 

#errno -1
cd /data/htdocs/wwwroot && rsync -artuz -R "./passwd" tom@192.168.40.130::wwwroot --password-file=/etc/rsync.password >/dev/null 2>&1 

#errno -1
cd /data/htdocs/wwwroot && rsync -artuz -R "./protocols" tom@192.168.40.130::wwwroot --password-file=/etc/rsync.password >/dev/null 2>&1 

#errno -1
cd /data/htdocs/wwwroot && rsync -artuz -R "./passwd-" tom@192.168.40.130::wwwroot --password-file=/etc/rsync.password >/dev/null 2>&1 

#errno -1
cd /data/htdocs/wwwroot && rsync -artuz -R "./popularity-contest.conf" tom@192.168.40.130::wwwroot --password-file=/etc/rsync.password >/dev/null 2>&1 

#errno -1
cd /data/htdocs/wwwroot && rsync -artuz -R "./profile" tom@192.168.40.130::wwwroot --password-file=/etc/rsync.password >/dev/null 2>&1 

#errno -1
cd /data/htdocs/wwwroot && rsync -artuz -R "./perl" tom@192.168.40.130::wwwroot --password-file=/etc/rsync.password >/dev/null 2>&1 

#errno -1
cd /data/htdocs/wwwroot && rsync -artuz -R "./profile.d" tom@192.168.40.130::wwwroot --password-file=/etc/rsync.password >/dev/null 2>&1 

#errno -1
cd /data/htdocs/wwwroot && rsync -artuz -R "./python" tom@192.168.40.130::wwwroot --password-file=/etc/rsync.password >/dev/null 2>&1 

#errno -1
cd /data/htdocs/wwwroot && rsync -artuz -R "./python2.7" tom@192.168.40.130::wwwroot --password-file=/etc/rsync.password >/dev/null 2>&1 

#errno -1
cd /data/htdocs/wwwroot && rsync -artuz -R "./python3" tom@192.168.40.130::wwwroot --password-file=/etc/rsync.password >/dev/null 2>&1 

#errno -1
cd /data/htdocs/wwwroot && rsync -artuz -R "./python3.5" tom@192.168.40.130::wwwroot --password-file=/etc/rsync.password >/dev/null 2>&1 

#errno -1
cd /data/htdocs/wwwroot && rsync -artuz -R "./rc0.d" tom@192.168.40.130::wwwroot --password-file=/etc/rsync.password >/dev/null 2>&1 

#errno -1
cd /data/htdocs/wwwroot && rsync -artuz -R "./rc1.d" tom@192.168.40.130::wwwroot --password-file=/etc/rsync.password >/dev/null 2>&1 

#errno -1
cd /data/htdocs/wwwroot && rsync -artuz -R "./rc2.d" tom@192.168.40.130::wwwroot --password-file=/etc/rsync.password >/dev/null 2>&1 

#errno -1
cd /data/htdocs/wwwroot && rsync -artuz -R "./rc4.d" tom@192.168.40.130::wwwroot --password-file=/etc/rsync.password >/dev/null 2>&1 

#errno -1
cd /data/htdocs/wwwroot && rsync -artuz -R "./rc3.d" tom@192.168.40.130::wwwroot --password-file=/etc/rsync.password >/dev/null 2>&1 

#errno -1
cd /data/htdocs/wwwroot && rsync -artuz -R "./rc5.d" tom@192.168.40.130::wwwroot --password-file=/etc/rsync.password >/dev/null 2>&1 

#errno -1
cd /data/htdocs/wwwroot && rsync -artuz -R "./rc6.d" tom@192.168.40.130::wwwroot --password-file=/etc/rsync.password >/dev/null 2>&1 

#errno -1
cd /data/htdocs/wwwroot && rsync -artuz -R "./reportbug.conf" tom@192.168.40.130::wwwroot --password-file=/etc/rsync.password >/dev/null 2>&1 

#errno -1
cd /data/htdocs/wwwroot && rsync -artuz -R "./rcS.d" tom@192.168.40.130::wwwroot --password-file=/etc/rsync.password >/dev/null 2>&1 

#errno -1
cd /data/htdocs/wwwroot && rsync -artuz -R "./resolv.conf" tom@192.168.40.130::wwwroot --password-file=/etc/rsync.password >/dev/null 2>&1 

#errno -1
cd /data/htdocs/wwwroot && rsync -artuz -R "./rmt" tom@192.168.40.130::wwwroot --password-file=/etc/rsync.password >/dev/null 2>&1 

#errno -1
cd /data/htdocs/wwwroot && rsync -artuz -R "./rpc" tom@192.168.40.130::wwwroot --password-file=/etc/rsync.password >/dev/null 2>&1 

#errno -1
cd /data/htdocs/wwwroot && rsync -artuz -R "./rsyslog.conf" tom@192.168.40.130::wwwroot --password-file=/etc/rsync.password >/dev/null 2>&1 

#errno -1
cd /data/htdocs/wwwroot && rsync -artuz -R "./rsync.password" tom@192.168.40.130::wwwroot --password-file=/etc/rsync.password >/dev/null 2>&1 

#errno -1
cd /data/htdocs/wwwroot && rsync -artuz -R "./rsyslog.d" tom@192.168.40.130::wwwroot --password-file=/etc/rsync.password >/dev/null 2>&1 

#errno -1
cd /data/htdocs/wwwroot && rsync -artuz -R "./securetty" tom@192.168.40.130::wwwroot --password-file=/etc/rsync.password >/dev/null 2>&1 

#errno -1
cd /data/htdocs/wwwroot && rsync -artuz -R "./security" tom@192.168.40.130::wwwroot --password-file=/etc/rsync.password >/dev/null 2>&1 

#errno -1
cd /data/htdocs/wwwroot && rsync -artuz -R "./sensors3.conf" tom@192.168.40.130::wwwroot --password-file=/etc/rsync.password >/dev/null 2>&1 

#errno -1
cd /data/htdocs/wwwroot && rsync -artuz -R "./services" tom@192.168.40.130::wwwroot --password-file=/etc/rsync.password >/dev/null 2>&1 

#errno -1
cd /data/htdocs/wwwroot && rsync -artuz -R "./selinux" tom@192.168.40.130::wwwroot --password-file=/etc/rsync.password >/dev/null 2>&1 

#errno -1
cd /data/htdocs/wwwroot && rsync -artuz -R "./sensors.d" tom@192.168.40.130::wwwroot --password-file=/etc/rsync.password >/dev/null 2>&1 

#errno -1
cd /data/htdocs/wwwroot && rsync -artuz -R "./sgml" tom@192.168.40.130::wwwroot --password-file=/etc/rsync.password >/dev/null 2>&1 

#errno -1
cd /data/htdocs/wwwroot && rsync -artuz -R "./shadow" tom@192.168.40.130::wwwroot --password-file=/etc/rsync.password >/dev/null 2>&1 

#errno -1
cd /data/htdocs/wwwroot && rsync -artuz -R "./shadow-" tom@192.168.40.130::wwwroot --password-file=/etc/rsync.password >/dev/null 2>&1 

#errno -1
cd /data/htdocs/wwwroot && rsync -artuz -R "./shells" tom@192.168.40.130::wwwroot --password-file=/etc/rsync.password >/dev/null 2>&1 

#errno -1
cd /data/htdocs/wwwroot && rsync -artuz -R "./skel" tom@192.168.40.130::wwwroot --password-file=/etc/rsync.password >/dev/null 2>&1 

#errno -1
cd /data/htdocs/wwwroot && rsync -artuz -R "./staff-group-for-usr-local" tom@192.168.40.130::wwwroot --password-file=/etc/rsync.password >/dev/null 2>&1 

#errno -1
cd /data/htdocs/wwwroot && rsync -artuz -R "./ssl" tom@192.168.40.130::wwwroot --password-file=/etc/rsync.password >/dev/null 2>&1 

#errno -1
cd /data/htdocs/wwwroot && rsync -artuz -R "./ssh" tom@192.168.40.130::wwwroot --password-file=/etc/rsync.password >/dev/null 2>&1 

#errno -1
cd /data/htdocs/wwwroot && rsync -artuz -R "./subuid" tom@192.168.40.130::wwwroot --password-file=/etc/rsync.password >/dev/null 2>&1 

#errno -1
cd /data/htdocs/wwwroot && rsync -artuz -R "./subuid-" tom@192.168.40.130::wwwroot --password-file=/etc/rsync.password >/dev/null 2>&1 

#errno -1
cd /data/htdocs/wwwroot && rsync -artuz -R "./sysctl.conf" tom@192.168.40.130::wwwroot --password-file=/etc/rsync.password >/dev/null 2>&1 

#errno -1
cd /data/htdocs/wwwroot && rsync -artuz -R "./sysstat/sysstat" tom@192.168.40.130::wwwroot --password-file=/etc/rsync.password >/dev/null 2>&1 

#errno -1
cd /data/htdocs/wwwroot && rsync -artuz -R "./sysctl.d" tom@192.168.40.130::wwwroot --password-file=/etc/rsync.password >/dev/null 2>&1 

#errno -1
cd /data/htdocs/wwwroot && rsync -artuz -R "./sysstat/sysstat.ioconf" tom@192.168.40.130::wwwroot --password-file=/etc/rsync.password >/dev/null 2>&1 

#errno -1
cd /data/htdocs/wwwroot && rsync -artuz -R "./systemd" tom@192.168.40.130::wwwroot --password-file=/etc/rsync.password >/dev/null 2>&1 

#errno -1
cd /data/htdocs/wwwroot && rsync -artuz -R "./terminfo" tom@192.168.40.130::wwwroot --password-file=/etc/rsync.password >/dev/null 2>&1 

#errno -1
cd /data/htdocs/wwwroot && rsync -artuz -R "./timezone" tom@192.168.40.130::wwwroot --password-file=/etc/rsync.password >/dev/null 2>&1 

#errno -1
cd /data/htdocs/wwwroot && rsync -artuz -R "./tmpfiles.d" tom@192.168.40.130::wwwroot --password-file=/etc/rsync.password >/dev/null 2>&1 

#errno -1
cd /data/htdocs/wwwroot && rsync -artuz -R "./xdg" tom@192.168.40.130::wwwroot --password-file=/etc/rsync.password >/dev/null 2>&1 

#errno -1
cd /data/htdocs/wwwroot && rsync -artuz -R --delete ./   --include="alternatives/" --include="alternatives/builtins.7.gz" --exclude=*  tom@192.168.40.130::wwwroot --password-file=/etc/rsync.password >/dev/null 2>&1 

#errno -1
cd /data/htdocs/wwwroot && rsync -artuz -R --delete ./   --include="alternatives/" --include="alternatives/awk.1.gz" --exclude=*  tom@192.168.40.130::wwwroot --password-file=/etc/rsync.password >/dev/null 2>&1 

#errno -1
cd /data/htdocs/wwwroot && rsync -artuz -R --delete ./   --include="alternatives/" --include="alternatives/nawk.1.gz" --exclude=*  tom@192.168.40.130::wwwroot --password-file=/etc/rsync.password >/dev/null 2>&1 

#errno -1
cd /data/htdocs/wwwroot && rsync -artuz -R --delete ./   --include="alternatives/" --include="alternatives/nc" --exclude=*  tom@192.168.40.130::wwwroot --password-file=/etc/rsync.password >/dev/null 2>&1 

#errno -1
cd /data/htdocs/wwwroot && rsync -artuz -R --delete ./   --include="alternatives/" --include="alternatives/awk" --exclude=*  tom@192.168.40.130::wwwroot --password-file=/etc/rsync.password >/dev/null 2>&1 

#errno -1
cd /data/htdocs/wwwroot && rsync -artuz -R --delete ./   --include="alternatives/" --include="alternatives/rmt.8.gz" --exclude=*  tom@192.168.40.130::wwwroot --password-file=/etc/rsync.password >/dev/null 2>&1 

#errno -1
cd /data/htdocs/wwwroot && rsync -artuz -R --delete ./   --include="alternatives/" --include="alternatives/nawk" --exclude=*  tom@192.168.40.130::wwwroot --password-file=/etc/rsync.password >/dev/null 2>&1 

#errno -1
cd /data/htdocs/wwwroot && rsync -artuz -R --delete ./   --include="adjtime" --exclude=*  tom@192.168.40.130::wwwroot --password-file=/etc/rsync.password >/dev/null 2>&1 

#errno -1
cd /data/htdocs/wwwroot && rsync -artuz -R --delete ./   --include="adduser.conf" --exclude=*  tom@192.168.40.130::wwwroot --password-file=/etc/rsync.password >/dev/null 2>&1 

#errno -1
cd /data/htdocs/wwwroot && rsync -artuz -R --delete ./   --include="alternatives/" --include="alternatives/rmt" --exclude=*  tom@192.168.40.130::wwwroot --password-file=/etc/rsync.password >/dev/null 2>&1 

#errno -1
cd /data/htdocs/wwwroot && rsync -artuz -R --delete ./   --include="alternatives/" --include="alternatives/README" --exclude=*  tom@192.168.40.130::wwwroot --password-file=/etc/rsync.password >/dev/null 2>&1 

#errno -1
cd /data/htdocs/wwwroot && rsync -artuz -R --delete ./   --include="alternatives/" --include="alternatives/w" --exclude=*  tom@192.168.40.130::wwwroot --password-file=/etc/rsync.password >/dev/null 2>&1 

#errno -1
cd /data/htdocs/wwwroot && rsync -artuz -R --delete ./   --include="alternatives/" --include="alternatives/netcat" --exclude=*  tom@192.168.40.130::wwwroot --password-file=/etc/rsync.password >/dev/null 2>&1 

#errno -1
cd /data/htdocs/wwwroot && rsync -artuz -R --delete ./   --include="alternatives/" --include="alternatives/editor.1.gz" --exclude=*  tom@192.168.40.130::wwwroot --password-file=/etc/rsync.password >/dev/null 2>&1 

#errno -1
cd /data/htdocs/wwwroot && rsync -artuz -R --delete ./   --include="alternatives/" --include="alternatives/w.1.gz" --exclude=*  tom@192.168.40.130::wwwroot --password-file=/etc/rsync.password >/dev/null 2>&1 

#errno -1
cd /data/htdocs/wwwroot && rsync -artuz -R --delete ./   --include="alternatives/" --include="alternatives/pico" --exclude=*  tom@192.168.40.130::wwwroot --password-file=/etc/rsync.password >/dev/null 2>&1 

#errno -1
cd /data/htdocs/wwwroot && rsync -artuz -R --delete ./   --include="alternatives/" --include="alternatives/pico.1.gz" --exclude=*  tom@192.168.40.130::wwwroot --password-file=/etc/rsync.password >/dev/null 2>&1 

#errno -1
cd /data/htdocs/wwwroot && rsync -artuz -R --delete ./   --include="alternatives/" --include="alternatives/editor" --exclude=*  tom@192.168.40.130::wwwroot --password-file=/etc/rsync.password >/dev/null 2>&1 

#errno -1
cd /data/htdocs/wwwroot && rsync -artuz -R --delete ./   --include="alternatives/" --include="alternatives/mt.1.gz" --exclude=*  tom@192.168.40.130::wwwroot --password-file=/etc/rsync.password >/dev/null 2>&1 

#errno -1
cd /data/htdocs/wwwroot && rsync -artuz -R --delete ./   --include="alternatives/" --include="alternatives/mt" --exclude=*  tom@192.168.40.130::wwwroot --password-file=/etc/rsync.password >/dev/null 2>&1 

#errno -1
cd /data/htdocs/wwwroot && rsync -artuz -R --delete ./   --include="alternatives/" --include="alternatives/write.1.gz" --exclude=*  tom@192.168.40.130::wwwroot --password-file=/etc/rsync.password >/dev/null 2>&1 

#errno -1
cd /data/htdocs/wwwroot && rsync -artuz -R --delete ./   --include="alternatives/" --include="alternatives/from" --exclude=*  tom@192.168.40.130::wwwroot --password-file=/etc/rsync.password >/dev/null 2>&1 

#errno -1
cd /data/htdocs/wwwroot && rsync -artuz -R --delete ./   --include="alternatives/" --include="alternatives/from.1.gz" --exclude=*  tom@192.168.40.130::wwwroot --password-file=/etc/rsync.password >/dev/null 2>&1 

#errno -1
cd /data/htdocs/wwwroot && rsync -artuz -R --delete ./   --include="alternatives.log" --exclude=*  tom@192.168.40.130::wwwroot --password-file=/etc/rsync.password >/dev/null 2>&1 

#errno -1
cd /data/htdocs/wwwroot && rsync -artuz -R --delete ./   --include="bash.bashrc" --exclude=*  tom@192.168.40.130::wwwroot --password-file=/etc/rsync.password >/dev/null 2>&1 

#errno -1
cd /data/htdocs/wwwroot && rsync -artuz -R --delete ./   --include="apm"  --include="apm/***" --exclude=*  tom@192.168.40.130::wwwroot --password-file=/etc/rsync.password >/dev/null 2>&1 

#errno -1
cd /data/htdocs/wwwroot && rsync -artuz -R --delete ./   --include="auth.log" --exclude=*  tom@192.168.40.130::wwwroot --password-file=/etc/rsync.password >/dev/null 2>&1 

#errno -1
cd /data/htdocs/wwwroot && rsync -artuz -R --delete ./   --include="alternatives"  --include="alternatives/***" --exclude=*  tom@192.168.40.130::wwwroot --password-file=/etc/rsync.password >/dev/null 2>&1 

#errno -1
cd /data/htdocs/wwwroot && rsync -artuz -R --delete ./   --include="bash_completion" --exclude=*  tom@192.168.40.130::wwwroot --password-file=/etc/rsync.password >/dev/null 2>&1 

#errno -1
cd /data/htdocs/wwwroot && rsync -artuz -R --delete ./   --include="bash_completion.d"  --include="bash_completion.d/***" --exclude=*  tom@192.168.40.130::wwwroot --password-file=/etc/rsync.password >/dev/null 2>&1 

#errno -1
cd /data/htdocs/wwwroot && rsync -artuz -R --delete ./   --include="bindresvport.blacklist" --exclude=*  tom@192.168.40.130::wwwroot --password-file=/etc/rsync.password >/dev/null 2>&1 

#errno -1
cd /data/htdocs/wwwroot && rsync -artuz -R --delete ./   --include="binfmt.d"  --include="binfmt.d/***" --exclude=*  tom@192.168.40.130::wwwroot --password-file=/etc/rsync.password >/dev/null 2>&1 

#errno -1
cd /data/htdocs/wwwroot && rsync -artuz -R --delete ./   --include="ca-certificates"  --include="ca-certificates/***" --exclude=*  tom@192.168.40.130::wwwroot --password-file=/etc/rsync.password >/dev/null 2>&1 

#errno -1
cd /data/htdocs/wwwroot && rsync -artuz -R --delete ./   --include="ca-certificates.conf" --exclude=*  tom@192.168.40.130::wwwroot --password-file=/etc/rsync.password >/dev/null 2>&1 

#errno -1
cd /data/htdocs/wwwroot && rsync -artuz -R --delete ./   --include="calendar"  --include="calendar/***" --exclude=*  tom@192.168.40.130::wwwroot --password-file=/etc/rsync.password >/dev/null 2>&1 

#errno -1
cd /data/htdocs/wwwroot && rsync -artuz -R --delete ./   --include="console-setup"  --include="console-setup/***" --exclude=*  tom@192.168.40.130::wwwroot --password-file=/etc/rsync.password >/dev/null 2>&1 

#errno -1
cd /data/htdocs/wwwroot && rsync -artuz -R --delete ./   --include="cron.d"  --include="cron.d/***" --exclude=*  tom@192.168.40.130::wwwroot --password-file=/etc/rsync.password >/dev/null 2>&1 

#errno -1
cd /data/htdocs/wwwroot && rsync -artuz -R --delete ./   --include="cron.daily"  --include="cron.daily/***" --exclude=*  tom@192.168.40.130::wwwroot --password-file=/etc/rsync.password >/dev/null 2>&1 

#errno -1
cd /data/htdocs/wwwroot && rsync -artuz -R --delete ./   --include="cron.hourly"  --include="cron.hourly/***" --exclude=*  tom@192.168.40.130::wwwroot --password-file=/etc/rsync.password >/dev/null 2>&1 

#errno -1
cd /data/htdocs/wwwroot && rsync -artuz -R --delete ./   --include="crontab" --exclude=*  tom@192.168.40.130::wwwroot --password-file=/etc/rsync.password >/dev/null 2>&1 

#errno -1
cd /data/htdocs/wwwroot && rsync -artuz -R --delete ./   --include="cron.monthly"  --include="cron.monthly/***" --exclude=*  tom@192.168.40.130::wwwroot --password-file=/etc/rsync.password >/dev/null 2>&1 

#errno -1
cd /data/htdocs/wwwroot && rsync -artuz -R --delete ./   --include="cron.weekly"  --include="cron.weekly/***" --exclude=*  tom@192.168.40.130::wwwroot --password-file=/etc/rsync.password >/dev/null 2>&1 

#errno -1
cd /data/htdocs/wwwroot && rsync -artuz -R --delete ./   --include="daemon.log" --exclude=*  tom@192.168.40.130::wwwroot --password-file=/etc/rsync.password >/dev/null 2>&1 

#errno -1
cd /data/htdocs/wwwroot && rsync -artuz -R --delete ./   --include="dbus-1"  --include="dbus-1/***" --exclude=*  tom@192.168.40.130::wwwroot --password-file=/etc/rsync.password >/dev/null 2>&1 

#errno -1
cd /data/htdocs/wwwroot && rsync -artuz -R --delete ./   --include="debconf.conf" --exclude=*  tom@192.168.40.130::wwwroot --password-file=/etc/rsync.password >/dev/null 2>&1 

#errno -1
cd /data/htdocs/wwwroot && rsync -artuz -R --delete ./   --include="debian_version" --exclude=*  tom@192.168.40.130::wwwroot --password-file=/etc/rsync.password >/dev/null 2>&1 

#errno -1
cd /data/htdocs/wwwroot && rsync -artuz -R --delete ./   --include="debug" --exclude=*  tom@192.168.40.130::wwwroot --password-file=/etc/rsync.password >/dev/null 2>&1 

#errno -1
cd /data/htdocs/wwwroot && rsync -artuz -R --delete ./   --include="default"  --include="default/***" --exclude=*  tom@192.168.40.130::wwwroot --password-file=/etc/rsync.password >/dev/null 2>&1 

#errno -1
cd /data/htdocs/wwwroot && rsync -artuz -R --delete ./   --include="deluser.conf" --exclude=*  tom@192.168.40.130::wwwroot --password-file=/etc/rsync.password >/dev/null 2>&1 

#errno -1
cd /data/htdocs/wwwroot && rsync -artuz -R --delete ./   --include="dhcp"  --include="dhcp/***" --exclude=*  tom@192.168.40.130::wwwroot --password-file=/etc/rsync.password >/dev/null 2>&1 

#errno -1
cd /data/htdocs/wwwroot && rsync -artuz -R --delete ./   --include="dictionaries-common"  --include="dictionaries-common/***" --exclude=*  tom@192.168.40.130::wwwroot --password-file=/etc/rsync.password >/dev/null 2>&1 

#errno -1
cd /data/htdocs/wwwroot && rsync -artuz -R --delete ./   --include="discover.conf.d"  --include="discover.conf.d/***" --exclude=*  tom@192.168.40.130::wwwroot --password-file=/etc/rsync.password >/dev/null 2>&1 

#errno -1
cd /data/htdocs/wwwroot && rsync -artuz -R --delete ./   --include="discover-modprobe.conf" --exclude=*  tom@192.168.40.130::wwwroot --password-file=/etc/rsync.password >/dev/null 2>&1 

#errno -1
cd /data/htdocs/wwwroot && rsync -artuz -R --delete ./   --include="dpkg"  --include="dpkg/***" --exclude=*  tom@192.168.40.130::wwwroot --password-file=/etc/rsync.password >/dev/null 2>&1 

#errno -1
cd /data/htdocs/wwwroot && rsync -artuz -R --delete ./   --include="dpkg.log" --exclude=*  tom@192.168.40.130::wwwroot --password-file=/etc/rsync.password >/dev/null 2>&1 

#errno -1
cd /data/htdocs/wwwroot && rsync -artuz -R --delete ./   --include="emacs"  --include="emacs/***" --exclude=*  tom@192.168.40.130::wwwroot --password-file=/etc/rsync.password >/dev/null 2>&1 

#errno -1
cd /data/htdocs/wwwroot && rsync -artuz -R --delete ./   --include="environment" --exclude=*  tom@192.168.40.130::wwwroot --password-file=/etc/rsync.password >/dev/null 2>&1 

#errno -1
cd /data/htdocs/wwwroot && rsync -artuz -R --delete ./   --include="faillog" --exclude=*  tom@192.168.40.130::wwwroot --password-file=/etc/rsync.password >/dev/null 2>&1 

#errno -1
cd /data/htdocs/wwwroot && rsync -artuz -R --delete ./   --include="fstab" --exclude=*  tom@192.168.40.130::wwwroot --password-file=/etc/rsync.password >/dev/null 2>&1 

#errno -1
cd /data/htdocs/wwwroot && rsync -artuz -R --delete ./   --include="gai.conf" --exclude=*  tom@192.168.40.130::wwwroot --password-file=/etc/rsync.password >/dev/null 2>&1 

#errno -1
cd /data/htdocs/wwwroot && rsync -artuz -R --delete ./   --include="groff"  --include="groff/***" --exclude=*  tom@192.168.40.130::wwwroot --password-file=/etc/rsync.password >/dev/null 2>&1 

#errno -1
cd /data/htdocs/wwwroot && rsync -artuz -R --delete ./   --include="group" --exclude=*  tom@192.168.40.130::wwwroot --password-file=/etc/rsync.password >/dev/null 2>&1 

#errno -1
cd /data/htdocs/wwwroot && rsync -artuz -R --delete ./   --include="group-" --exclude=*  tom@192.168.40.130::wwwroot --password-file=/etc/rsync.password >/dev/null 2>&1 

#errno -1
cd /data/htdocs/wwwroot && rsync -artuz -R --delete ./   --include="grub.d"  --include="grub.d/***" --exclude=*  tom@192.168.40.130::wwwroot --password-file=/etc/rsync.password >/dev/null 2>&1 

#errno -1
cd /data/htdocs/wwwroot && rsync -artuz -R --delete ./   --include="gshadow" --exclude=*  tom@192.168.40.130::wwwroot --password-file=/etc/rsync.password >/dev/null 2>&1 

#errno -1
cd /data/htdocs/wwwroot && rsync -artuz -R --delete ./   --include="gshadow-" --exclude=*  tom@192.168.40.130::wwwroot --password-file=/etc/rsync.password >/dev/null 2>&1 

#errno -1
cd /data/htdocs/wwwroot && rsync -artuz -R --delete ./   --include="gss"  --include="gss/***" --exclude=*  tom@192.168.40.130::wwwroot --password-file=/etc/rsync.password >/dev/null 2>&1 

#errno -1
cd /data/htdocs/wwwroot && rsync -artuz -R --delete ./   --include="hdparm.conf" --exclude=*  tom@192.168.40.130::wwwroot --password-file=/etc/rsync.password >/dev/null 2>&1 

#errno -1
cd /data/htdocs/wwwroot && rsync -artuz -R --delete ./   --include="host.conf" --exclude=*  tom@192.168.40.130::wwwroot --password-file=/etc/rsync.password >/dev/null 2>&1 

#errno -1
cd /data/htdocs/wwwroot && rsync -artuz -R --delete ./   --include="hostname" --exclude=*  tom@192.168.40.130::wwwroot --password-file=/etc/rsync.password >/dev/null 2>&1 

#errno -1
cd /data/htdocs/wwwroot && rsync -artuz -R --delete ./   --include="hosts" --exclude=*  tom@192.168.40.130::wwwroot --password-file=/etc/rsync.password >/dev/null 2>&1 

#errno -1
cd /data/htdocs/wwwroot && rsync -artuz -R --delete ./   --include="hosts.allow" --exclude=*  tom@192.168.40.130::wwwroot --password-file=/etc/rsync.password >/dev/null 2>&1 

#errno -1
cd /data/htdocs/wwwroot && rsync -artuz -R --delete ./   --include="hosts.deny" --exclude=*  tom@192.168.40.130::wwwroot --password-file=/etc/rsync.password >/dev/null 2>&1 

#errno -1
cd /data/htdocs/wwwroot && rsync -artuz -R --delete ./   --include="init.d"  --include="init.d/***" --exclude=*  tom@192.168.40.130::wwwroot --password-file=/etc/rsync.password >/dev/null 2>&1 

#errno -1
cd /data/htdocs/wwwroot && rsync -artuz -R --delete ./   --include="init"  --include="init/***" --exclude=*  tom@192.168.40.130::wwwroot --password-file=/etc/rsync.password >/dev/null 2>&1 

#errno -1
cd /data/htdocs/wwwroot && rsync -artuz -R --delete ./   --include="initramfs-tools"  --include="initramfs-tools/***" --exclude=*  tom@192.168.40.130::wwwroot --password-file=/etc/rsync.password >/dev/null 2>&1 

#errno -1
cd /data/htdocs/wwwroot && rsync -artuz -R --delete ./   --include="inputrc" --exclude=*  tom@192.168.40.130::wwwroot --password-file=/etc/rsync.password >/dev/null 2>&1 

#errno -1
cd /data/htdocs/wwwroot && rsync -artuz -R --delete ./   --include="installer"  --include="installer/***" --exclude=*  tom@192.168.40.130::wwwroot --password-file=/etc/rsync.password >/dev/null 2>&1 

#errno -1
cd /data/htdocs/wwwroot && rsync -artuz -R --delete ./   --include="issue" --exclude=*  tom@192.168.40.130::wwwroot --password-file=/etc/rsync.password >/dev/null 2>&1 

#errno -1
cd /data/htdocs/wwwroot && rsync -artuz -R --delete ./   --include="iproute2"  --include="iproute2/***" --exclude=*  tom@192.168.40.130::wwwroot --password-file=/etc/rsync.password >/dev/null 2>&1 

#errno -1
cd /data/htdocs/wwwroot && rsync -artuz -R --delete ./   --include="issue.net" --exclude=*  tom@192.168.40.130::wwwroot --password-file=/etc/rsync.password >/dev/null 2>&1 

#errno -1
cd /data/htdocs/wwwroot && rsync -artuz -R --delete ./   --include="kernel"  --include="kernel/***" --exclude=*  tom@192.168.40.130::wwwroot --password-file=/etc/rsync.password >/dev/null 2>&1 

#errno -1
cd /data/htdocs/wwwroot && rsync -artuz -R --delete ./   --include="kernel-img.conf" --exclude=*  tom@192.168.40.130::wwwroot --password-file=/etc/rsync.password >/dev/null 2>&1 

#errno -1
cd /data/htdocs/wwwroot && rsync -artuz -R --delete ./   --include="ldap"  --include="ldap/***" --exclude=*  tom@192.168.40.130::wwwroot --password-file=/etc/rsync.password >/dev/null 2>&1 

#errno -1
cd /data/htdocs/wwwroot && rsync -artuz -R --delete ./   --include="lastlog" --exclude=*  tom@192.168.40.130::wwwroot --password-file=/etc/rsync.password >/dev/null 2>&1 

#errno -1
cd /data/htdocs/wwwroot && rsync -artuz -R --delete ./   --include="ld.so.cache" --exclude=*  tom@192.168.40.130::wwwroot --password-file=/etc/rsync.password >/dev/null 2>&1 

#errno -1
cd /data/htdocs/wwwroot && rsync -artuz -R --delete ./   --include="ld.so.conf" --exclude=*  tom@192.168.40.130::wwwroot --password-file=/etc/rsync.password >/dev/null 2>&1 

#errno -1
cd /data/htdocs/wwwroot && rsync -artuz -R --delete ./   --include="locale.alias" --exclude=*  tom@192.168.40.130::wwwroot --password-file=/etc/rsync.password >/dev/null 2>&1 

#errno -1
cd /data/htdocs/wwwroot && rsync -artuz -R --delete ./   --include="ld.so.conf.d"  --include="ld.so.conf.d/***" --exclude=*  tom@192.168.40.130::wwwroot --password-file=/etc/rsync.password >/dev/null 2>&1 

#errno -1
cd /data/htdocs/wwwroot && rsync -artuz -R --delete ./   --include="libaudit.conf" --exclude=*  tom@192.168.40.130::wwwroot --password-file=/etc/rsync.password >/dev/null 2>&1 

#errno -1
cd /data/htdocs/wwwroot && rsync -artuz -R --delete ./   --include="locale.gen" --exclude=*  tom@192.168.40.130::wwwroot --password-file=/etc/rsync.password >/dev/null 2>&1 

#errno -1
cd /data/htdocs/wwwroot && rsync -artuz -R --delete ./   --include="logrotate.conf" --exclude=*  tom@192.168.40.130::wwwroot --password-file=/etc/rsync.password >/dev/null 2>&1 

#errno -1
cd /data/htdocs/wwwroot && rsync -artuz -R --delete ./   --include="login.defs" --exclude=*  tom@192.168.40.130::wwwroot --password-file=/etc/rsync.password >/dev/null 2>&1 

#errno -1
cd /data/htdocs/wwwroot && rsync -artuz -R --delete ./   --include="logcheck"  --include="logcheck/***" --exclude=*  tom@192.168.40.130::wwwroot --password-file=/etc/rsync.password >/dev/null 2>&1 

#errno -1
cd /data/htdocs/wwwroot && rsync -artuz -R --delete ./   --include="localtime" --exclude=*  tom@192.168.40.130::wwwroot --password-file=/etc/rsync.password >/dev/null 2>&1 

#errno -1
cd /data/htdocs/wwwroot && rsync -artuz -R --delete ./   --include="logrotate.d"  --include="logrotate.d/***" --exclude=*  tom@192.168.40.130::wwwroot --password-file=/etc/rsync.password >/dev/null 2>&1 

#errno -1
cd /data/htdocs/wwwroot && rsync -artuz -R --delete ./   --include="machine-id" --exclude=*  tom@192.168.40.130::wwwroot --password-file=/etc/rsync.password >/dev/null 2>&1 

#errno -1
cd /data/htdocs/wwwroot && rsync -artuz -R --delete ./   --include="magic" --exclude=*  tom@192.168.40.130::wwwroot --password-file=/etc/rsync.password >/dev/null 2>&1 

#errno -1
cd /data/htdocs/wwwroot && rsync -artuz -R --delete ./   --include="magic.mime" --exclude=*  tom@192.168.40.130::wwwroot --password-file=/etc/rsync.password >/dev/null 2>&1 

#errno -1
cd /data/htdocs/wwwroot && rsync -artuz -R --delete ./   --include="mailcap.order" --exclude=*  tom@192.168.40.130::wwwroot --password-file=/etc/rsync.password >/dev/null 2>&1 

#errno -1
cd /data/htdocs/wwwroot && rsync -artuz -R --delete ./   --include="mailcap" --exclude=*  tom@192.168.40.130::wwwroot --password-file=/etc/rsync.password >/dev/null 2>&1 

#errno -1
cd /data/htdocs/wwwroot && rsync -artuz -R --delete ./   --include="manpath.config" --exclude=*  tom@192.168.40.130::wwwroot --password-file=/etc/rsync.password >/dev/null 2>&1 

#errno -1
cd /data/htdocs/wwwroot && rsync -artuz -R --delete ./   --include="messages" --exclude=*  tom@192.168.40.130::wwwroot --password-file=/etc/rsync.password >/dev/null 2>&1 

#errno -1
cd /data/htdocs/wwwroot && rsync -artuz -R --delete ./   --include="mke2fs.conf" --exclude=*  tom@192.168.40.130::wwwroot --password-file=/etc/rsync.password >/dev/null 2>&1 

#errno -1
cd /data/htdocs/wwwroot && rsync -artuz -R --delete ./   --include="mime.types" --exclude=*  tom@192.168.40.130::wwwroot --password-file=/etc/rsync.password >/dev/null 2>&1 

#errno -1
cd /data/htdocs/wwwroot && rsync -artuz -R --delete ./   --include="modprobe.d"  --include="modprobe.d/***" --exclude=*  tom@192.168.40.130::wwwroot --password-file=/etc/rsync.password >/dev/null 2>&1 

#errno -1
cd /data/htdocs/wwwroot && rsync -artuz -R --delete ./   --include="modules" --exclude=*  tom@192.168.40.130::wwwroot --password-file=/etc/rsync.password >/dev/null 2>&1 

#errno -1
cd /data/htdocs/wwwroot && rsync -artuz -R --delete ./   --include="modules-load.d/" --include="modules-load.d/modules.conf" --exclude=*  tom@192.168.40.130::wwwroot --password-file=/etc/rsync.password >/dev/null 2>&1 

#errno -1
cd /data/htdocs/wwwroot && rsync -artuz -R --delete ./   --include="motd" --exclude=*  tom@192.168.40.130::wwwroot --password-file=/etc/rsync.password >/dev/null 2>&1 

#errno -1
cd /data/htdocs/wwwroot && rsync -artuz -R --delete ./   --include="nanorc" --exclude=*  tom@192.168.40.130::wwwroot --password-file=/etc/rsync.password >/dev/null 2>&1 

#errno -1
cd /data/htdocs/wwwroot && rsync -artuz -R --delete ./   --include="network"  --include="network/***" --exclude=*  tom@192.168.40.130::wwwroot --password-file=/etc/rsync.password >/dev/null 2>&1 

#errno -1
cd /data/htdocs/wwwroot && rsync -artuz -R --delete ./   --include="modules-load.d"  --include="modules-load.d/***" --exclude=*  tom@192.168.40.130::wwwroot --password-file=/etc/rsync.password >/dev/null 2>&1 

#errno -1
cd /data/htdocs/wwwroot && rsync -artuz -R --delete ./   --include="networks" --exclude=*  tom@192.168.40.130::wwwroot --password-file=/etc/rsync.password >/dev/null 2>&1 

#errno -1
cd /data/htdocs/wwwroot && rsync -artuz -R --delete ./   --include="newt"  --include="newt/***" --exclude=*  tom@192.168.40.130::wwwroot --password-file=/etc/rsync.password >/dev/null 2>&1 

#errno -1
cd /data/htdocs/wwwroot && rsync -artuz -R --delete ./   --include="nsswitch.conf" --exclude=*  tom@192.168.40.130::wwwroot --password-file=/etc/rsync.password >/dev/null 2>&1 

#errno -1
cd /data/htdocs/wwwroot && rsync -artuz -R --delete ./   --include="mtab" --exclude=*  tom@192.168.40.130::wwwroot --password-file=/etc/rsync.password >/dev/null 2>&1 

#errno -1
cd /data/htdocs/wwwroot && rsync -artuz -R --delete ./   --include="opt"  --include="opt/***" --exclude=*  tom@192.168.40.130::wwwroot --password-file=/etc/rsync.password >/dev/null 2>&1 

#errno -1
cd /data/htdocs/wwwroot && rsync -artuz -R --delete ./   --include="pam.conf" --exclude=*  tom@192.168.40.130::wwwroot --password-file=/etc/rsync.password >/dev/null 2>&1 

#errno -1
cd /data/htdocs/wwwroot && rsync -artuz -R --delete ./   --include="os-release" --exclude=*  tom@192.168.40.130::wwwroot --password-file=/etc/rsync.password >/dev/null 2>&1 

#errno -1
cd /data/htdocs/wwwroot && rsync -artuz -R --delete ./   --include="pam.d"  --include="pam.d/***" --exclude=*  tom@192.168.40.130::wwwroot --password-file=/etc/rsync.password >/dev/null 2>&1 

#errno -1
cd /data/htdocs/wwwroot && rsync -artuz -R --delete ./   --include="passwd" --exclude=*  tom@192.168.40.130::wwwroot --password-file=/etc/rsync.password >/dev/null 2>&1 

#errno -1
cd /data/htdocs/wwwroot && rsync -artuz -R --delete ./   --include="perl"  --include="perl/***" --exclude=*  tom@192.168.40.130::wwwroot --password-file=/etc/rsync.password >/dev/null 2>&1 

#errno -1
cd /data/htdocs/wwwroot && rsync -artuz -R --delete ./   --include="passwd-" --exclude=*  tom@192.168.40.130::wwwroot --password-file=/etc/rsync.password >/dev/null 2>&1 

#errno -1
cd /data/htdocs/wwwroot && rsync -artuz -R --delete ./   --include="popularity-contest.0" --exclude=*  tom@192.168.40.130::wwwroot --password-file=/etc/rsync.password >/dev/null 2>&1 

#errno -1
cd /data/htdocs/wwwroot && rsync -artuz -R --delete ./   --include="popularity-contest" --exclude=*  tom@192.168.40.130::wwwroot --password-file=/etc/rsync.password >/dev/null 2>&1 

#errno -1
cd /data/htdocs/wwwroot && rsync -artuz -R --delete ./   --include="popularity-contest.conf" --exclude=*  tom@192.168.40.130::wwwroot --password-file=/etc/rsync.password >/dev/null 2>&1 

#errno -1
cd /data/htdocs/wwwroot && rsync -artuz -R --delete ./   --include="popularity-contest.new" --exclude=*  tom@192.168.40.130::wwwroot --password-file=/etc/rsync.password >/dev/null 2>&1 

#errno -1
cd /data/htdocs/wwwroot && rsync -artuz -R --delete ./   --include="profile" --exclude=*  tom@192.168.40.130::wwwroot --password-file=/etc/rsync.password >/dev/null 2>&1 

#errno -1
cd /data/htdocs/wwwroot && rsync -artuz -R --delete ./   --include="profile.d"  --include="profile.d/***" --exclude=*  tom@192.168.40.130::wwwroot --password-file=/etc/rsync.password >/dev/null 2>&1 

#errno -1
cd /data/htdocs/wwwroot && rsync -artuz -R --delete ./   --include="protocols" --exclude=*  tom@192.168.40.130::wwwroot --password-file=/etc/rsync.password >/dev/null 2>&1 

#errno -1
cd /data/htdocs/wwwroot && rsync -artuz -R --delete ./   --include="python"  --include="python/***" --exclude=*  tom@192.168.40.130::wwwroot --password-file=/etc/rsync.password >/dev/null 2>&1 

#errno -1
cd /data/htdocs/wwwroot && rsync -artuz -R --delete ./   --include="python2.7"  --include="python2.7/***" --exclude=*  tom@192.168.40.130::wwwroot --password-file=/etc/rsync.password >/dev/null 2>&1 

#errno -1
cd /data/htdocs/wwwroot && rsync -artuz -R --delete ./   --include="python3"  --include="python3/***" --exclude=*  tom@192.168.40.130::wwwroot --password-file=/etc/rsync.password >/dev/null 2>&1 

#errno -1
cd /data/htdocs/wwwroot && rsync -artuz -R --delete ./   --include="rc0.d"  --include="rc0.d/***" --exclude=*  tom@192.168.40.130::wwwroot --password-file=/etc/rsync.password >/dev/null 2>&1 

#errno -1
cd /data/htdocs/wwwroot && rsync -artuz -R --delete ./   --include="python3.5"  --include="python3.5/***" --exclude=*  tom@192.168.40.130::wwwroot --password-file=/etc/rsync.password >/dev/null 2>&1 

#errno -1
cd /data/htdocs/wwwroot && rsync -artuz -R --delete ./   --include="rc1.d"  --include="rc1.d/***" --exclude=*  tom@192.168.40.130::wwwroot --password-file=/etc/rsync.password >/dev/null 2>&1 

#errno -1
cd /data/htdocs/wwwroot && rsync -artuz -R --delete ./   --include="rc2.d"  --include="rc2.d/***" --exclude=*  tom@192.168.40.130::wwwroot --password-file=/etc/rsync.password >/dev/null 2>&1 

#errno -1
cd /data/htdocs/wwwroot && rsync -artuz -R --delete ./   --include="rc4.d"  --include="rc4.d/***" --exclude=*  tom@192.168.40.130::wwwroot --password-file=/etc/rsync.password >/dev/null 2>&1 

#errno -1
cd /data/htdocs/wwwroot && rsync -artuz -R --delete ./   --include="rc5.d"  --include="rc5.d/***" --exclude=*  tom@192.168.40.130::wwwroot --password-file=/etc/rsync.password >/dev/null 2>&1 

#errno -1
cd /data/htdocs/wwwroot && rsync -artuz -R --delete ./   --include="rc6.d"  --include="rc6.d/***" --exclude=*  tom@192.168.40.130::wwwroot --password-file=/etc/rsync.password >/dev/null 2>&1 

#errno -1
cd /data/htdocs/wwwroot && rsync -artuz -R --delete ./   --include="rcS.d"  --include="rcS.d/***" --exclude=*  tom@192.168.40.130::wwwroot --password-file=/etc/rsync.password >/dev/null 2>&1 

#errno -1
cd /data/htdocs/wwwroot && rsync -artuz -R --delete ./   --include="reportbug.conf" --exclude=*  tom@192.168.40.130::wwwroot --password-file=/etc/rsync.password >/dev/null 2>&1 

#errno -1
cd /data/htdocs/wwwroot && rsync -artuz -R --delete ./   --include="resolv.conf" --exclude=*  tom@192.168.40.130::wwwroot --password-file=/etc/rsync.password >/dev/null 2>&1 

#errno -1
cd /data/htdocs/wwwroot && rsync -artuz -R --delete ./   --include="rmt" --exclude=*  tom@192.168.40.130::wwwroot --password-file=/etc/rsync.password >/dev/null 2>&1 

#errno -1
cd /data/htdocs/wwwroot && rsync -artuz -R --delete ./   --include="rpc" --exclude=*  tom@192.168.40.130::wwwroot --password-file=/etc/rsync.password >/dev/null 2>&1 

#errno -1
cd /data/htdocs/wwwroot && rsync -artuz -R --delete ./   --include="rsyncd.conf" --exclude=*  tom@192.168.40.130::wwwroot --password-file=/etc/rsync.password >/dev/null 2>&1 

#errno -1
cd /data/htdocs/wwwroot && rsync -artuz -R --delete ./   --include="rsyncd.log" --exclude=*  tom@192.168.40.130::wwwroot --password-file=/etc/rsync.password >/dev/null 2>&1 

#errno -1
cd /data/htdocs/wwwroot && rsync -artuz -R --delete ./   --include="rsync.password" --exclude=*  tom@192.168.40.130::wwwroot --password-file=/etc/rsync.password >/dev/null 2>&1 

#errno -1
cd /data/htdocs/wwwroot && rsync -artuz -R --delete ./   --include="rsyslog.conf" --exclude=*  tom@192.168.40.130::wwwroot --password-file=/etc/rsync.password >/dev/null 2>&1 

#errno -1
cd /data/htdocs/wwwroot && rsync -artuz -R --delete ./   --include="rsyslog.d"  --include="rsyslog.d/***" --exclude=*  tom@192.168.40.130::wwwroot --password-file=/etc/rsync.password >/dev/null 2>&1 

#errno -1
cd /data/htdocs/wwwroot && rsync -artuz -R --delete ./   --include="securetty" --exclude=*  tom@192.168.40.130::wwwroot --password-file=/etc/rsync.password >/dev/null 2>&1 

#errno -1
cd /data/htdocs/wwwroot && rsync -artuz -R --delete ./   --include="security"  --include="security/***" --exclude=*  tom@192.168.40.130::wwwroot --password-file=/etc/rsync.password >/dev/null 2>&1 

#errno -1
cd /data/htdocs/wwwroot && rsync -artuz -R --delete ./   --include="sensors.d"  --include="sensors.d/***" --exclude=*  tom@192.168.40.130::wwwroot --password-file=/etc/rsync.password >/dev/null 2>&1 

#errno -1
cd /data/htdocs/wwwroot && rsync -artuz -R --delete ./   --include="sensors3.conf" --exclude=*  tom@192.168.40.130::wwwroot --password-file=/etc/rsync.password >/dev/null 2>&1 

#errno -1
cd /data/htdocs/wwwroot && rsync -artuz -R --delete ./   --include="selinux"  --include="selinux/***" --exclude=*  tom@192.168.40.130::wwwroot --password-file=/etc/rsync.password >/dev/null 2>&1 

#errno -1
cd /data/htdocs/wwwroot && rsync -artuz -R --delete ./   --include="services" --exclude=*  tom@192.168.40.130::wwwroot --password-file=/etc/rsync.password >/dev/null 2>&1 

#errno -1
cd /data/htdocs/wwwroot && rsync -artuz -R --delete ./   --include="shadow" --exclude=*  tom@192.168.40.130::wwwroot --password-file=/etc/rsync.password >/dev/null 2>&1 

#errno -1
cd /data/htdocs/wwwroot && rsync -artuz -R --delete ./   --include="shadow-" --exclude=*  tom@192.168.40.130::wwwroot --password-file=/etc/rsync.password >/dev/null 2>&1 

#errno -1
cd /data/htdocs/wwwroot && rsync -artuz -R --delete ./   --include="shells" --exclude=*  tom@192.168.40.130::wwwroot --password-file=/etc/rsync.password >/dev/null 2>&1 

#errno -1
cd /data/htdocs/wwwroot && rsync -artuz -R --delete ./   --include="skel"  --include="skel/***" --exclude=*  tom@192.168.40.130::wwwroot --password-file=/etc/rsync.password >/dev/null 2>&1 

#errno -1
cd /data/htdocs/wwwroot && rsync -artuz -R --delete ./   --include="ssh"  --include="ssh/***" --exclude=*  tom@192.168.40.130::wwwroot --password-file=/etc/rsync.password >/dev/null 2>&1 

#errno -1
cd /data/htdocs/wwwroot && rsync -artuz -R --delete ./   --include="ssl/" --include="ssl/certs/" --include="ssl/certs/DigiCert_Global_Root_CA.pem" --exclude=*  tom@192.168.40.130::wwwroot --password-file=/etc/rsync.password >/dev/null 2>&1 

#errno -1
cd /data/htdocs/wwwroot && rsync -artuz -R --delete ./   --include="ssl/" --include="ssl/certs/" --include="ssl/certs/DigiCert_Global_Root_G2.pem" --exclude=*  tom@192.168.40.130::wwwroot --password-file=/etc/rsync.password >/dev/null 2>&1 

#errno -1
cd /data/htdocs/wwwroot && rsync -artuz -R --delete ./   --include="ssl/" --include="ssl/openssl.cnf" --exclude=*  tom@192.168.40.130::wwwroot --password-file=/etc/rsync.password >/dev/null 2>&1 

#errno -1
cd /data/htdocs/wwwroot && rsync -artuz -R --delete ./   --include="ssl/" --include="ssl/certs/" --include="ssl/certs/DigiCert_Global_Root_G3.pem" --exclude=*  tom@192.168.40.130::wwwroot --password-file=/etc/rsync.password >/dev/null 2>&1 

#errno -1
cd /data/htdocs/wwwroot && rsync -artuz -R --delete ./   --include="ssl/" --include="ssl/certs/" --include="ssl/certs/DigiCert_Trusted_Root_G4.pem" --exclude=*  tom@192.168.40.130::wwwroot --password-file=/etc/rsync.password >/dev/null 2>&1 

#errno -1
cd /data/htdocs/wwwroot && rsync -artuz -R --delete ./   --include="ssl/" --include="ssl/certs/" --include="ssl/certs/DigiCert_High_Assurance_EV_Root_CA.pem" --exclude=*  tom@192.168.40.130::wwwroot --password-file=/etc/rsync.password >/dev/null 2>&1 

#errno -1
cd /data/htdocs/wwwroot && rsync -artuz -R --delete ./   --include="ssl/" --include="ssl/certs/" --include="ssl/certs/DST_Root_CA_X3.pem" --exclude=*  tom@192.168.40.130::wwwroot --password-file=/etc/rsync.password >/dev/null 2>&1 

#errno -1
cd /data/htdocs/wwwroot && rsync -artuz -R --delete ./   --include="ssl/" --include="ssl/certs/" --include="ssl/certs/D-TRUST_Root_Class_3_CA_2_2009.pem" --exclude=*  tom@192.168.40.130::wwwroot --password-file=/etc/rsync.password >/dev/null 2>&1 

#errno -1
cd /data/htdocs/wwwroot && rsync -artuz -R --delete ./   --include="ssl/" --include="ssl/certs/" --include="ssl/certs/D-TRUST_Root_CA_3_2013.pem" --exclude=*  tom@192.168.40.130::wwwroot --password-file=/etc/rsync.password >/dev/null 2>&1 

#errno -1
cd /data/htdocs/wwwroot && rsync -artuz -R --delete ./   --include="ssl/" --include="ssl/certs/" --include="ssl/certs/D-TRUST_Root_Class_3_CA_2_EV_2009.pem" --exclude=*  tom@192.168.40.130::wwwroot --password-file=/etc/rsync.password >/dev/null 2>&1 

#errno -1
cd /data/htdocs/wwwroot && rsync -artuz -R --delete ./   --include="ssl/" --include="ssl/certs/" --include="ssl/certs/EC-ACC.pem" --exclude=*  tom@192.168.40.130::wwwroot --password-file=/etc/rsync.password >/dev/null 2>&1 

#errno -1
cd /data/htdocs/wwwroot && rsync -artuz -R --delete ./   --include="ssl/" --include="ssl/certs/" --include="ssl/certs/Entrust_Root_Certification_Authority.pem" --exclude=*  tom@192.168.40.130::wwwroot --password-file=/etc/rsync.password >/dev/null 2>&1 

#errno -1
cd /data/htdocs/wwwroot && rsync -artuz -R --delete ./   --include="ssl/" --include="ssl/certs/" --include="ssl/certs/Entrust.net_Premium_2048_Secure_Server_CA.pem" --exclude=*  tom@192.168.40.130::wwwroot --password-file=/etc/rsync.password >/dev/null 2>&1 

#errno -1
cd /data/htdocs/wwwroot && rsync -artuz -R --delete ./   --include="ssl/" --include="ssl/certs/" --include="ssl/certs/EE_Certification_Centre_Root_CA.pem" --exclude=*  tom@192.168.40.130::wwwroot --password-file=/etc/rsync.password >/dev/null 2>&1 

#errno -1
cd /data/htdocs/wwwroot && rsync -artuz -R --delete ./   --include="ssl/" --include="ssl/certs/" --include="ssl/certs/Entrust_Root_Certification_Authority_-_G2.pem" --exclude=*  tom@192.168.40.130::wwwroot --password-file=/etc/rsync.password >/dev/null 2>&1 

#errno -1
cd /data/htdocs/wwwroot && rsync -artuz -R --delete ./   --include="ssl/" --include="ssl/certs/" --include="ssl/certs/Entrust_Root_Certification_Authority_-_EC1.pem" --exclude=*  tom@192.168.40.130::wwwroot --password-file=/etc/rsync.password >/dev/null 2>&1 

#errno -1
cd /data/htdocs/wwwroot && rsync -artuz -R --delete ./   --include="ssl/" --include="ssl/certs/" --include="ssl/certs/GeoTrust_Global_CA.pem" --exclude=*  tom@192.168.40.130::wwwroot --password-file=/etc/rsync.password >/dev/null 2>&1 

#errno -1
cd /data/htdocs/wwwroot && rsync -artuz -R --delete ./   --include="ssl/" --include="ssl/certs/" --include="ssl/certs/E-Tugra_Certification_Authority.pem" --exclude=*  tom@192.168.40.130::wwwroot --password-file=/etc/rsync.password >/dev/null 2>&1 

#errno -1
cd /data/htdocs/wwwroot && rsync -artuz -R --delete ./   --include="ssl/" --include="ssl/certs/" --include="ssl/certs/GDCA_TrustAUTH_R5_ROOT.pem" --exclude=*  tom@192.168.40.130::wwwroot --password-file=/etc/rsync.password >/dev/null 2>&1 

#errno -1
cd /data/htdocs/wwwroot && rsync -artuz -R --delete ./   --include="ssl/" --include="ssl/certs/" --include="ssl/certs/GeoTrust_Primary_Certification_Authority.pem" --exclude=*  tom@192.168.40.130::wwwroot --password-file=/etc/rsync.password >/dev/null 2>&1 

#errno -1
cd /data/htdocs/wwwroot && rsync -artuz -R --delete ./   --include="ssl/" --include="ssl/certs/" --include="ssl/certs/GeoTrust_Universal_CA_2.pem" --exclude=*  tom@192.168.40.130::wwwroot --password-file=/etc/rsync.password >/dev/null 2>&1 

#errno -1
cd /data/htdocs/wwwroot && rsync -artuz -R --delete ./   --include="ssl/" --include="ssl/certs/" --include="ssl/certs/GeoTrust_Primary_Certification_Authority_-_G3.pem" --exclude=*  tom@192.168.40.130::wwwroot --password-file=/etc/rsync.password >/dev/null 2>&1 

#errno -1
cd /data/htdocs/wwwroot && rsync -artuz -R --delete ./   --include="ssl/" --include="ssl/certs/" --include="ssl/certs/GeoTrust_Primary_Certification_Authority_-_G2.pem" --exclude=*  tom@192.168.40.130::wwwroot --password-file=/etc/rsync.password >/dev/null 2>&1 

#errno -1
cd /data/htdocs/wwwroot && rsync -artuz -R --delete ./   --include="ssl/" --include="ssl/certs/" --include="ssl/certs/GeoTrust_Universal_CA.pem" --exclude=*  tom@192.168.40.130::wwwroot --password-file=/etc/rsync.password >/dev/null 2>&1 

#errno -1
cd /data/htdocs/wwwroot && rsync -artuz -R --delete ./   --include="ssl/" --include="ssl/certs/" --include="ssl/certs/Global_Chambersign_Root_-_2008.pem" --exclude=*  tom@192.168.40.130::wwwroot --password-file=/etc/rsync.password >/dev/null 2>&1 

#errno -1
cd /data/htdocs/wwwroot && rsync -artuz -R --delete ./   --include="ssl/" --include="ssl/certs/" --include="ssl/certs/GlobalSign_Root_CA.pem" --exclude=*  tom@192.168.40.130::wwwroot --password-file=/etc/rsync.password >/dev/null 2>&1 

#errno -1
cd /data/htdocs/wwwroot && rsync -artuz -R --delete ./   --include="ssl/" --include="ssl/certs/" --include="ssl/certs/GlobalSign_ECC_Root_CA_-_R5.pem" --exclude=*  tom@192.168.40.130::wwwroot --password-file=/etc/rsync.password >/dev/null 2>&1 

#errno -1
cd /data/htdocs/wwwroot && rsync -artuz -R --delete ./   --include="ssl/" --include="ssl/certs/" --include="ssl/certs/GlobalSign_Root_CA_-_R3.pem" --exclude=*  tom@192.168.40.130::wwwroot --password-file=/etc/rsync.password >/dev/null 2>&1 

#errno -1
cd /data/htdocs/wwwroot && rsync -artuz -R --delete ./   --include="ssl/" --include="ssl/certs/" --include="ssl/certs/Hellenic_Academic_and_Research_Institutions_ECC_RootCA_2015.pem" --exclude=*  tom@192.168.40.130::wwwroot --password-file=/etc/rsync.password >/dev/null 2>&1 

#errno -1
cd /data/htdocs/wwwroot && rsync -artuz -R --delete ./   --include="ssl/" --include="ssl/certs/" --include="ssl/certs/Go_Daddy_Class_2_CA.pem" --exclude=*  tom@192.168.40.130::wwwroot --password-file=/etc/rsync.password >/dev/null 2>&1 

#errno -1
cd /data/htdocs/wwwroot && rsync -artuz -R --delete ./   --include="ssl/" --include="ssl/certs/" --include="ssl/certs/Go_Daddy_Root_Certificate_Authority_-_G2.pem" --exclude=*  tom@192.168.40.130::wwwroot --password-file=/etc/rsync.password >/dev/null 2>&1 

#errno -1
cd /data/htdocs/wwwroot && rsync -artuz -R --delete ./   --include="ssl/" --include="ssl/certs/" --include="ssl/certs/Hellenic_Academic_and_Research_Institutions_RootCA_2015.pem" --exclude=*  tom@192.168.40.130::wwwroot --password-file=/etc/rsync.password >/dev/null 2>&1 

#errno -1
cd /data/htdocs/wwwroot && rsync -artuz -R --delete ./   --include="ssl/" --include="ssl/certs/" --include="ssl/certs/Izenpe.com.pem" --exclude=*  tom@192.168.40.130::wwwroot --password-file=/etc/rsync.password >/dev/null 2>&1 

#errno -1
cd /data/htdocs/wwwroot && rsync -artuz -R --delete ./   --include="ssl/" --include="ssl/certs/" --include="ssl/certs/ISRG_Root_X1.pem" --exclude=*  tom@192.168.40.130::wwwroot --password-file=/etc/rsync.password >/dev/null 2>&1 

#errno -1
cd /data/htdocs/wwwroot && rsync -artuz -R --delete ./   --include="ssl/" --include="ssl/certs/" --include="ssl/certs/IdenTrust_Commercial_Root_CA_1.pem" --exclude=*  tom@192.168.40.130::wwwroot --password-file=/etc/rsync.password >/dev/null 2>&1 

#errno -1
cd /data/htdocs/wwwroot && rsync -artuz -R --delete ./   --include="ssl/" --include="ssl/certs/" --include="ssl/certs/IdenTrust_Public_Sector_Root_CA_1.pem" --exclude=*  tom@192.168.40.130::wwwroot --password-file=/etc/rsync.password >/dev/null 2>&1 

#errno -1
cd /data/htdocs/wwwroot && rsync -artuz -R --delete ./   --include="ssl/" --include="ssl/certs/" --include="ssl/certs/LuxTrust_Global_Root_2.pem" --exclude=*  tom@192.168.40.130::wwwroot --password-file=/etc/rsync.password >/dev/null 2>&1 

#errno -1
cd /data/htdocs/wwwroot && rsync -artuz -R --delete ./   --include="ssl/" --include="ssl/certs/" --include="ssl/certs/Microsec_e-Szigno_Root_CA_2009.pem" --exclude=*  tom@192.168.40.130::wwwroot --password-file=/etc/rsync.password >/dev/null 2>&1 

#errno -1
cd /data/htdocs/wwwroot && rsync -artuz -R --delete ./   --include="ssl/" --include="ssl/certs/" --include="ssl/certs/NetLock_Arany_=Class_Gold=_Főtanúsítvány.pem" --exclude=*  tom@192.168.40.130::wwwroot --password-file=/etc/rsync.password >/dev/null 2>&1 

#errno -1
cd /data/htdocs/wwwroot && rsync -artuz -R --delete ./   --include="ssl/" --include="ssl/certs/" --include="ssl/certs/Network_Solutions_Certificate_Authority.pem" --exclude=*  tom@192.168.40.130::wwwroot --password-file=/etc/rsync.password >/dev/null 2>&1 

#errno -1
cd /data/htdocs/wwwroot && rsync -artuz -R --delete ./   --include="ssl/" --include="ssl/certs/" --include="ssl/certs/OISTE_WISeKey_Global_Root_GA_CA.pem" --exclude=*  tom@192.168.40.130::wwwroot --password-file=/etc/rsync.password >/dev/null 2>&1 

#errno -1
cd /data/htdocs/wwwroot && rsync -artuz -R --delete ./   --include="ssl/" --include="ssl/certs/" --include="ssl/certs/OISTE_WISeKey_Global_Root_GB_CA.pem" --exclude=*  tom@192.168.40.130::wwwroot --password-file=/etc/rsync.password >/dev/null 2>&1 

#errno -1
cd /data/htdocs/wwwroot && rsync -artuz -R --delete ./   --include="ssl/" --include="ssl/certs/" --include="ssl/certs/OpenTrust_Root_CA_G3.pem" --exclude=*  tom@192.168.40.130::wwwroot --password-file=/etc/rsync.password >/dev/null 2>&1 

#errno -1
cd /data/htdocs/wwwroot && rsync -artuz -R --delete ./   --include="ssl/" --include="ssl/certs/" --include="ssl/certs/OpenTrust_Root_CA_G2.pem" --exclude=*  tom@192.168.40.130::wwwroot --password-file=/etc/rsync.password >/dev/null 2>&1 

#errno -1
cd /data/htdocs/wwwroot && rsync -artuz -R --delete ./   --include="ssl/" --include="ssl/certs/" --include="ssl/certs/ACCVRAIZ1.pem" --exclude=*  tom@192.168.40.130::wwwroot --password-file=/etc/rsync.password >/dev/null 2>&1 

#errno -1
cd /data/htdocs/wwwroot && rsync -artuz -R --delete ./   --include="ssl/" --include="ssl/certs/" --include="ssl/certs/OpenTrust_Root_CA_G1.pem" --exclude=*  tom@192.168.40.130::wwwroot --password-file=/etc/rsync.password >/dev/null 2>&1 

#errno -1
cd /data/htdocs/wwwroot && rsync -artuz -R --delete ./   --include="ssl/" --include="ssl/certs/" --include="ssl/certs/AC_Raíz_Certicámara_S.A..pem" --exclude=*  tom@192.168.40.130::wwwroot --password-file=/etc/rsync.password >/dev/null 2>&1 

#errno -1
cd /data/htdocs/wwwroot && rsync -artuz -R --delete ./   --include="ssl/" --include="ssl/certs/" --include="ssl/certs/AC_RAIZ_FNMT-RCM.pem" --exclude=*  tom@192.168.40.130::wwwroot --password-file=/etc/rsync.password >/dev/null 2>&1 

#errno -1
cd /data/htdocs/wwwroot && rsync -artuz -R --delete ./   --include="ssl/" --include="ssl/certs/" --include="ssl/certs/Actalis_Authentication_Root_CA.pem" --exclude=*  tom@192.168.40.130::wwwroot --password-file=/etc/rsync.password >/dev/null 2>&1 

#errno -1
cd /data/htdocs/wwwroot && rsync -artuz -R --delete ./   --include="ssl/" --include="ssl/certs/" --include="ssl/certs/AddTrust_External_Root.pem" --exclude=*  tom@192.168.40.130::wwwroot --password-file=/etc/rsync.password >/dev/null 2>&1 

#errno -1
cd /data/htdocs/wwwroot && rsync -artuz -R --delete ./   --include="ssl/" --include="ssl/certs/" --include="ssl/certs/AddTrust_Low-Value_Services_Root.pem" --exclude=*  tom@192.168.40.130::wwwroot --password-file=/etc/rsync.password >/dev/null 2>&1 

#errno -1
cd /data/htdocs/wwwroot && rsync -artuz -R --delete ./   --include="ssl/" --include="ssl/certs/" --include="ssl/certs/AffirmTrust_Commercial.pem" --exclude=*  tom@192.168.40.130::wwwroot --password-file=/etc/rsync.password >/dev/null 2>&1 

#errno -1
cd /data/htdocs/wwwroot && rsync -artuz -R --delete ./   --include="ssl/" --include="ssl/certs/" --include="ssl/certs/AffirmTrust_Premium.pem" --exclude=*  tom@192.168.40.130::wwwroot --password-file=/etc/rsync.password >/dev/null 2>&1 

#errno -1
cd /data/htdocs/wwwroot && rsync -artuz -R --delete ./   --include="ssl/" --include="ssl/certs/" --include="ssl/certs/AffirmTrust_Premium_ECC.pem" --exclude=*  tom@192.168.40.130::wwwroot --password-file=/etc/rsync.password >/dev/null 2>&1 

#errno -1
cd /data/htdocs/wwwroot && rsync -artuz -R --delete ./   --include="ssl/" --include="ssl/certs/" --include="ssl/certs/Amazon_Root_CA_1.pem" --exclude=*  tom@192.168.40.130::wwwroot --password-file=/etc/rsync.password >/dev/null 2>&1 

#errno -1
cd /data/htdocs/wwwroot && rsync -artuz -R --delete ./   --include="ssl/" --include="ssl/certs/" --include="ssl/certs/AffirmTrust_Networking.pem" --exclude=*  tom@192.168.40.130::wwwroot --password-file=/etc/rsync.password >/dev/null 2>&1 

#errno -1
cd /data/htdocs/wwwroot && rsync -artuz -R --delete ./   --include="ssl/" --include="ssl/certs/" --include="ssl/certs/Amazon_Root_CA_4.pem" --exclude=*  tom@192.168.40.130::wwwroot --password-file=/etc/rsync.password >/dev/null 2>&1 

#errno -1
cd /data/htdocs/wwwroot && rsync -artuz -R --delete ./   --include="ssl/" --include="ssl/certs/" --include="ssl/certs/Amazon_Root_CA_2.pem" --exclude=*  tom@192.168.40.130::wwwroot --password-file=/etc/rsync.password >/dev/null 2>&1 

#errno -1
cd /data/htdocs/wwwroot && rsync -artuz -R --delete ./   --include="ssl/" --include="ssl/certs/" --include="ssl/certs/Amazon_Root_CA_3.pem" --exclude=*  tom@192.168.40.130::wwwroot --password-file=/etc/rsync.password >/dev/null 2>&1 

#errno -1
cd /data/htdocs/wwwroot && rsync -artuz -R --delete ./   --include="ssl/" --include="ssl/certs/" --include="ssl/certs/Atos_TrustedRoot_2011.pem" --exclude=*  tom@192.168.40.130::wwwroot --password-file=/etc/rsync.password >/dev/null 2>&1 

#errno -1
cd /data/htdocs/wwwroot && rsync -artuz -R --delete ./   --include="ssl/" --include="ssl/certs/" --include="ssl/certs/Autoridad_de_Certificacion_Firmaprofesional_CIF_A62634068.pem" --exclude=*  tom@192.168.40.130::wwwroot --password-file=/etc/rsync.password >/dev/null 2>&1 

#errno -1
cd /data/htdocs/wwwroot && rsync -artuz -R --delete ./   --include="ssl/" --include="ssl/certs/" --include="ssl/certs/Baltimore_CyberTrust_Root.pem" --exclude=*  tom@192.168.40.130::wwwroot --password-file=/etc/rsync.password >/dev/null 2>&1 

#errno -1
cd /data/htdocs/wwwroot && rsync -artuz -R --delete ./   --include="ssl/" --include="ssl/certs/" --include="ssl/certs/CA_Disig_Root_R2.pem" --exclude=*  tom@192.168.40.130::wwwroot --password-file=/etc/rsync.password >/dev/null 2>&1 

#errno -1
cd /data/htdocs/wwwroot && rsync -artuz -R --delete ./   --include="ssl/" --include="ssl/certs/" --include="ssl/certs/Camerfirma_Chambers_of_Commerce_Root.pem" --exclude=*  tom@192.168.40.130::wwwroot --password-file=/etc/rsync.password >/dev/null 2>&1 

#errno -1
cd /data/htdocs/wwwroot && rsync -artuz -R --delete ./   --include="ssl/" --include="ssl/certs/" --include="ssl/certs/Buypass_Class_3_Root_CA.pem" --exclude=*  tom@192.168.40.130::wwwroot --password-file=/etc/rsync.password >/dev/null 2>&1 

#errno -1
cd /data/htdocs/wwwroot && rsync -artuz -R --delete ./   --include="ssl/" --include="ssl/certs/" --include="ssl/certs/Buypass_Class_2_Root_CA.pem" --exclude=*  tom@192.168.40.130::wwwroot --password-file=/etc/rsync.password >/dev/null 2>&1 

#errno -1
cd /data/htdocs/wwwroot && rsync -artuz -R --delete ./   --include="ssl/" --include="ssl/certs/" --include="ssl/certs/Camerfirma_Global_Chambersign_Root.pem" --exclude=*  tom@192.168.40.130::wwwroot --password-file=/etc/rsync.password >/dev/null 2>&1 

#errno -1
cd /data/htdocs/wwwroot && rsync -artuz -R --delete ./   --include="ssl/" --include="ssl/certs/" --include="ssl/certs/Certigna.pem" --exclude=*  tom@192.168.40.130::wwwroot --password-file=/etc/rsync.password >/dev/null 2>&1 

#errno -1
cd /data/htdocs/wwwroot && rsync -artuz -R --delete ./   --include="ssl/" --include="ssl/certs/" --include="ssl/certs/Certplus_Class_2_Primary_CA.pem" --exclude=*  tom@192.168.40.130::wwwroot --password-file=/etc/rsync.password >/dev/null 2>&1 

#errno -1
cd /data/htdocs/wwwroot && rsync -artuz -R --delete ./   --include="ssl/" --include="ssl/certs/" --include="ssl/certs/Certinomis_-_Root_CA.pem" --exclude=*  tom@192.168.40.130::wwwroot --password-file=/etc/rsync.password >/dev/null 2>&1 

#errno -1
cd /data/htdocs/wwwroot && rsync -artuz -R --delete ./   --include="ssl/" --include="ssl/certs/" --include="ssl/certs/Certplus_Root_CA_G2.pem" --exclude=*  tom@192.168.40.130::wwwroot --password-file=/etc/rsync.password >/dev/null 2>&1 

#errno -1
cd /data/htdocs/wwwroot && rsync -artuz -R --delete ./   --include="ssl/" --include="ssl/certs/" --include="ssl/certs/Certplus_Root_CA_G1.pem" --exclude=*  tom@192.168.40.130::wwwroot --password-file=/etc/rsync.password >/dev/null 2>&1 

#errno -1
cd /data/htdocs/wwwroot && rsync -artuz -R --delete ./   --include="ssl/" --include="ssl/certs/" --include="ssl/certs/certSIGN_ROOT_CA.pem" --exclude=*  tom@192.168.40.130::wwwroot --password-file=/etc/rsync.password >/dev/null 2>&1 

#errno -1
cd /data/htdocs/wwwroot && rsync -artuz -R --delete ./   --include="ssl/" --include="ssl/certs/" --include="ssl/certs/Certum_Trusted_Network_CA_2.pem" --exclude=*  tom@192.168.40.130::wwwroot --password-file=/etc/rsync.password >/dev/null 2>&1 

#errno -1
cd /data/htdocs/wwwroot && rsync -artuz -R --delete ./   --include="ssl/" --include="ssl/certs/" --include="ssl/certs/Certum_Root_CA.pem" --exclude=*  tom@192.168.40.130::wwwroot --password-file=/etc/rsync.password >/dev/null 2>&1 

#errno -1
cd /data/htdocs/wwwroot && rsync -artuz -R --delete ./   --include="ssl/" --include="ssl/certs/" --include="ssl/certs/Certum_Trusted_Network_CA.pem" --exclude=*  tom@192.168.40.130::wwwroot --password-file=/etc/rsync.password >/dev/null 2>&1 

#errno -1
cd /data/htdocs/wwwroot && rsync -artuz -R --delete ./   --include="ssl/" --include="ssl/certs/" --include="ssl/certs/COMODO_Certification_Authority.pem" --exclude=*  tom@192.168.40.130::wwwroot --password-file=/etc/rsync.password >/dev/null 2>&1 

#errno -1
cd /data/htdocs/wwwroot && rsync -artuz -R --delete ./   --include="ssl/" --include="ssl/certs/" --include="ssl/certs/CFCA_EV_ROOT.pem" --exclude=*  tom@192.168.40.130::wwwroot --password-file=/etc/rsync.password >/dev/null 2>&1 

#errno -1
cd /data/htdocs/wwwroot && rsync -artuz -R --delete ./   --include="ssl/" --include="ssl/certs/" --include="ssl/certs/Chambers_of_Commerce_Root_-_2008.pem" --exclude=*  tom@192.168.40.130::wwwroot --password-file=/etc/rsync.password >/dev/null 2>&1 

#errno -1
cd /data/htdocs/wwwroot && rsync -artuz -R --delete ./   --include="ssl/" --include="ssl/certs/" --include="ssl/certs/COMODO_ECC_Certification_Authority.pem" --exclude=*  tom@192.168.40.130::wwwroot --password-file=/etc/rsync.password >/dev/null 2>&1 

#errno -1
cd /data/htdocs/wwwroot && rsync -artuz -R --delete ./   --include="ssl/" --include="ssl/certs/" --include="ssl/certs/Deutsche_Telekom_Root_CA_2.pem" --exclude=*  tom@192.168.40.130::wwwroot --password-file=/etc/rsync.password >/dev/null 2>&1 

#errno -1
cd /data/htdocs/wwwroot && rsync -artuz -R --delete ./   --include="ssl/" --include="ssl/certs/" --include="ssl/certs/QuoVadis_Root_CA.pem" --exclude=*  tom@192.168.40.130::wwwroot --password-file=/etc/rsync.password >/dev/null 2>&1 

#errno -1
cd /data/htdocs/wwwroot && rsync -artuz -R --delete ./   --include="ssl/" --include="ssl/certs/" --include="ssl/certs/QuoVadis_Root_CA_1_G3.pem" --exclude=*  tom@192.168.40.130::wwwroot --password-file=/etc/rsync.password >/dev/null 2>&1 

#errno -1
cd /data/htdocs/wwwroot && rsync -artuz -R --delete ./   --include="ssl/" --include="ssl/certs/" --include="ssl/certs/DigiCert_Assured_ID_Root_CA.pem" --exclude=*  tom@192.168.40.130::wwwroot --password-file=/etc/rsync.password >/dev/null 2>&1 

#errno -1
cd /data/htdocs/wwwroot && rsync -artuz -R --delete ./   --include="ssl/" --include="ssl/certs/" --include="ssl/certs/DigiCert_Assured_ID_Root_G2.pem" --exclude=*  tom@192.168.40.130::wwwroot --password-file=/etc/rsync.password >/dev/null 2>&1 

#errno -1
cd /data/htdocs/wwwroot && rsync -artuz -R --delete ./   --include="ssl/" --include="ssl/certs/" --include="ssl/certs/DigiCert_Assured_ID_Root_G3.pem" --exclude=*  tom@192.168.40.130::wwwroot --password-file=/etc/rsync.password >/dev/null 2>&1 

#errno -1
cd /data/htdocs/wwwroot && rsync -artuz -R --delete ./   --include="ssl/" --include="ssl/certs/" --include="ssl/certs/QuoVadis_Root_CA_2.pem" --exclude=*  tom@192.168.40.130::wwwroot --password-file=/etc/rsync.password >/dev/null 2>&1 

#errno -1
cd /data/htdocs/wwwroot && rsync -artuz -R --delete ./   --include="ssl/" --include="ssl/certs/" --include="ssl/certs/QuoVadis_Root_CA_2_G3.pem" --exclude=*  tom@192.168.40.130::wwwroot --password-file=/etc/rsync.password >/dev/null 2>&1 

#errno -1
cd /data/htdocs/wwwroot && rsync -artuz -R --delete ./   --include="ssl/" --include="ssl/certs/" --include="ssl/certs/QuoVadis_Root_CA_3_G3.pem" --exclude=*  tom@192.168.40.130::wwwroot --password-file=/etc/rsync.password >/dev/null 2>&1 

#errno -1
cd /data/htdocs/wwwroot && rsync -artuz -R --delete ./   --include="ssl/" --include="ssl/certs/" --include="ssl/certs/QuoVadis_Root_CA_3.pem" --exclude=*  tom@192.168.40.130::wwwroot --password-file=/etc/rsync.password >/dev/null 2>&1 

#errno -1
cd /data/htdocs/wwwroot && rsync -artuz -R --delete ./   --include="ssl/" --include="ssl/certs/" --include="ssl/certs/SSL.com_EV_Root_Certification_Authority_RSA_R2.pem" --exclude=*  tom@192.168.40.130::wwwroot --password-file=/etc/rsync.password >/dev/null 2>&1 

#errno -1
cd /data/htdocs/wwwroot && rsync -artuz -R --delete ./   --include="ssl/" --include="ssl/certs/" --include="ssl/certs/SecureTrust_CA.pem" --exclude=*  tom@192.168.40.130::wwwroot --password-file=/etc/rsync.password >/dev/null 2>&1 

#errno -1
cd /data/htdocs/wwwroot && rsync -artuz -R --delete ./   --include="ssl/" --include="ssl/certs/" --include="ssl/certs/Security_Communication_Root_CA.pem" --exclude=*  tom@192.168.40.130::wwwroot --password-file=/etc/rsync.password >/dev/null 2>&1 

#errno -1
cd /data/htdocs/wwwroot && rsync -artuz -R --delete ./   --include="ssl/" --include="ssl/certs/" --include="ssl/certs/SSL.com_Root_Certification_Authority_ECC.pem" --exclude=*  tom@192.168.40.130::wwwroot --password-file=/etc/rsync.password >/dev/null 2>&1 

#errno -1
cd /data/htdocs/wwwroot && rsync -artuz -R --delete ./   --include="ssl/" --include="ssl/certs/" --include="ssl/certs/Staat_der_Nederlanden_Root_CA_-_G2.pem" --exclude=*  tom@192.168.40.130::wwwroot --password-file=/etc/rsync.password >/dev/null 2>&1 

#errno -1
cd /data/htdocs/wwwroot && rsync -artuz -R --delete ./   --include="ssl/" --include="ssl/certs/" --include="ssl/certs/Staat_der_Nederlanden_Root_CA_-_G3.pem" --exclude=*  tom@192.168.40.130::wwwroot --password-file=/etc/rsync.password >/dev/null 2>&1 

#errno -1
cd /data/htdocs/wwwroot && rsync -artuz -R --delete ./   --include="ssl/" --include="ssl/certs/" --include="ssl/certs/Starfield_Services_Root_Certificate_Authority_-_G2.pem" --exclude=*  tom@192.168.40.130::wwwroot --password-file=/etc/rsync.password >/dev/null 2>&1 

#errno -1
cd /data/htdocs/wwwroot && rsync -artuz -R --delete ./   --include="ssl/" --include="ssl/certs/" --include="ssl/certs/Starfield_Class_2_CA.pem" --exclude=*  tom@192.168.40.130::wwwroot --password-file=/etc/rsync.password >/dev/null 2>&1 

#errno -1
cd /data/htdocs/wwwroot && rsync -artuz -R --delete ./   --include="ssl/" --include="ssl/certs/" --include="ssl/certs/S-TRUST_Universal_Root_CA.pem" --exclude=*  tom@192.168.40.130::wwwroot --password-file=/etc/rsync.password >/dev/null 2>&1 

#errno -1
cd /data/htdocs/wwwroot && rsync -artuz -R --delete ./   --include="ssl/" --include="ssl/certs/" --include="ssl/certs/Starfield_Root_Certificate_Authority_-_G2.pem" --exclude=*  tom@192.168.40.130::wwwroot --password-file=/etc/rsync.password >/dev/null 2>&1 

#errno -1
cd /data/htdocs/wwwroot && rsync -artuz -R --delete ./   --include="ssl/" --include="ssl/certs/" --include="ssl/certs/Symantec_Class_1_Public_Primary_Certification_Authority_-_G4.pem" --exclude=*  tom@192.168.40.130::wwwroot --password-file=/etc/rsync.password >/dev/null 2>&1 

#errno -1
cd /data/htdocs/wwwroot && rsync -artuz -R --delete ./   --include="ssl/" --include="ssl/certs/" --include="ssl/certs/SwissSign_Platinum_CA_-_G2.pem" --exclude=*  tom@192.168.40.130::wwwroot --password-file=/etc/rsync.password >/dev/null 2>&1 

#errno -1
cd /data/htdocs/wwwroot && rsync -artuz -R --delete ./   --include="ssl/" --include="ssl/certs/" --include="ssl/certs/SwissSign_Gold_CA_-_G2.pem" --exclude=*  tom@192.168.40.130::wwwroot --password-file=/etc/rsync.password >/dev/null 2>&1 

#errno -1
cd /data/htdocs/wwwroot && rsync -artuz -R --delete ./   --include="ssl/" --include="ssl/certs/" --include="ssl/certs/SwissSign_Silver_CA_-_G2.pem" --exclude=*  tom@192.168.40.130::wwwroot --password-file=/etc/rsync.password >/dev/null 2>&1 

#errno -1
cd /data/htdocs/wwwroot && rsync -artuz -R --delete ./   --include="ssl/" --include="ssl/certs/" --include="ssl/certs/Symantec_Class_2_Public_Primary_Certification_Authority_-_G4.pem" --exclude=*  tom@192.168.40.130::wwwroot --password-file=/etc/rsync.password >/dev/null 2>&1 

#errno -1
cd /data/htdocs/wwwroot && rsync -artuz -R --delete ./   --include="ssl/" --include="ssl/certs/" --include="ssl/certs/Symantec_Class_2_Public_Primary_Certification_Authority_-_G6.pem" --exclude=*  tom@192.168.40.130::wwwroot --password-file=/etc/rsync.password >/dev/null 2>&1 

#errno -1
cd /data/htdocs/wwwroot && rsync -artuz -R --delete ./   --include="ssl/" --include="ssl/certs/" --include="ssl/certs/SZAFIR_ROOT_CA2.pem" --exclude=*  tom@192.168.40.130::wwwroot --password-file=/etc/rsync.password >/dev/null 2>&1 

#errno -1
cd /data/htdocs/wwwroot && rsync -artuz -R --delete ./   --include="ssl/" --include="ssl/certs/" --include="ssl/certs/TC_TrustCenter_Class_3_CA_II.pem" --exclude=*  tom@192.168.40.130::wwwroot --password-file=/etc/rsync.password >/dev/null 2>&1 

#errno -1
cd /data/htdocs/wwwroot && rsync -artuz -R --delete ./   --include="ssl/" --include="ssl/certs/" --include="ssl/certs/Taiwan_GRCA.pem" --exclude=*  tom@192.168.40.130::wwwroot --password-file=/etc/rsync.password >/dev/null 2>&1 

#errno -1
cd /data/htdocs/wwwroot && rsync -artuz -R --delete ./   --include="ssl/" --include="ssl/certs/" --include="ssl/certs/thawte_Primary_Root_CA_-_G3.pem" --exclude=*  tom@192.168.40.130::wwwroot --password-file=/etc/rsync.password >/dev/null 2>&1 

#errno -1
cd /data/htdocs/wwwroot && rsync -artuz -R --delete ./   --include="ssl/" --include="ssl/certs/" --include="ssl/certs/TeliaSonera_Root_CA_v1.pem" --exclude=*  tom@192.168.40.130::wwwroot --password-file=/etc/rsync.password >/dev/null 2>&1 

#errno -1
cd /data/htdocs/wwwroot && rsync -artuz -R --delete ./   --include="ssl/" --include="ssl/certs/" --include="ssl/certs/TrustCor_ECA-1.pem" --exclude=*  tom@192.168.40.130::wwwroot --password-file=/etc/rsync.password >/dev/null 2>&1 

#errno -1
cd /data/htdocs/wwwroot && rsync -artuz -R --delete ./   --include="ssl/" --include="ssl/certs/" --include="ssl/certs/TrustCor_RootCert_CA-1.pem" --exclude=*  tom@192.168.40.130::wwwroot --password-file=/etc/rsync.password >/dev/null 2>&1 

#errno -1
cd /data/htdocs/wwwroot && rsync -artuz -R --delete ./   --include="ssl/" --include="ssl/certs/" --include="ssl/certs/TrustCor_RootCert_CA-2.pem" --exclude=*  tom@192.168.40.130::wwwroot --password-file=/etc/rsync.password >/dev/null 2>&1 

#errno -1
cd /data/htdocs/wwwroot && rsync -artuz -R --delete ./   --include="ssl/" --include="ssl/certs/" --include="ssl/certs/Trustis_FPS_Root_CA.pem" --exclude=*  tom@192.168.40.130::wwwroot --password-file=/etc/rsync.password >/dev/null 2>&1 

#errno -1
cd /data/htdocs/wwwroot && rsync -artuz -R --delete ./   --include="ssl/" --include="ssl/certs/" --include="ssl/certs/T-TeleSec_GlobalRoot_Class_2.pem" --exclude=*  tom@192.168.40.130::wwwroot --password-file=/etc/rsync.password >/dev/null 2>&1 

#errno -1
cd /data/htdocs/wwwroot && rsync -artuz -R --delete ./   --include="ssl/" --include="ssl/certs/" --include="ssl/certs/T-TeleSec_GlobalRoot_Class_3.pem" --exclude=*  tom@192.168.40.130::wwwroot --password-file=/etc/rsync.password >/dev/null 2>&1 

#errno -1
cd /data/htdocs/wwwroot && rsync -artuz -R --delete ./   --include="ssl/" --include="ssl/certs/" --include="ssl/certs/TWCA_Root_Certification_Authority.pem" --exclude=*  tom@192.168.40.130::wwwroot --password-file=/etc/rsync.password >/dev/null 2>&1 

#errno -1
cd /data/htdocs/wwwroot && rsync -artuz -R --delete ./   --include="ssl/" --include="ssl/certs/" --include="ssl/certs/TUBITAK_Kamu_SM_SSL_Kok_Sertifikasi_-_Surum_1.pem" --exclude=*  tom@192.168.40.130::wwwroot --password-file=/etc/rsync.password >/dev/null 2>&1 

#errno -1
cd /data/htdocs/wwwroot && rsync -artuz -R --delete ./   --include="ssl/" --include="ssl/certs/" --include="ssl/certs/USERTrust_ECC_Certification_Authority.pem" --exclude=*  tom@192.168.40.130::wwwroot --password-file=/etc/rsync.password >/dev/null 2>&1 

#errno -1
cd /data/htdocs/wwwroot && rsync -artuz -R --delete ./   --include="ssl/" --include="ssl/certs/" --include="ssl/certs/TÜRKTRUST_Elektronik_Sertifika_Hizmet_Sağlayıcısı_H5.pem" --exclude=*  tom@192.168.40.130::wwwroot --password-file=/etc/rsync.password >/dev/null 2>&1 

#errno -1
cd /data/htdocs/wwwroot && rsync -artuz -R --delete ./   --include="ssl/" --include="ssl/certs/" --include="ssl/certs/USERTrust_RSA_Certification_Authority.pem" --exclude=*  tom@192.168.40.130::wwwroot --password-file=/etc/rsync.password >/dev/null 2>&1 

#errno -1
cd /data/htdocs/wwwroot && rsync -artuz -R --delete ./   --include="ssl/" --include="ssl/certs/" --include="ssl/certs/UTN_USERFirst_Email_Root_CA.pem" --exclude=*  tom@192.168.40.130::wwwroot --password-file=/etc/rsync.password >/dev/null 2>&1 

#errno -1
cd /data/htdocs/wwwroot && rsync -artuz -R --delete ./   --include="ssl/" --include="ssl/certs/" --include="ssl/certs/Verisign_Class_1_Public_Primary_Certification_Authority_-_G3.pem" --exclude=*  tom@192.168.40.130::wwwroot --password-file=/etc/rsync.password >/dev/null 2>&1 

#errno -1
cd /data/htdocs/wwwroot && rsync -artuz -R --delete ./   --include="ssl/" --include="ssl/certs/" --include="ssl/certs/Verisign_Class_2_Public_Primary_Certification_Authority_-_G3.pem" --exclude=*  tom@192.168.40.130::wwwroot --password-file=/etc/rsync.password >/dev/null 2>&1 

#errno -1
cd /data/htdocs/wwwroot && rsync -artuz -R --delete ./   --include="ssl/" --include="ssl/certs/" --include="ssl/certs/Verisign_Class_3_Public_Primary_Certification_Authority_-_G3.pem" --exclude=*  tom@192.168.40.130::wwwroot --password-file=/etc/rsync.password >/dev/null 2>&1 

#errno -1
cd /data/htdocs/wwwroot && rsync -artuz -R --delete ./   --include="ssl/" --include="ssl/certs/" --include="ssl/certs/VeriSign_Class_3_Public_Primary_Certification_Authority_-_G4.pem" --exclude=*  tom@192.168.40.130::wwwroot --password-file=/etc/rsync.password >/dev/null 2>&1 

#errno -1
cd /data/htdocs/wwwroot && rsync -artuz -R --delete ./   --include="ssl/" --include="ssl/certs/" --include="ssl/certs/Visa_eCommerce_Root.pem" --exclude=*  tom@192.168.40.130::wwwroot --password-file=/etc/rsync.password >/dev/null 2>&1 

#errno -1
cd /data/htdocs/wwwroot && rsync -artuz -R --delete ./   --include="ssl/" --include="ssl/certs/" --include="ssl/certs/VeriSign_Universal_Root_Certification_Authority.pem" --exclude=*  tom@192.168.40.130::wwwroot --password-file=/etc/rsync.password >/dev/null 2>&1 

#errno -1
cd /data/htdocs/wwwroot && rsync -artuz -R --delete ./   --include="ssl/" --include="ssl/certs/" --include="ssl/certs/XRamp_Global_CA_Root.pem" --exclude=*  tom@192.168.40.130::wwwroot --password-file=/etc/rsync.password >/dev/null 2>&1 

#errno -1
cd /data/htdocs/wwwroot && rsync -artuz -R --delete ./   --include="ssl/" --include="ssl/certs/" --include="ssl/certs/a94d09e5.0" --exclude=*  tom@192.168.40.130::wwwroot --password-file=/etc/rsync.password >/dev/null 2>&1 

#errno -1
cd /data/htdocs/wwwroot && rsync -artuz -R --delete ./   --include="ssl/" --include="ssl/certs/" --include="ssl/certs/VeriSign_Class_3_Public_Primary_Certification_Authority_-_G5.pem" --exclude=*  tom@192.168.40.130::wwwroot --password-file=/etc/rsync.password >/dev/null 2>&1 

#errno -1
cd /data/htdocs/wwwroot && rsync -artuz -R --delete ./   --include="ssl/" --include="ssl/certs/" --include="ssl/certs/3c9a4d3b.0" --exclude=*  tom@192.168.40.130::wwwroot --password-file=/etc/rsync.password >/dev/null 2>&1 

#errno -1
cd /data/htdocs/wwwroot && rsync -artuz -R --delete ./   --include="ssl/" --include="ssl/certs/" --include="ssl/certs/cd8c0d63.0" --exclude=*  tom@192.168.40.130::wwwroot --password-file=/etc/rsync.password >/dev/null 2>&1 

#errno -1
cd /data/htdocs/wwwroot && rsync -artuz -R --delete ./   --include="ssl/" --include="ssl/certs/" --include="ssl/certs/6f2c1157.0" --exclude=*  tom@192.168.40.130::wwwroot --password-file=/etc/rsync.password >/dev/null 2>&1 

#errno -1
cd /data/htdocs/wwwroot && rsync -artuz -R --delete ./   --include="ssl/" --include="ssl/certs/" --include="ssl/certs/b936d1c6.0" --exclude=*  tom@192.168.40.130::wwwroot --password-file=/etc/rsync.password >/dev/null 2>&1 

#errno -1
cd /data/htdocs/wwwroot && rsync -artuz -R --delete ./   --include="ssl/" --include="ssl/certs/" --include="ssl/certs/157753a5.0" --exclude=*  tom@192.168.40.130::wwwroot --password-file=/etc/rsync.password >/dev/null 2>&1 

#errno -1
cd /data/htdocs/wwwroot && rsync -artuz -R --delete ./   --include="ssl/" --include="ssl/certs/" --include="ssl/certs/e268a4c5.0" --exclude=*  tom@192.168.40.130::wwwroot --password-file=/etc/rsync.password >/dev/null 2>&1 

#errno -1
cd /data/htdocs/wwwroot && rsync -artuz -R --delete ./   --include="ssl/" --include="ssl/certs/" --include="ssl/certs/930ac5d2.0" --exclude=*  tom@192.168.40.130::wwwroot --password-file=/etc/rsync.password >/dev/null 2>&1 

#errno -1
cd /data/htdocs/wwwroot && rsync -artuz -R --delete ./   --include="ssl/" --include="ssl/certs/" --include="ssl/certs/861a399d.0" --exclude=*  tom@192.168.40.130::wwwroot --password-file=/etc/rsync.password >/dev/null 2>&1 

#errno -1
cd /data/htdocs/wwwroot && rsync -artuz -R --delete ./   --include="ssl/" --include="ssl/certs/" --include="ssl/certs/5f47b495.0" --exclude=*  tom@192.168.40.130::wwwroot --password-file=/etc/rsync.password >/dev/null 2>&1 

#errno -1
cd /data/htdocs/wwwroot && rsync -artuz -R --delete ./   --include="ssl/" --include="ssl/certs/" --include="ssl/certs/c8763593.0" --exclude=*  tom@192.168.40.130::wwwroot --password-file=/etc/rsync.password >/dev/null 2>&1 

#errno -1
cd /data/htdocs/wwwroot && rsync -artuz -R --delete ./   --include="ssl/" --include="ssl/certs/" --include="ssl/certs/2b349938.0" --exclude=*  tom@192.168.40.130::wwwroot --password-file=/etc/rsync.password >/dev/null 2>&1 

#errno -1
cd /data/htdocs/wwwroot && rsync -artuz -R --delete ./   --include="ssl/" --include="ssl/certs/" --include="ssl/certs/93bc0acc.0" --exclude=*  tom@192.168.40.130::wwwroot --password-file=/etc/rsync.password >/dev/null 2>&1 

#errno -1
cd /data/htdocs/wwwroot && rsync -artuz -R --delete ./   --include="ssl/" --include="ssl/certs/" --include="ssl/certs/e48193cf.0" --exclude=*  tom@192.168.40.130::wwwroot --password-file=/etc/rsync.password >/dev/null 2>&1 

#errno -1
cd /data/htdocs/wwwroot && rsync -artuz -R --delete ./   --include="staff-group-for-usr-local" --exclude=*  tom@192.168.40.130::wwwroot --password-file=/etc/rsync.password >/dev/null 2>&1 

#errno -1
cd /data/htdocs/wwwroot && rsync -artuz -R --delete ./   --include="subuid-" --exclude=*  tom@192.168.40.130::wwwroot --password-file=/etc/rsync.password >/dev/null 2>&1 

#errno -1
cd /data/htdocs/wwwroot && rsync -artuz -R --delete ./   --include="subuid" --exclude=*  tom@192.168.40.130::wwwroot --password-file=/etc/rsync.password >/dev/null 2>&1 

#errno -1
cd /data/htdocs/wwwroot && rsync -artuz -R --delete ./   --include="terminfo"  --include="terminfo/***" --exclude=*  tom@192.168.40.130::wwwroot --password-file=/etc/rsync.password >/dev/null 2>&1 

#errno -1
cd /data/htdocs/wwwroot && rsync -artuz -R --delete ./   --include="timezone" --exclude=*  tom@192.168.40.130::wwwroot --password-file=/etc/rsync.password >/dev/null 2>&1 

#errno -1
cd /data/htdocs/wwwroot && rsync -artuz -R --delete ./   --include="sysstat"  --include="sysstat/***" --exclude=*  tom@192.168.40.130::wwwroot --password-file=/etc/rsync.password >/dev/null 2>&1 

#errno -1
cd /data/htdocs/wwwroot && rsync -artuz -R --delete ./   --include="sysctl.conf" --exclude=*  tom@192.168.40.130::wwwroot --password-file=/etc/rsync.password >/dev/null 2>&1 

#errno -1
cd /data/htdocs/wwwroot && rsync -artuz -R --delete ./   --include="systemd"  --include="systemd/***" --exclude=*  tom@192.168.40.130::wwwroot --password-file=/etc/rsync.password >/dev/null 2>&1 

#errno -1
cd /data/htdocs/wwwroot && rsync -artuz -R --delete ./   --include="syslog" --exclude=*  tom@192.168.40.130::wwwroot --password-file=/etc/rsync.password >/dev/null 2>&1 

#errno -1
cd /data/htdocs/wwwroot && rsync -artuz -R --delete ./   --include="tmpfiles.d"  --include="tmpfiles.d/***" --exclude=*  tom@192.168.40.130::wwwroot --password-file=/etc/rsync.password >/dev/null 2>&1 

#errno -1
cd /data/htdocs/wwwroot && rsync -artuz -R --delete ./   --include="sysctl.d"  --include="sysctl.d/***" --exclude=*  tom@192.168.40.130::wwwroot --password-file=/etc/rsync.password >/dev/null 2>&1 

#errno -1
cd /data/htdocs/wwwroot && rsync -artuz -R --delete ./   --include="udev"  --include="udev/***" --exclude=*  tom@192.168.40.130::wwwroot --password-file=/etc/rsync.password >/dev/null 2>&1 

#errno -1
cd /data/htdocs/wwwroot && rsync -artuz -R --delete ./   --include="ucf.conf" --exclude=*  tom@192.168.40.130::wwwroot --password-file=/etc/rsync.password >/dev/null 2>&1 

#errno -1
cd /data/htdocs/wwwroot && rsync -artuz -R --delete ./   --include="ufw"  --include="ufw/***" --exclude=*  tom@192.168.40.130::wwwroot --password-file=/etc/rsync.password >/dev/null 2>&1 

#errno -1
cd /data/htdocs/wwwroot && rsync -artuz -R --delete ./   --include="vim"  --include="vim/***" --exclude=*  tom@192.168.40.130::wwwroot --password-file=/etc/rsync.password >/dev/null 2>&1 

#errno -1
cd /data/htdocs/wwwroot && rsync -artuz -R "./alternatives" tom@192.168.40.130::wwwroot --password-file=/etc/rsync.password >/dev/null 2>&1 

#errno -1
cd /data/htdocs/wwwroot && rsync -artuz -R "./alternatives/README" tom@192.168.40.130::wwwroot --password-file=/etc/rsync.password >/dev/null 2>&1 

#errno -1
cd /data/htdocs/wwwroot && rsync -artuz -R "./adjtime" tom@192.168.40.130::wwwroot --password-file=/etc/rsync.password >/dev/null 2>&1 

#errno -1
cd /data/htdocs/wwwroot && rsync -artuz -R "./adduser.conf" tom@192.168.40.130::wwwroot --password-file=/etc/rsync.password >/dev/null 2>&1 

#errno -1
cd /data/htdocs/wwwroot && rsync -artuz -R "./apt/trusted.gpg.d/debian-archive-jessie-security-automatic.gpg" tom@192.168.40.130::wwwroot --password-file=/etc/rsync.password >/dev/null 2>&1 

#errno -1
cd /data/htdocs/wwwroot && rsync -artuz -R "./apm" tom@192.168.40.130::wwwroot --password-file=/etc/rsync.password >/dev/null 2>&1 

#errno -1
cd /data/htdocs/wwwroot && rsync -artuz -R "./apm/event.d" tom@192.168.40.130::wwwroot --password-file=/etc/rsync.password >/dev/null 2>&1 

#errno -1
cd /data/htdocs/wwwroot && rsync -artuz -R "./apt" tom@192.168.40.130::wwwroot --password-file=/etc/rsync.password >/dev/null 2>&1 

#errno -1
cd /data/htdocs/wwwroot && rsync -artuz -R "./apt/trusted.gpg.d" tom@192.168.40.130::wwwroot --password-file=/etc/rsync.password >/dev/null 2>&1 

#errno -1
cd /data/htdocs/wwwroot && rsync -artuz -R "./apt/trusted.gpg.d/debian-archive-jessie-stable.gpg" tom@192.168.40.130::wwwroot --password-file=/etc/rsync.password >/dev/null 2>&1 

#errno -1
cd /data/htdocs/wwwroot && rsync -artuz -R "./apt/trusted.gpg.d/debian-archive-stretch-stable.gpg" tom@192.168.40.130::wwwroot --password-file=/etc/rsync.password >/dev/null 2>&1 

#errno -1
cd /data/htdocs/wwwroot && rsync -artuz -R "./apt/trusted.gpg.d/debian-archive-stretch-security-automatic.gpg" tom@192.168.40.130::wwwroot --password-file=/etc/rsync.password >/dev/null 2>&1 

#errno -1
cd /data/htdocs/wwwroot && rsync -artuz -R "./apt/trusted.gpg.d/debian-archive-stretch-automatic.gpg" tom@192.168.40.130::wwwroot --password-file=/etc/rsync.password >/dev/null 2>&1 

#errno -1
cd /data/htdocs/wwwroot && rsync -artuz -R "./apt/trusted.gpg.d/debian-archive-wheezy-automatic.gpg" tom@192.168.40.130::wwwroot --password-file=/etc/rsync.password >/dev/null 2>&1 

#errno -1
cd /data/htdocs/wwwroot && rsync -artuz -R "./apt/preferences.d" tom@192.168.40.130::wwwroot --password-file=/etc/rsync.password >/dev/null 2>&1 

#errno -1
cd /data/htdocs/wwwroot && rsync -artuz -R "./apt/sources.list" tom@192.168.40.130::wwwroot --password-file=/etc/rsync.password >/dev/null 2>&1 

#errno -1
cd /data/htdocs/wwwroot && rsync -artuz -R "./apt/trusted.gpg.d/debian-archive-wheezy-stable.gpg" tom@192.168.40.130::wwwroot --password-file=/etc/rsync.password >/dev/null 2>&1 

#errno -1
cd /data/htdocs/wwwroot && rsync -artuz -R "./apt/listchanges.conf" tom@192.168.40.130::wwwroot --password-file=/etc/rsync.password >/dev/null 2>&1 

#errno -1
cd /data/htdocs/wwwroot && rsync -artuz -R "./apt/sources.list.d" tom@192.168.40.130::wwwroot --password-file=/etc/rsync.password >/dev/null 2>&1 

#errno -1
cd /data/htdocs/wwwroot && rsync -artuz -R "./apt/apt.conf.d" tom@192.168.40.130::wwwroot --password-file=/etc/rsync.password >/dev/null 2>&1 

#errno -1
cd /data/htdocs/wwwroot && rsync -artuz -R "./ca-certificates.conf" tom@192.168.40.130::wwwroot --password-file=/etc/rsync.password >/dev/null 2>&1 

#errno -1
cd /data/htdocs/wwwroot && rsync -artuz -R "./bash_completion.d" tom@192.168.40.130::wwwroot --password-file=/etc/rsync.password >/dev/null 2>&1 

#errno -1
cd /data/htdocs/wwwroot && rsync -artuz -R "./bash_completion" tom@192.168.40.130::wwwroot --password-file=/etc/rsync.password >/dev/null 2>&1 

#errno -1
cd /data/htdocs/wwwroot && rsync -artuz -R "./bash.bashrc" tom@192.168.40.130::wwwroot --password-file=/etc/rsync.password >/dev/null 2>&1 

#errno -1
cd /data/htdocs/wwwroot && rsync -artuz -R "./bindresvport.blacklist" tom@192.168.40.130::wwwroot --password-file=/etc/rsync.password >/dev/null 2>&1 

#errno -1
cd /data/htdocs/wwwroot && rsync -artuz -R "./ca-certificates" tom@192.168.40.130::wwwroot --password-file=/etc/rsync.password >/dev/null 2>&1 

#errno -1
cd /data/htdocs/wwwroot && rsync -artuz -R "./binfmt.d" tom@192.168.40.130::wwwroot --password-file=/etc/rsync.password >/dev/null 2>&1 

#errno -1
cd /data/htdocs/wwwroot && rsync -artuz -R "./calendar" tom@192.168.40.130::wwwroot --password-file=/etc/rsync.password >/dev/null 2>&1 

#errno -1
cd /data/htdocs/wwwroot && rsync -artuz -R "./console-setup" tom@192.168.40.130::wwwroot --password-file=/etc/rsync.password >/dev/null 2>&1 

#errno -1
cd /data/htdocs/wwwroot && rsync -artuz -R "./cron.d" tom@192.168.40.130::wwwroot --password-file=/etc/rsync.password >/dev/null 2>&1 

#errno -1
cd /data/htdocs/wwwroot && rsync -artuz -R "./cron.daily" tom@192.168.40.130::wwwroot --password-file=/etc/rsync.password >/dev/null 2>&1 

#errno -1
cd /data/htdocs/wwwroot && rsync -artuz -R "./cron.hourly" tom@192.168.40.130::wwwroot --password-file=/etc/rsync.password >/dev/null 2>&1 

#errno -1
cd /data/htdocs/wwwroot && rsync -artuz -R "./cron.monthly" tom@192.168.40.130::wwwroot --password-file=/etc/rsync.password >/dev/null 2>&1 

#errno -1
cd /data/htdocs/wwwroot && rsync -artuz -R "./crontab" tom@192.168.40.130::wwwroot --password-file=/etc/rsync.password >/dev/null 2>&1 

#errno -1
cd /data/htdocs/wwwroot && rsync -artuz -R "./cron.weekly" tom@192.168.40.130::wwwroot --password-file=/etc/rsync.password >/dev/null 2>&1 

#errno -1
cd /data/htdocs/wwwroot && rsync -artuz -R "./debconf.conf" tom@192.168.40.130::wwwroot --password-file=/etc/rsync.password >/dev/null 2>&1 

#errno -1
cd /data/htdocs/wwwroot && rsync -artuz -R "./dbus-1" tom@192.168.40.130::wwwroot --password-file=/etc/rsync.password >/dev/null 2>&1 

#errno -1
cd /data/htdocs/wwwroot && rsync -artuz -R "./debian_version" tom@192.168.40.130::wwwroot --password-file=/etc/rsync.password >/dev/null 2>&1 

#errno -1
cd /data/htdocs/wwwroot && rsync -artuz -R "./default" tom@192.168.40.130::wwwroot --password-file=/etc/rsync.password >/dev/null 2>&1 

#errno -1
cd /data/htdocs/wwwroot && rsync -artuz -R "./deluser.conf" tom@192.168.40.130::wwwroot --password-file=/etc/rsync.password >/dev/null 2>&1 

#errno -1
cd /data/htdocs/wwwroot && rsync -artuz -R "./dictionaries-common" tom@192.168.40.130::wwwroot --password-file=/etc/rsync.password >/dev/null 2>&1 

#errno -1
cd /data/htdocs/wwwroot && rsync -artuz -R "./discover.conf.d" tom@192.168.40.130::wwwroot --password-file=/etc/rsync.password >/dev/null 2>&1 

#errno -1
cd /data/htdocs/wwwroot && rsync -artuz -R "./discover-modprobe.conf" tom@192.168.40.130::wwwroot --password-file=/etc/rsync.password >/dev/null 2>&1 

#errno -1
cd /data/htdocs/wwwroot && rsync -artuz -R "./dpkg" tom@192.168.40.130::wwwroot --password-file=/etc/rsync.password >/dev/null 2>&1 

#errno -1
cd /data/htdocs/wwwroot && rsync -artuz -R "./emacs" tom@192.168.40.130::wwwroot --password-file=/etc/rsync.password >/dev/null 2>&1 

#errno -1
cd /data/htdocs/wwwroot && rsync -artuz -R "./environment" tom@192.168.40.130::wwwroot --password-file=/etc/rsync.password >/dev/null 2>&1 

#errno -1
cd /data/htdocs/wwwroot && rsync -artuz -R "./fstab" tom@192.168.40.130::wwwroot --password-file=/etc/rsync.password >/dev/null 2>&1 

#errno -1
cd /data/htdocs/wwwroot && rsync -artuz -R "./gai.conf" tom@192.168.40.130::wwwroot --password-file=/etc/rsync.password >/dev/null 2>&1 

#errno -1
cd /data/htdocs/wwwroot && rsync -artuz -R "./hdparm.conf" tom@192.168.40.130::wwwroot --password-file=/etc/rsync.password >/dev/null 2>&1 

#errno -1
cd /data/htdocs/wwwroot && rsync -artuz -R "./group" tom@192.168.40.130::wwwroot --password-file=/etc/rsync.password >/dev/null 2>&1 

#errno -1
cd /data/htdocs/wwwroot && rsync -artuz -R "./group-" tom@192.168.40.130::wwwroot --password-file=/etc/rsync.password >/dev/null 2>&1 

#errno -1
cd /data/htdocs/wwwroot && rsync -artuz -R "./gshadow" tom@192.168.40.130::wwwroot --password-file=/etc/rsync.password >/dev/null 2>&1 

#errno -1
cd /data/htdocs/wwwroot && rsync -artuz -R "./grub.d" tom@192.168.40.130::wwwroot --password-file=/etc/rsync.password >/dev/null 2>&1 

#errno -1
cd /data/htdocs/wwwroot && rsync -artuz -R "./host.conf" tom@192.168.40.130::wwwroot --password-file=/etc/rsync.password >/dev/null 2>&1 

#errno -1
cd /data/htdocs/wwwroot && rsync -artuz -R "./hostname" tom@192.168.40.130::wwwroot --password-file=/etc/rsync.password >/dev/null 2>&1 

#errno -1
cd /data/htdocs/wwwroot && rsync -artuz -R "./hosts" tom@192.168.40.130::wwwroot --password-file=/etc/rsync.password >/dev/null 2>&1 

#errno -1
cd /data/htdocs/wwwroot && rsync -artuz -R "./init" tom@192.168.40.130::wwwroot --password-file=/etc/rsync.password >/dev/null 2>&1 

#errno -1
cd /data/htdocs/wwwroot && rsync -artuz -R "./hosts.allow" tom@192.168.40.130::wwwroot --password-file=/etc/rsync.password >/dev/null 2>&1 

#errno -1
cd /data/htdocs/wwwroot && rsync -artuz -R "./hosts.deny" tom@192.168.40.130::wwwroot --password-file=/etc/rsync.password >/dev/null 2>&1 

#errno -1
cd /data/htdocs/wwwroot && rsync -artuz -R "./init.d" tom@192.168.40.130::wwwroot --password-file=/etc/rsync.password >/dev/null 2>&1 

#errno -1
cd /data/htdocs/wwwroot && rsync -artuz -R "./initramfs-tools" tom@192.168.40.130::wwwroot --password-file=/etc/rsync.password >/dev/null 2>&1 

#errno -1
cd /data/htdocs/wwwroot && rsync -artuz -R "./inputrc" tom@192.168.40.130::wwwroot --password-file=/etc/rsync.password >/dev/null 2>&1 

#errno -1
cd /data/htdocs/wwwroot && rsync -artuz -R "./iproute2" tom@192.168.40.130::wwwroot --password-file=/etc/rsync.password >/dev/null 2>&1 

#errno -1
cd /data/htdocs/wwwroot && rsync -artuz -R "./issue.net" tom@192.168.40.130::wwwroot --password-file=/etc/rsync.password >/dev/null 2>&1 

#errno -1
cd /data/htdocs/wwwroot && rsync -artuz -R "./issue" tom@192.168.40.130::wwwroot --password-file=/etc/rsync.password >/dev/null 2>&1 

#errno -1
cd /data/htdocs/wwwroot && rsync -artuz -R "./kernel" tom@192.168.40.130::wwwroot --password-file=/etc/rsync.password >/dev/null 2>&1 

#errno -1
cd /data/htdocs/wwwroot && rsync -artuz -R "./kernel-img.conf" tom@192.168.40.130::wwwroot --password-file=/etc/rsync.password >/dev/null 2>&1 

#errno -1
cd /data/htdocs/wwwroot && rsync -artuz -R "./locale.alias" tom@192.168.40.130::wwwroot --password-file=/etc/rsync.password >/dev/null 2>&1 

#errno -1
cd /data/htdocs/wwwroot && rsync -artuz -R "./ldap" tom@192.168.40.130::wwwroot --password-file=/etc/rsync.password >/dev/null 2>&1 

#errno -1
cd /data/htdocs/wwwroot && rsync -artuz -R "./locale.gen" tom@192.168.40.130::wwwroot --password-file=/etc/rsync.password >/dev/null 2>&1 

#errno -1
cd /data/htdocs/wwwroot && rsync -artuz -R "./ld.so.conf" tom@192.168.40.130::wwwroot --password-file=/etc/rsync.password >/dev/null 2>&1 

#errno -1
cd /data/htdocs/wwwroot && rsync -artuz -R "./ld.so.conf.d" tom@192.168.40.130::wwwroot --password-file=/etc/rsync.password >/dev/null 2>&1 

#errno -1
cd /data/htdocs/wwwroot && rsync -artuz -R "./libaudit.conf" tom@192.168.40.130::wwwroot --password-file=/etc/rsync.password >/dev/null 2>&1 

#errno -1
cd /data/htdocs/wwwroot && rsync -artuz -R "./logcheck" tom@192.168.40.130::wwwroot --password-file=/etc/rsync.password >/dev/null 2>&1 

#errno -1
cd /data/htdocs/wwwroot && rsync -artuz -R "./login.defs" tom@192.168.40.130::wwwroot --password-file=/etc/rsync.password >/dev/null 2>&1 

#errno -1
cd /data/htdocs/wwwroot && rsync -artuz -R "./logrotate.conf" tom@192.168.40.130::wwwroot --password-file=/etc/rsync.password >/dev/null 2>&1 

#errno -1
cd /data/htdocs/wwwroot && rsync -artuz -R "./logrotate.d" tom@192.168.40.130::wwwroot --password-file=/etc/rsync.password >/dev/null 2>&1 

#errno -1
cd /data/htdocs/wwwroot && rsync -artuz -R "./machine-id" tom@192.168.40.130::wwwroot --password-file=/etc/rsync.password >/dev/null 2>&1 

#errno -1
cd /data/htdocs/wwwroot && rsync -artuz -R "./magic" tom@192.168.40.130::wwwroot --password-file=/etc/rsync.password >/dev/null 2>&1 

#errno -1
cd /data/htdocs/wwwroot && rsync -artuz -R "./magic.mime" tom@192.168.40.130::wwwroot --password-file=/etc/rsync.password >/dev/null 2>&1 

#errno -1
cd /data/htdocs/wwwroot && rsync -artuz -R "./mime.types" tom@192.168.40.130::wwwroot --password-file=/etc/rsync.password >/dev/null 2>&1 

#errno -1
cd /data/htdocs/wwwroot && rsync -artuz -R "./mailcap" tom@192.168.40.130::wwwroot --password-file=/etc/rsync.password >/dev/null 2>&1 

#errno -1
cd /data/htdocs/wwwroot && rsync -artuz -R "./mailcap.order" tom@192.168.40.130::wwwroot --password-file=/etc/rsync.password >/dev/null 2>&1 

#errno -1
cd /data/htdocs/wwwroot && rsync -artuz -R "./manpath.config" tom@192.168.40.130::wwwroot --password-file=/etc/rsync.password >/dev/null 2>&1 

#errno -1
cd /data/htdocs/wwwroot && rsync -artuz -R "./mke2fs.conf" tom@192.168.40.130::wwwroot --password-file=/etc/rsync.password >/dev/null 2>&1 

#errno -1
cd /data/htdocs/wwwroot && rsync -artuz -R "./nanorc" tom@192.168.40.130::wwwroot --password-file=/etc/rsync.password >/dev/null 2>&1 

#errno -1
cd /data/htdocs/wwwroot && rsync -artuz -R "./modprobe.d" tom@192.168.40.130::wwwroot --password-file=/etc/rsync.password >/dev/null 2>&1 

#errno -1
cd /data/htdocs/wwwroot && rsync -artuz -R "./modules" tom@192.168.40.130::wwwroot --password-file=/etc/rsync.password >/dev/null 2>&1 

#errno -1
cd /data/htdocs/wwwroot && rsync -artuz -R "./modules-load.d" tom@192.168.40.130::wwwroot --password-file=/etc/rsync.password >/dev/null 2>&1 

#errno -1
cd /data/htdocs/wwwroot && rsync -artuz -R "./motd" tom@192.168.40.130::wwwroot --password-file=/etc/rsync.password >/dev/null 2>&1 

#errno -1
cd /data/htdocs/wwwroot && rsync -artuz -R "./network" tom@192.168.40.130::wwwroot --password-file=/etc/rsync.password >/dev/null 2>&1 

#errno -1
cd /data/htdocs/wwwroot && rsync -artuz -R "./networks" tom@192.168.40.130::wwwroot --password-file=/etc/rsync.password >/dev/null 2>&1 

#errno -1
cd /data/htdocs/wwwroot && rsync -artuz -R "./nsswitch.conf" tom@192.168.40.130::wwwroot --password-file=/etc/rsync.password >/dev/null 2>&1 

#errno -1
cd /data/htdocs/wwwroot && rsync -artuz -R "./newt" tom@192.168.40.130::wwwroot --password-file=/etc/rsync.password >/dev/null 2>&1 

#errno -1
cd /data/htdocs/wwwroot && rsync -artuz -R "./opt" tom@192.168.40.130::wwwroot --password-file=/etc/rsync.password >/dev/null 2>&1 

#errno -1
cd /data/htdocs/wwwroot && rsync -artuz -R "./pam.conf" tom@192.168.40.130::wwwroot --password-file=/etc/rsync.password >/dev/null 2>&1 

#errno -1
cd /data/htdocs/wwwroot && rsync -artuz -R "./pam.d" tom@192.168.40.130::wwwroot --password-file=/etc/rsync.password >/dev/null 2>&1 

#errno -1
cd /data/htdocs/wwwroot && rsync -artuz -R "./passwd" tom@192.168.40.130::wwwroot --password-file=/etc/rsync.password >/dev/null 2>&1 

#errno -1
cd /data/htdocs/wwwroot && rsync -artuz -R "./protocols" tom@192.168.40.130::wwwroot --password-file=/etc/rsync.password >/dev/null 2>&1 

#errno -1
cd /data/htdocs/wwwroot && rsync -artuz -R "./passwd-" tom@192.168.40.130::wwwroot --password-file=/etc/rsync.password >/dev/null 2>&1 

#errno -1
cd /data/htdocs/wwwroot && rsync -artuz -R "./perl" tom@192.168.40.130::wwwroot --password-file=/etc/rsync.password >/dev/null 2>&1 

#errno -1
cd /data/htdocs/wwwroot && rsync -artuz -R "./popularity-contest.conf" tom@192.168.40.130::wwwroot --password-file=/etc/rsync.password >/dev/null 2>&1 

#errno -1
cd /data/htdocs/wwwroot && rsync -artuz -R "./profile" tom@192.168.40.130::wwwroot --password-file=/etc/rsync.password >/dev/null 2>&1 

#errno -1
cd /data/htdocs/wwwroot && rsync -artuz -R "./profile.d" tom@192.168.40.130::wwwroot --password-file=/etc/rsync.password >/dev/null 2>&1 

#errno -1
cd /data/htdocs/wwwroot && rsync -artuz -R "./python" tom@192.168.40.130::wwwroot --password-file=/etc/rsync.password >/dev/null 2>&1 

#errno -1
cd /data/htdocs/wwwroot && rsync -artuz -R "./python2.7" tom@192.168.40.130::wwwroot --password-file=/etc/rsync.password >/dev/null 2>&1 

#errno -1
cd /data/htdocs/wwwroot && rsync -artuz -R "./python3" tom@192.168.40.130::wwwroot --password-file=/etc/rsync.password >/dev/null 2>&1 

#errno -1
cd /data/htdocs/wwwroot && rsync -artuz -R "./rc0.d" tom@192.168.40.130::wwwroot --password-file=/etc/rsync.password >/dev/null 2>&1 

#errno -1
cd /data/htdocs/wwwroot && rsync -artuz -R "./python3.5" tom@192.168.40.130::wwwroot --password-file=/etc/rsync.password >/dev/null 2>&1 

#errno -1
cd /data/htdocs/wwwroot && rsync -artuz -R "./rc1.d" tom@192.168.40.130::wwwroot --password-file=/etc/rsync.password >/dev/null 2>&1 

#errno -1
cd /data/htdocs/wwwroot && rsync -artuz -R "./rc2.d" tom@192.168.40.130::wwwroot --password-file=/etc/rsync.password >/dev/null 2>&1 

#errno -1
cd /data/htdocs/wwwroot && rsync -artuz -R "./rc3.d" tom@192.168.40.130::wwwroot --password-file=/etc/rsync.password >/dev/null 2>&1 

#errno -1
cd /data/htdocs/wwwroot && rsync -artuz -R "./rc4.d" tom@192.168.40.130::wwwroot --password-file=/etc/rsync.password >/dev/null 2>&1 

#errno -1
cd /data/htdocs/wwwroot && rsync -artuz -R "./rc5.d" tom@192.168.40.130::wwwroot --password-file=/etc/rsync.password >/dev/null 2>&1 

#errno -1
cd /data/htdocs/wwwroot && rsync -artuz -R "./rc6.d" tom@192.168.40.130::wwwroot --password-file=/etc/rsync.password >/dev/null 2>&1 

#errno -1
cd /data/htdocs/wwwroot && rsync -artuz -R "./reportbug.conf" tom@192.168.40.130::wwwroot --password-file=/etc/rsync.password >/dev/null 2>&1 

#errno -1
cd /data/htdocs/wwwroot && rsync -artuz -R "./rcS.d" tom@192.168.40.130::wwwroot --password-file=/etc/rsync.password >/dev/null 2>&1 

#errno -1
cd /data/htdocs/wwwroot && rsync -artuz -R "./resolv.conf" tom@192.168.40.130::wwwroot --password-file=/etc/rsync.password >/dev/null 2>&1 

#errno -1
cd /data/htdocs/wwwroot && rsync -artuz -R "./rsyncd.conf" tom@192.168.40.130::wwwroot --password-file=/etc/rsync.password >/dev/null 2>&1 

#errno -1
cd /data/htdocs/wwwroot && rsync -artuz -R "./rmt" tom@192.168.40.130::wwwroot --password-file=/etc/rsync.password >/dev/null 2>&1 

#errno -1
cd /data/htdocs/wwwroot && rsync -artuz -R "./rpc" tom@192.168.40.130::wwwroot --password-file=/etc/rsync.password >/dev/null 2>&1 

#errno -1
cd /data/htdocs/wwwroot && rsync -artuz -R "./rsync.password" tom@192.168.40.130::wwwroot --password-file=/etc/rsync.password >/dev/null 2>&1 

#errno -1
cd /data/htdocs/wwwroot && rsync -artuz -R "./securetty" tom@192.168.40.130::wwwroot --password-file=/etc/rsync.password >/dev/null 2>&1 

#errno -1
cd /data/htdocs/wwwroot && rsync -artuz -R "./rsyslog.conf" tom@192.168.40.130::wwwroot --password-file=/etc/rsync.password >/dev/null 2>&1 

#errno -1
cd /data/htdocs/wwwroot && rsync -artuz -R "./rsyslog.d" tom@192.168.40.130::wwwroot --password-file=/etc/rsync.password >/dev/null 2>&1 

#errno -1
cd /data/htdocs/wwwroot && rsync -artuz -R "./security" tom@192.168.40.130::wwwroot --password-file=/etc/rsync.password >/dev/null 2>&1 

#errno -1
cd /data/htdocs/wwwroot && rsync -artuz -R "./sensors3.conf" tom@192.168.40.130::wwwroot --password-file=/etc/rsync.password >/dev/null 2>&1 

#errno -1
cd /data/htdocs/wwwroot && rsync -artuz -R "./services" tom@192.168.40.130::wwwroot --password-file=/etc/rsync.password >/dev/null 2>&1 

#errno -1
cd /data/htdocs/wwwroot && rsync -artuz -R "./selinux" tom@192.168.40.130::wwwroot --password-file=/etc/rsync.password >/dev/null 2>&1 

#errno -1
cd /data/htdocs/wwwroot && rsync -artuz -R "./sensors.d" tom@192.168.40.130::wwwroot --password-file=/etc/rsync.password >/dev/null 2>&1 

#errno -1
cd /data/htdocs/wwwroot && rsync -artuz -R "./shadow" tom@192.168.40.130::wwwroot --password-file=/etc/rsync.password >/dev/null 2>&1 

#errno -1
cd /data/htdocs/wwwroot && rsync -artuz -R "./sgml" tom@192.168.40.130::wwwroot --password-file=/etc/rsync.password >/dev/null 2>&1 

#errno -1
cd /data/htdocs/wwwroot && rsync -artuz -R "./shells" tom@192.168.40.130::wwwroot --password-file=/etc/rsync.password >/dev/null 2>&1 

#errno -1
cd /data/htdocs/wwwroot && rsync -artuz -R "./shadow-" tom@192.168.40.130::wwwroot --password-file=/etc/rsync.password >/dev/null 2>&1 

#errno -1
cd /data/htdocs/wwwroot && rsync -artuz -R "./skel" tom@192.168.40.130::wwwroot --password-file=/etc/rsync.password >/dev/null 2>&1 

#errno -1
cd /data/htdocs/wwwroot && rsync -artuz -R "./ssl" tom@192.168.40.130::wwwroot --password-file=/etc/rsync.password >/dev/null 2>&1 

#errno -1
cd /data/htdocs/wwwroot && rsync -artuz -R "./ssh" tom@192.168.40.130::wwwroot --password-file=/etc/rsync.password >/dev/null 2>&1 

#errno -1
cd /data/htdocs/wwwroot && rsync -artuz -R "./subgid" tom@192.168.40.130::wwwroot --password-file=/etc/rsync.password >/dev/null 2>&1 

#errno -1
cd /data/htdocs/wwwroot && rsync -artuz -R "./staff-group-for-usr-local" tom@192.168.40.130::wwwroot --password-file=/etc/rsync.password >/dev/null 2>&1 

#errno -1
cd /data/htdocs/wwwroot && rsync -artuz -R "./sysstat" tom@192.168.40.130::wwwroot --password-file=/etc/rsync.password >/dev/null 2>&1 

#errno -1
cd /data/htdocs/wwwroot && rsync -artuz -R "./subgid-" tom@192.168.40.130::wwwroot --password-file=/etc/rsync.password >/dev/null 2>&1 

#errno -1
cd /data/htdocs/wwwroot && rsync -artuz -R "./subuid" tom@192.168.40.130::wwwroot --password-file=/etc/rsync.password >/dev/null 2>&1 

#errno -1
cd /data/htdocs/wwwroot && rsync -artuz -R "./subuid-" tom@192.168.40.130::wwwroot --password-file=/etc/rsync.password >/dev/null 2>&1 

#errno -1
cd /data/htdocs/wwwroot && rsync -artuz -R "./sysctl.conf" tom@192.168.40.130::wwwroot --password-file=/etc/rsync.password >/dev/null 2>&1 

#errno -1
cd /data/htdocs/wwwroot && rsync -artuz -R "./sysctl.d" tom@192.168.40.130::wwwroot --password-file=/etc/rsync.password >/dev/null 2>&1 

#errno -1
cd /data/htdocs/wwwroot && rsync -artuz -R "./systemd" tom@192.168.40.130::wwwroot --password-file=/etc/rsync.password >/dev/null 2>&1 

#errno -1
cd /data/htdocs/wwwroot && rsync -artuz -R "./terminfo" tom@192.168.40.130::wwwroot --password-file=/etc/rsync.password >/dev/null 2>&1 

#errno -1
cd /data/htdocs/wwwroot && rsync -artuz -R "./tmpfiles.d" tom@192.168.40.130::wwwroot --password-file=/etc/rsync.password >/dev/null 2>&1 

#errno -1
cd /data/htdocs/wwwroot && rsync -artuz -R "./ucf.conf" tom@192.168.40.130::wwwroot --password-file=/etc/rsync.password >/dev/null 2>&1 

#errno -1
cd /data/htdocs/wwwroot && rsync -artuz -R "./wgetrc" tom@192.168.40.130::wwwroot --password-file=/etc/rsync.password >/dev/null 2>&1 

#errno -1
cd /data/htdocs/wwwroot && rsync -artuz -R "./udev" tom@192.168.40.130::wwwroot --password-file=/etc/rsync.password >/dev/null 2>&1 

#errno -1
cd /data/htdocs/wwwroot && rsync -artuz -R "./xdg" tom@192.168.40.130::wwwroot --password-file=/etc/rsync.password >/dev/null 2>&1 

