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

sql = """
CREATE TABLE openclient_userinfo (
  id INTEGER PRIMARY KEY NOT NULL,
  username VARCHAR(150) not null,
  password VARCHAR(150) not null,
  is_crled int not null default 0,
  timestamp integer not null,
  datetime text not null,
  uptime text not null
);
"""

logger = logging.getLogger(__file__)
logger.setLevel(logging.INFO)

#ca_dir = os.path.dirname(os.path.abspath(__file__))
ca_dir = '/etc/openvpn/easy-rsa/easyrsa3'
ca_passwd = '*43d5^&3d8^57573!6%4'
openvpn_crl_dir = '/etc/openvpn'

conn = sqlite3.connect('openclient.db')
os.chdir(ca_dir)

def zip_file(username, passwd):
  os.mkdir('./tmp/%s' %username)
  shutil.copy('./pki/private/%s.key' %username, './tmp/%s/' %username)
  shutil.copy('./pki/issued/%s.crt' %username, './tmp/%s/' %username)
  shutil.copy('./pki/ca.crt', './tmp/%s/' %username)
  with open('./tmp/%s/passwd.txt' %username, 'wt') as fd:
    fd.write(passwd)
  client_ovpn = """
client
dev tun
proto tcp
remote 109 9411 #OpenVPN服务器的公网IP
resolv-retry infinite
nobind
persist-key
persist-tun
ca ca.crt
cert %s.crt
key  %s.key
comp-lzo
verb 3
  """ %(username, username)
  with open('./tmp/%s/client.ovpn' %username, 'wt') as fd:
    fd.write(client_ovpn)
  zipname = username.split('@')[0]
  f = zipfile.ZipFile('./tmp/%s.zip' %zipname, 'w', zipfile.ZIP_DEFLATED)
  for files in os.listdir('./tmp/%s/' %username):
    f.write(os.path.join('./tmp/%s/' %username, files))
  f.close()
  shutil.rmtree('./tmp/%s' %username)

 #  if username.endswith('ju.com'):
 #   code = send_mail(username, './tmp/%s.zip' %zipname)
#    if code:
#      os.remove('./tmp/%s.zip' %zipname)


def openclient_create(username):
  cursor = conn.execute("""select count(1) from openclient_userinfo where username='%s'""" %username)
  count = cursor.fetchone()[0]
  logger.info("Get Count %s" %count)
  if not count:
    passwd_client = "%s_%s" %(username.split('@')[0], ''.join(random.choice(string.ascii_uppercase + string.digits) for x in range(16)))
    logger.info("User: %s Password: %s" %(username, passwd_client))
    print "User: %s Password: %s" %(username, passwd_client)
    """
    ./easyrsa gen-req 30_client_01
    创建客户端认证密码Enter PEM pass phrase:
    确认客户端认证密码Verifying - Enter PEM pass phrase:
    Common Name (eg: your user, host, or server name) [30_client_01]:30_client_01
    """
    #gen_req = pexpect.spawn("./easyrsa gen-req %s nopass" %username)
    gen_req = pexpect.spawn("./easyrsa gen-req %s" %username)
    try:
      gen_req.expect("Enter PEM pass phrase:")
      gen_req.sendline("%s" %passwd_client)
      print '1'
      gen_req.expect("Enter PEM pass phrase:")
      gen_req.sendline("%s" %passwd_client)
      print '2'

      gen_req.expect("%s]:" %username)
      gen_req.sendline("%s" %username)
      print '3'
      logger.info("Openclient_create First Step Gen_Req OK")
    except Exception, e:
      logger.error("Openclient_create First Step Gen_Req Error %s" %e, exc_info=True)
      gen_req.close()
    else:
      gen_req.expect(pexpect.EOF)
      gen_req.close()

    """
    ./easyrsa sign client 30_client_01
    确认Confirm request details: yes
    输入ca密码Enter pass phrase for /etc/openvpn/easy-rsa/easyrsa3/pki/private/ca.key:
    """
    sign = pexpect.spawn("./easyrsa sign client %s" %username)
    try:
      sign.expect("Confirm request details:")
      sign.sendline("yes")

      sign.expect("Enter pass phrase for .*.key:")
      sign.sendline("%s" %ca_passwd)
      logger.info("Openclient_create Second Step Sign OK")
    except Exception, e:
      logger.error("Openclient_create Second Step Sign Error %s" %e, exc_info=True)
      sign.close()
    else:
      sign.expect(pexpect.EOF)
      sign.close()

    dtime = datetime.datetime.now().strftime("%F %T")
    sql = """insert into openclient_userinfo
      (username, password, timestamp, datetime, uptime)
      values
      ('%s', '%s', '%s', '%s', '%s')""" %(username, passwd_client, int(time.time()), dtime, dtime)
    logger.info("Insert SQL: %s" %sql)
    cursor = conn.execute(sql)
    conn.commit()
    cursor.close()
    zip_file(username, passwd_client)

def crl_update(username):
  shutil.copy(os.path.join(ca_dir, 'pki/crl.pem'), openvpn_crl_dir)
  os.remove('./pki/private/%s.key' %username)
  os.remove('./pki/issued/%s.crt' %username)
  os.remove('./pki/reqs/%s.req' %username)
  os.remove('./tmp/%s.zip' %username.split('@')[0])

def openclient_revoke(username):
  cursor = conn.execute("""select count(1) from openclient_userinfo where username='%s'""" %username)
  is_crled = cursor.fetchone()[0]
  if is_crled:
    revoke = pexpect.spawn("./easyrsa revoke %s" %username)
    try:
      revoke.expect("Continue with revocation:")
      revoke.sendline("yes")

      revoke.expect("Enter pass phrase for .*.key:")
      revoke.sendline("%s" %ca_passwd)
    except Exception, e:
      logger.error("openclient_revoke First Step revoke Error %s" %e, exc_info=True)
      revoke.close()
    else:
      revoke.expect(pexpect.EOF)
      revoke.close()

    gen_crl = pexpect.spawn("./easyrsa gen-crl")
    try:
      gen_crl.expect("Enter pass phrase for .*.key:")
      gen_crl.sendline("%s" %ca_passwd)
    except Exception, e:
      logger.error("openclient_revoke second Step gen_crl Error %s" %e, exc_info=True)
      gen_crl.close()
    else:
      gen_crl.expect(pexpect.EOF)
      gen_crl.close()

#    dtime = datetime.datetime.now().strftime("%F %T")
#    sql = """update p12_userinfo set is_crled = 1, uptime = '%s'
#      where
#      username = '%s'""" %(dtime, username)
    sql = """delete from openclient_userinfo where username='%s'""" %username
    logger.info("Delete SQL: %s" %sql)
    cursor = conn.execute(sql)
    conn.commit()
    cursor.close()

    crl_update(username)


if __name__ == '__main__':
  parser = argparse.ArgumentParser(prog='OPENVPN',
    description="Openvpn Create",
    epilog="Openvpn",
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
    openclient_create(cname)
  if rname:
    openclient_revoke(rname)
