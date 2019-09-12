#!/bin/bash
Logfile='/data/logs/zabbix/Email.log'
:>${Logfile}
exec 1> ${Logfile}
exec 2>&1


SMTP_Server='smtp.163.com'
User_Name='ixx@163.com'
Passwd='paswd'

From_Email_Address='ixx@163.com'
To_Email_Address="$1"

Message_Subject_UTF8="$2"
Message_Body_UTF8="$3"

Message_Subject_GB2312=`iconv -t GB2312 -f UTF-8 << EOF
${Message_Subject_UTF8}
EOF`

[ $? -eq 0 ] && Message_Subject=${Message_Subject_GB2312} || Message_Subject=${Message_Subject_UTF8}

Message_Body_GB2312=`iconv -t GB2312 -f UTF-8 << EOF
${Message_Body_UTF8}
EOF`

[ $? -eq 0 ] && Message_Body=${Message_Body_GB2312} || Message_Body=${Message_Body_UTF8}

sendEmail=/usr/local/bin/sendEmail

${sendEmail} -s ${SMTP_Server} -xu ${User_Name} -xp ${Passwd} -f ${From_Email_Address} -t ${To_Email_Address} -u ${Message_Subject} -m ${Message_Body} -o message-content-type=text -o message-charset=gb2312
