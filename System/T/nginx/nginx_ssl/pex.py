#encoding:utf-8
import pexpect
import os
import sys
import time
import string
import random
import shutil
import sqlite3
import datetime
import argparse
import subprocess
import zipfile
from log import logging
from email.header import Header
from email.mime.text import MIMEText
from email.mime.multipart import MIMEMultipart
import smtplib

logger = logging.getLogger(__file__)
logger.setLevel(logging.INFO)

#ca_dir = os.path.dirname(os.path.abspath(__file__))
ca_dir = '/usr/local/ca/easyrsa3'
ca_passwd = '5='
nginx_crl_dir = '/etc/nginx/ssl/crl/'
nginx_path = '/usr/sbin/nginx'

conn = sqlite3.connect('nginx_ssl.db')
os.chdir(ca_dir)

def send_mail(username, zipfile):

  MAIL_HOST = 'smtp.ju.com'
  MAIL_USER = 'z@ju.com'
  MAIL_PASSWD = 'ju@123'

  #Multipart
  msg = MIMEMultipart('mixed')
  msg['From'] = '%s <%s>' %(MAIL_USER, MAIL_USER)
  msg['To'] = Header(u'%s' %username, 'utf-8').encode()
  msg['Subject'] = Header(u'Ju', 'utf-8').encode()

  #Content 
  content = u'这是一封后台配置使用说明邮件，使用细节在邮件附件中. \r\n 请参照压缩文件中帮助文档 README.pdf的说明使用 \r\n 本邮件为自动发送，如有任何疑问请回复邮件.\r\n 谢谢！'
  c_part = MIMEText(content, _subtype='plain', _charset='utf8')
  msg.attach(c_part)

  #构造附件1
  att1 = MIMEText(open(zipfile, 'rb').read(), _subtype='base64', _charset='utf8')
  att1["Content-Type"] = 'application/octet-stream'
  att1["Content-Disposition"] = 'attachment; filename="%s.zip"' %username.split('@')[0] #这里的filename可以任意写，写什么名字，邮件中显示什么名字
  msg.attach(att1)
  

  #send mail
  try:
    server = smtplib.SMTP()
    server.connect(MAIL_HOST, '25')
#    server.starttls()
#    server.set_debuglevel(1)
    server.login(MAIL_USER, MAIL_PASSWD)
    server.sendmail(MAIL_USER, username, msg.as_string())
    server.quit()
    return True
  except Exception, e:
    logger.error("Exception: %s" %e, exc_info=True)
    return False


def zip_file(username, passwd):
  os.mkdir('./tmp/%s' %username)
  shutil.copy('./pki/private/%s.p12' %username, './tmp/%s/' %username)
  shutil.copy('./pki/ca.crt', './tmp/%s/' %username)
  shutil.copy('./tmp/README.pdf', './tmp/%s/' %username)
  with open('./tmp/%s/passwd.txt' %username, 'wt') as fd:
    fd.write(passwd)
  zipname = username.split('@')[0]
  f = zipfile.ZipFile('./tmp/%s.zip' %zipname, 'w', zipfile.ZIP_DEFLATED)
  for files in os.listdir('./tmp/%s/' %username):
    f.write(os.path.join('./tmp/%s/' %username, files))
  f.close()
  shutil.rmtree('./tmp/%s' %username)

  if username.endswith('ju.com'):
    code = send_mail(username, './tmp/%s.zip' %zipname)
#    if code:
#      os.remove('./tmp/%s.zip' %zipname)
    
def p12_create(username):
  cursor = conn.execute("""select count(1) from p12_userinfo where username='%s'""" %username)
  count = cursor.fetchone()[0]
  logger.info("Get Count %s" %count)
  if not count:
    gen_req = pexpect.spawn("./easyrsa gen-req %s nopass" %username)
    try:
      gen_req.expect("[%s]:" %username)
      gen_req.sendline("%s" %username)
    except Exception, e:
      logger.error("P12_create First Step Gen_Req Error %s" %e, exc_info=True)
      gen_req.close()
    else:
      gen_req.expect(pexpect.EOF)
      gen_req.close()
 
    sign = pexpect.spawn("./easyrsa sign client %s" %username)
    try:
      sign.expect("Confirm request details:")
      sign.sendline("yes")

      sign.expect("Enter pass phrase for .*.key:")
      sign.sendline("%s" %ca_passwd)
    except Exception, e:
      logger.error("P12_create Second Step Sign Error %s" %e, exc_info=True)
      sign.close()
    else:
      sign.expect(pexpect.EOF)
      sign.close()

    ex_p12 = pexpect.spawn("./easyrsa export-p12 %s" %username)
    passwd_p12 = "%s_%s" %(username.split('@')[0], ''.join(random.choice(string.ascii_uppercase + string.digits) for x in range(16)))
    logger.info("User: %s Password: %s" %(username, passwd_p12))
    try:
      ex_p12.expect("Enter Export Password:")
      ex_p12.sendline("%s" %passwd_p12)

      ex_p12.expect("Verifying - Enter Export Password:")
      ex_p12.sendline("%s" %passwd_p12)
    except Exception, e:
      logger.error("P12_create Third Step export P12 Error %s" %e, exc_info=True)
      ex_p12.close()
    else:
      ex_p12.expect(pexpect.EOF)
      ex_p12.close()

    dtime = datetime.datetime.now().strftime("%F %T")
    sql = """insert into p12_userinfo 
      (username, password, timestamp, datetime, uptime) 
      values 
      ('%s', '%s', '%s', '%s', '%s')""" %(username, passwd_p12, int(time.time()), dtime, dtime)
    logger.info("Insert SQL: %s" %sql)
    cursor = conn.execute(sql)
    conn.commit()
    cursor.close()
    zip_file(username, passwd_p12)


def nginx_update(username):
  shutil.copy(os.path.join(ca_dir, 'pki/crl.pem'), nginx_crl_dir)
  subprocess.Popen('%s -s reload' %nginx_path, shell=True, stdout=subprocess.PIPE, stderr=subprocess.STDOUT)
  os.remove('./pki/private/%s.p12' %username)
  os.remove('./pki/private/%s.key' %username)
  os.remove('./pki/issued/%s.crt' %username)
  os.remove('./tmp/%s.zip' %username.split('@')[0])

def p12_revoke(username):
  cursor = conn.execute("""select count(1) from p12_userinfo where username='%s'""" %username)
  is_crled = cursor.fetchone()[0]
  if is_crled:
    revoke = pexpect.spawn("./easyrsa revoke %s" %username)
    try:
      revoke.expect("Continue with revocation:")
      revoke.sendline("yes")

      revoke.expect("Enter pass phrase for .*.key:")
      revoke.sendline("%s" %ca_passwd)
    except Exception, e:
      logger.error("P12_revoke First Step revoke Error %s" %e, exc_info=True)
      revoke.close()
    else:
      revoke.expect(pexpect.EOF)
      revoke.close()

    gen_crl = pexpect.spawn("./easyrsa gen-crl")
    try:
      gen_crl.expect("Enter pass phrase for .*.key:")
      gen_crl.sendline("%s" %ca_passwd)
    except Exception, e:
      logger.error("P12_revoke second Step gen_crl Error %s" %e, exc_info=True)
      gen_crl.close()
    else:
      gen_crl.expect(pexpect.EOF)
      gen_crl.close()

#    dtime = datetime.datetime.now().strftime("%F %T")
#    sql = """update p12_userinfo set is_crled = 1, uptime = '%s' 
#      where 
#      username = '%s'""" %(dtime, username)
    sql = """delete from p12_userinfo where username='%s'""" %username
    logger.info("Delete SQL: %s" %sql)
    cursor = conn.execute(sql)
    conn.commit()
    cursor.close()
 
    nginx_update(username)


if __name__ == '__main__':
  parser = argparse.ArgumentParser(prog='NGSSL',
    description="Nginx SSL Create",
    epilog="Nginx SSL",
    formatter_class=argparse.ArgumentDefaultsHelpFormatter,
    usage='%(prog)s [options]',
  )
  parser.add_argument('-c', '--create', action='store', dest='cname', help="create user name: user@ju.com")
  parser.add_argument('-r', '--revoke', action='store', dest='rname', default=None, help="revoke user name: user@ju.com")
  parser.add_argument('--version', action='version', version='%(prog)s 1.0')
  args = parser.parse_args()

  if len(sys.argv) == 1:
    print "Usage:"
    print sys.argv[0], '-c username@example.com; Create user\'s p12 file'
    print sys.argv[0], '-r username@example.com; Revoke User\'s p12 file'
    sys.exit(1)
  else:
    cname = args.cname
    rname = args.rname

  if cname:
    p12_create(cname)
  if rname:
    p12_revoke(rname)
