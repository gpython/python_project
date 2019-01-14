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




- GIL
    - 保证同一时刻一个进程只有一个线程被CPU调度

    
    
    
    