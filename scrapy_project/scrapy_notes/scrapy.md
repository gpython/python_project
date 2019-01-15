#### scrapy框架
- scrapy 命令
    - scrapy startproject project_name   创建项目
    - cd project_name
    - scrapy genspider crawl_name domain.com  创建crawl
    - 
    - scrapy crawl crawl_name --nolog    执行crawl
- 响应 response 封装响应相关的所有数据
    - response.text
    - response.encoding
    - response.body
    - response.request 当前响应是由哪个请求发起 请求封装 要访问的url 下载完成后要执行的那个函数

- pipelines.py
    - def open_spider(self, spider)         爬虫开始时 执行此函数
    - def process_item(self, item, spider)  处理数据item
    - def close_spider(self, spider)        爬虫关闭时 执行此函数
    - def from_crawler(cls, crawler)        类方法 初始化时用于创建pipeline对象 crawler.settings包含所有的settings设置 返回一个类对象
```py3
"""
判断当前XPipeline类中是否有from_crawler
True 通过类方法创建对象 
  obj = XPipeline.from_crawler(...)
False 通过类创建对象
  obj = XPipeline()

obj.open_spider()

obj.process_item() ......

obj.close_spider

"""
class XPipeline(object):
  def __init__(self,):
    pass
    
  @classmethod
  def from_crawler(cls, crawler):
    #初始化时 用于创建pipeline对象
    #crawler.settings获取所有的settings参数
    path = crawler.settings.get("SOME_SETTINGS_VARS")
    return cls(path)
  
  def open_spider(self, spider):
    #爬虫开始时 执行此函数
    pass
   
  def process_item(self, item, spider):
    #数据处理 yield 数据由此函数执行
    #return 返回数据 交给下一个pipeline处理
    #若不想下一个pipeline处理数据 则 raise DropItem() 即可 
    #若settings中有下一个pipeline 则return数据交由下一个pipeline处理
    return item
  
  def close_spider(self, spider)
    #爬虫关闭时 执行此函数
    pass
```
- cookie
```python
import scrapy
from scrapy.http.cookies import CookieJar

def parse(self, response):
  cookie_dict = {}
  
  #获取cookie
  #在响应头中获取Cookie
  #第一次访问返回的响应内容 response
  cookie_jar = CookieJar()
  cookie_jar.extract_cookies(response, response.request)
  
  for k, v in cookie_jar._cookies.items():
    for i, j in v.items():
      for m, n in j.items():
        cookie_dict[m] = n.value
  
  #请求携带cookie
  yield scrapy.Request(
    url=url,
    method="POST",
    body="username=xxx&password=xxxx",
    cookies=cookie_dict,
    callback=self.check_login,
  )
  
def check_login(self, response):
  print(response.text)

```
scrapy 引擎首先调用 start_requests()方法 拿取起始的url地址

v= iter(返回值)

req1 = v.__next__()

req2 = v.__next__()

req全部放到调度器中

返回生成器 其实最终会变成迭代器 循环

```python
#scrapy引擎先调用start_requests方法
#返回生成器 或者可迭代的对象 可迭代对象后续可由iter处理 
def start_requests(self):
  #1 生成器形式返回方式
  for url in self.start_urls:
    yield Request(url=url， type=xx, method=POST)
  
  #2 可迭代对象返回方式
  req_list = []
  for url in self.start_urls:
    req_list.append(Request(url=url))
  return req_list
```

- scrapy中设置代理
    - 内置 在爬虫启动的时候 在os.environ中设置代理即可 downloadmiddlerware/httpproxy处理
    - import os
    - os.environ["HTTP_PROXY"] = "http://root:passwd@11.1.1.1:8080"
    - os.environ["HTTPS_PROXY"] = '1.1.1.1:8080' 

```python
def start_requests(self):
  #1 环境变量形式添加代理
  import os
  os.environ["HTTP_PROXY"] = "http://root:passwd@11.1.1.1:8080"
  os.environ["HTTPS_PROXY"] = '1.1.1.1:8080'
  
  #2 request.meta中添加proxy meta传参数形式
  for url in self.start_urls:
    yield Request(url=url, callback=self.parse, meta={'proxy': 'http://root:passwd@1.1.1.1:8080'})

```

自定义代理 和 User-Agent
```python
import base64
from six.moves.urllib.parse import unquote
try:
  from urllib2 import _parse_proxy
except ImportError:
  from urllib.request import _parse_proxy
from six.moves.urllib.parse import urlunparse
from scrapy.utils.python import to_bytes

import random

class RandomProxy(object):
  def __init__(self, proxies):
    self.proxies = proxies

  @classmethod
  def from_crawler(cls, crawler):
    #settings.py文件中设置
    # PROXYIES = [
    #   "http://root:passwd@1.1.1.1:8080"
    #   "http://root:passwd@1.1.1.1:8080"
    #   "http://root:passwd@1.1.1.1:8080"
    #   "http://root:passwd@1.1.1.1:8080"
    # ]
    proxies = crawler.settings.get("PROXIES")
    return cls(proxies)

  def _basic_auth_header(self, username, password):
    user_pass = to_bytes(
      '%s:%s' % (unquote(username), unquote(password)),
      encoding=self.auth_encoding
    )
    return base64.b64encode(user_pass).strip()

  def process_request(self, request, spider):
    url = random.choices(self.proxies)

    orig_type = ""
    proxy_type, user, password, hostport = _parse_proxy(url)
    proxy_url = urlunparse((proxy_type or orig_type, hostport, '', '', '', ''))

    if user:
      creds = self._basic_auth_header(user, password)
    else:
      creds = None

    request.meta['proxy'] = proxy_url
    if creds and not request.headers.get('Proxy-Authorization'):
      request.headers['Proxy-Authorization'] = b'Basic ' + creds


class RandomUserAgent(object):
  #请求发送之前给request的headers头赋值
  def process_request(self, request, spider):
    ua = random.choices(spider.settings.get("USER_AGENT_LIST"))
    #添加请求头
    request.headers["User-Agent"] = ua
    #添加请求代理 需要在request的meta信息中添加proxy字段
    #request.meta["proxy"] = "http://proxy:port"
```
    

- GIL
    - 保证同一时刻一个进程只有一个线程被CPU调度

    
    
    
    