#encoding:utf-8

创建Django工程
  django-admin startproject 工程名
创建app
  python manage.py startapp cmdb
  python manage.py startapp admin
project
  -project
    - config
  -app1
  -app2



配置模板路径
TEMPLATES = [{
  'DIRS': [os.path.join(BASE_DIR, 'templates')]
}]

配置静态目录
STATICFILES_DIRS = (
  os.path.join(BASE_DIR, 'static')
)

数据库 和redis session 配置
pip install django-redis-sessions

SESSION_ENGINE = 'redis_sessions.session'
SESSION_REDIS_HOST = '192.168.47.9'
SESSION_REDIS_PORT = 6379
SESSION_REDIS_DB = 0
SESSION_REDIS_PASSWORD = ''
SESSION_REDIS_PREFIX = 'session'

DATABASES = {
    'default': {
        'ENGINE': 'django.db.backends.mysql',
        'NAME': 't2',
        'USER': 'root',
        'PASSWORD':'google',
        'HOST': '192.168.47.9',
        'PORT': 3306
    }
}

#缓存
# pip install django-redis-cache
CACHES = {
  'default':{
    'BACKEND': 'redis_cache.cahce.RedisCache',
    'LOCATION': 'localhost:6379',
    'TIMEOUT': 60,
  },
}

# 分词检索
HAYSTACK_CONNECTIONS = {
  'default': {
    'ENGINE': 'haystack.backends.whoosh_cn_backend.WhooshEngine',
    'PATH': os.path.join(BASE_DIR, 'whoosh_index'),
  }
}
HAYSTACK_SIGNAL_PROCESSOR = 'haystack.signals.RealtimeSignalProcessor'

url(r'^search/', include('haystack.urls'))

#上传文件目录
MEDIA_ROOT = os.path.join(BASE_DIR, 'static')

#富文本编辑器
TINYMCE_DEFAULT_CONFIG = {
  'theme': 'advanced',
  'width': 600,
  'height': 400,
}




#################################
url(r'^tinymce/', include('tinymce.urls'))

#url配置 namespace 反向解析
urlpaterns = [
  url(r'^admin/', include(admin.site.urls)),
  url(r'^books/', include('books.urls'), namespace='books'),
]

urlpatterns = [
  url(r'^$', views.index, name='index'),
  url(r'(\d+)$', views.show, name='show'),
]

运行django功能
python manage.py runserver 127.0.0.1:8080

<link rel='stylesheet' href='/static/commons.css' />

request 用户提交的所有信息
request.GET.get('args', None)
request.POST.get('args', None)
request.FILES
request.getlist
request.method
request.path_info
request.POST.getlist('args')    checkbox时可以使用

#url => http://x.x.x.x:80/index/?t=100&x=100
request.path  => 当前路径 /index
request.get_full_path() =>完整路径 /index/?t=100&x=100

request.body
  request.POST(request.body)
  request.FILES(request.body)
  request.GET
  request.xx.getlist()

request.method(POST, GET, PUT)
request.path_info
request.COOKIES


上传文件 form标签特殊设置 enctype="multipart/form-data"
obj = request.FILES.get('args')
obj.name
f = open(obj.name, mode='wb')
for item in obj.trunks():
  f.write(item)
f.close()


from django.views import View
class Home(View):
  def get(self, request):
    pass
  def post(self, request):
    pass

URL正则表达式分组
url(r'^detail-(?P<nid>\d+)-(?P<uid>\d+).html', views.detail)
def detail(request, nid, uid):
  pass
def detail(request, uid, nid):
  pass

def func(*args):
  #(1,2,3,4,5,6)
  print args

def func(**kwargs):
  #(k1=1, k2=2, k3=3, k4=4)
  print kwargs

url(r'detail-(\d+)-(\d+).html', views.detail),
def func(request, nid, uid):
  pass
def func(request, *args):
  args = (2,9)
def func(requestm *args, **kwargs):
  args = (2,9)
  kwargs = None

url(r'^detail-(?P<nid>\d+)-(?P<uid>\d+).html', views.detail)
def func(request, nid, uid):
  pass

def func(request, **kwargs):
  kwargs = {'nid':1, 'uid':3}

def func(requestm *args, **kwargs):
  kwargs = {'nid':1, 'uid':3}
  args = None

url(r'^index/', views.index, name='index')
模板中 {% url 'index' %} 相当于flask的url_for
request.path_info 当前url路径
url(r'^index/(\d+)/(\d+)', views.index, name='index')
模板中 {% url 'index' 10 20 %}
url(r'^index/(?P<nid>\d+)/(?P<uid>\d+)', views.index, name='index')
模板中 {% url 'index' nid=10 uid=90 %}


from django.urls import reverse
url(r'^index/(\d+)/(\d+)', views.index, name='index')
v = reverse('index', args=(90,))   =

url(r'^index/(?P<nid>\d+)/(?P<uid>\d+)', views.index, name='index')
v = reverse('index', kwargs={'nid':10, 'uid':90})

print v

创建Models类
from django.db import models
class UserInfo(models.Model):
  username = models.CharField(max_length=32)
  password = models.CharField(max_length=64)

settings
  installed_app
    'app_name'

python manage.py makemigrations
python manage.py migrate

Django默认使用MySQLdb模块连接MySQL
主动修改为pymysql 在project同名文件夹下__init__文件中添加如下代码即可
import pymysql
pymysql.install_as_MySQLdb()

models 文件

dic = {'username': 'eric', 'password': '6666'}
models.UserInfo.objects.create(**dic)
models.UserInfo.objects.create(username='goole', password='sfsdf')

obj = models.UserInfo(username='google', password='sfdsa')
obj.save()

查询
r = models.UserInfo.objects.all()

删除
models.UserInfo.objects.filter(username='sdfs').delete()

更新
models.UserInfo.objects.filter(id=3).update(password='sfsfsf')

obj = models.UserInfo.objects.filter(username='sfs', password='sdfs').first()
obj = models.UserInfo.objects.filter(username='sdf', password='sfsf').count()

显示sql语句
user_list = models.UserInfo.objects.all()
print user_list.query

取单条数据
try:
  #若没有数据直接报错
  models.UserInfo.objects.get(id=nid)
except Exception:
  pass

Django 后台admin
python manage.py createsuperuser

class UserGroup(models.Model):
  uid = models.AutoField(primary_key=True)
  caption = models.CharField(max_length=32, unique=True)
  ctime = models.DateTimeField(auto_now_add=True, null=True)
  uptime = models.DateTimeField(auto_now=True, null=True)


class UserInfo(models.Model):
  username = models.CharField(max_length=32)
  password = models.CharField(max_length=32)
  email = models.CharField(max_length=32)
  #外键关联表UserGroup 关联字段uid 默认用的是主键
  user_group = models.ForeignKey('UserGroup', to_field='uid', default=1 )
  user_type_choice = (
    (1, 'SuperAdmin'),
    (2, 'Administrator'),
    (3, 'Guest'),
  )
  user_type_id = models.IntegerField(choices=user_type_choice, default=1)

models.UserInfo.create(
  username = 'sfsd',
  password = 'sfs',
  emial = 'sdfs@sfds.com',
  user_group_id = 2,   #外键 = 外键名字+_id 即可
  user_type_id = 2
)

user_list = models.UserInfo.objects.all()
for row in user_list:
  print row.id
  print row.user_group_id
  print row.user_group.caption
  print row.user_group.uptime




from django.db import models

class Business(models.Model):
  caption = models.CharField(max_length=32)
  code = models.CharField(max_length=32, null=True, default='SA')

class Host(models.Model):
  nid = models.AutoField(primary_key = True)
  hostname = models.CharField(max_length=32, db_index=True)
  ip = models.GenericIPAddressField(db_index=True)
  port = models.IntegerField()
  b = models.ForeignKey('Business', to_field='id')

class Application(models.Model):
  name =  models.CharField(max_length=32)
  #自动创建关系表
  r = models.ManyToManyField('Host')

#自定义关系表
#class HostToApp(models.Model):
#  hobj = models.ForeignKey(to='Host', to_field='hid')
#  aobj = models.ForeignKey(to='Application', to_field='id')

v1 = models.Business.objects.all()
[obj(id, caption, code), obj(id, caption, code)]

v2 = models.Business.objects.all().values('id', 'caption')
[{'id':1, 'caption':'xxx'}, {'id':2, 'caption':'xxxx'}]

v3 = models.Business.objects.all().values_list('id', 'caption')
[(1, 'xxx'), (2, 'xxx')]

[对象obj]
v = models.Host.objects.filter(nid__gt=0)
for row in v:
  print row.nid, row.hostname, row.ip, row.port, row.b_id, row.b.caption, row.b.code

[字典]
v2 = models.Host.objects.filter(nid__gt=0).values('nid', 'hostname', 'b_id', 'b__caption')
for row in v2:
  print row['nid'], row['hostname'], row['b_id'], row['b__caption']

[元组]
v3 = models.Host.objects.filter(nid__gt=0).values_list('nid', 'hostname', 'b_id', 'b__caption')

$('#ajax_submit').click(function(){
  $.ajax({
    url: '/t_ajax',
    type: 'GET',
    data: {'user': 'root', 'pwd': '123'},
    success: function(data){
      if (data == 'OK'){
        var ojb = JSON.parse(data); //字符串转换成对象
        //JSON.stringf有（data）
        location.reload();  //刷新
      }else{
        alert(data);
      }
    }
  })
})

自动创建表关系
class Host(models.Model):
  nid = models.AutoField(primary_key=True)
  hostname = models.CharField(max_length=32, db_index=True)
  ip = models.GenericIPAddressField(protocol='ipv4', db_index=True)
  port models.IntegerField()
  b = models.ForeignKey(to='Bussiness', to_field='id')

#ManyToManyField 自动创建第三张关联表 => application_r
class Application(models.Model):
  name = models.CharField(max_length=32)
  r = models.ManyToManyField('Host')


#第三张表
application_r
------------------------------------
|id  |  application_id  |  host_id |
|----|------------------|----------|
|1   |        1         |      1   |
|2   |        1         |      2   |
|3   |        1         |      3   |
|4   |        2         |      2   |
|5   |        2         |      3   |
|6   |        2         |      4   |
|7   |        3         |      2   |
|8   |        4         |      3   |
------------------------------------

#无法直接对第三张表进行操作
#获取Application id=1的字段
obj = Application.objects.get(id=1)
obj.name

#第三张表操作
#在第三张表中 添加application id=1的 对应另一字段值1
#在第三张表中 添加application id=1的 对应另一字段值2,3,4
obj.r.add(1)
obj.r.add(1,2,3)
obj.r.add(*[1,2,3,4])

obj.r.remove(1)
obj.r.remove(2,4)
obj.r.remove(*[1,2,3])

#全部清除 application_id = 1 的对应项
obj.r.clear()

#只保留 application_id = 1 的其他字段3 4 5对应项
obj.r.set([3,4,5])

#获取应用名 以及 每个应用所对应的所有主机
app_list = models.Application.objects.all()
for app in app_list:
  print app.name

for host in app.r.all():
  print host.hostname

#创建应用并添加 与之对应的主机
host_list = [1,2,3,4]
obj = models.Application.objects.create(name=app_name)
obj.r.add(*host_list)



ajax 发送列表
$.ajax({
  url: '/ajax_post_list',
  data: {'user':'goo', 'host_list':[1,2,3,4,5]},
  type: 'POST',
  dataType: 'JSON',  //自动把返回的json格式字符串转换成json对象
  traditional: true, //针对发送的data数据 host_list为原始列表格式
  success: function(obj){  //dataType: JSON直接将返回数据转换为obj对象
    console.log(obj);
  }，
  error: function(){

  }
})
#获取主机列表
request.POST.getlist('host_list')



def user_list(request):
  current_page = request.GET.get('p', 1)
  current_page = int(current_page)
  start = (current_page -1) * 10
  end = current_page * 10
  data = L[start:end]

  all_count = len(L)
  count, y = divmod(all_count, 10)
  if y:
    count += 1

  page_list = []
  for i in range(i, count+1):
    if i == current_page:
      tmp = '<a class="page active" href="/user_list/?p=%s">%s</a>' %(i, i)
    else:
      tmp = '<a class="page" href="/user_list/?p=%s">%s</a>' %(i, i)
    page_list.append(tmp)

  page_str = "".join(page_list)
  page_str = make_safe(page_str)
  return render(request, 'user_list.html', {'li':data, 'page_str':page_str})




django 随机字符串
  生成字符串
  写到用户浏览器cookie中
  保存到session中
  在随机字符串对应的字典中设置相关内容

  request.session['username'] = user
  获取当前用户随机字符串 随机字符串保存在cookie中
  根据随机字符串去内存或数据库获取对应session随机字符串信息

$(function(){
  $.ajaxSetup({
    beforeSend: function(xhr, settings){
      xhr.setRequestHeader('X-CSRFtoken', $.cookie('csrftoken'));
    }
  });

  .('#btn1').click(function(){
    $.ajax({
      url: '/login/',
      type: 'POST',
      data: {'username': 'root', 'password':'google'},
      success:function(arg){
        pass
      }
    })
  })

})
