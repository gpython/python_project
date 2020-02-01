#!/bin/env python
#coding:utf-8

"""
Paramenter
zabbix_mail.py Mail_To Title Content

copy the email file to /usr/local/zabbix/share/zabbix/alertscripts
Administration -> Media types -> Email Script

zabbix_server.conf change the follow options
AlertScriptsPath=/usr/local/zabbix/share/zabbix/alertscripts
"""

import smtplib
from email.mime.text import MIMEText
import time
import sys

current_time = time.strftime("%F %T", time.localtime(time.time()))

MAIL_HOST = 'smtp.163.com'
MAIL_USER = 'a@163.com'
MAIL_PASSWD = 'com'

def send_email(Mail_To, Title, Content):
  msg = MIMEText(Content, _subtype='plain', _charset='utf8')
  msg['From'] = MAIL_USER
  msg['Subject'] = Title
  msg['To'] = ','.join(Mail_To)

  try:
    server = smtplib.SMTP()
    server.connect(MAIL_HOST, '25')
    server.starttls()
    server.login(MAIL_USER, MAIL_PASSWD)
    server.sendmail(MAIL_USER, Mail_To, msg.as_string())
    server.quit()
  except Exception, e:
    print "Exception: " + str(e)


if __name__ == '__main__':
  Mail_To = ['%s' %(sys.argv[1]),]
  print Mail_To
  Title = sys.argv[2]
  Content = """
    Time: %s
    Info: %s
  """  %(current_time, sys.argv[3])

  with open('/tmp/zabbix_mail.log', 'ab') as f:
    f.write('%s Receive address: %s Title: %s \n' %(current_time, Mail_To, Title))
  send_email(Mail_To, Title, Content)
