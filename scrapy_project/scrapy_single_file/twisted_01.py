#encoding:utf-8

from twisted.web.client import getPage, defer
from twisted.internet import reactor

#接受任务
#执行回调
def callback(content):
  print(content)

deferred_list = []
url_list = ['http://www.bing.com', 'https://segmentfault.com/','https://stackoverflow.com/']

#请求前处理准备工作
for url in url_list:
  #twisted获取请求 的url地址
  deferred = getPage(bytes(url, encoding="utf-8"))
  #获取请求后页面处理 执行的回调函数
  deferred.addCallback(callback)
  #将请求url 的deferred添加到列表中
  deferred_list.append(deferred)

# 执行任务
dlist = defer.DeferredList(deferred_list)

def all_done(arg):
  reactor.stop()

#任务执行完成后 执行的函数
dlist.addBoth(all_done)

#执行任务
reactor.run()



