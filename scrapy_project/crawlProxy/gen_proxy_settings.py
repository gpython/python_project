#encoding:utf-8
from proxy import Crawl

c = Crawl()

data = c.get_all_proxies()

print(data)
print(type(data))
print(list(data))
print([bytes.decode(i) for i in data])