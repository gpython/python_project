# -*- coding: utf-8 -*-

# Define here the models for your spider middleware
#
# See documentation in:
# https://doc.scrapy.org/en/latest/topics/spider-middleware.html

import base64
from six.moves.urllib.parse import unquote
try:
  from urllib2 import _parse_proxy
except ImportError:
  from urllib.request import _parse_proxy
from six.moves.urllib.parse import urlunparse
from scrapy.utils.python import to_bytes

from scrapy import signals
import random

class RandomProxy(object):
  def __init__(self, proxies):
    self.proxies = proxies
    print(self.proxies)

  @classmethod
  def from_crawler(cls, crawler):
    #settings.py文件中设置
    # PROXYIES = [
    #   "http://root:passwd@1.1.1.1:8080",
    #   "http://root:passwd@1.1.1.1:8080",
    #   "http://root:passwd@1.1.1.1:8080",
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
    url = random.choice(self.proxies)
    print(url)

    orig_type = ""
    proxy_type, user, password, hostport = _parse_proxy(url)
    proxy_url = urlunparse((proxy_type or orig_type, hostport, '', '', '', ''))
    print(proxy_url)
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
    # proxy = random.choices(spider.settings.get("PROXIES"))
    #添加请求头
    request.headers["User-Agent"] = ua
    #添加请求代理 需要在request的meta信息中添加proxy字段
    # request.meta["proxy"] = proxy


class DangdangSpiderMiddleware(object):
    # Not all methods need to be defined. If a method is not defined,
    # scrapy acts as if the spider middleware does not modify the
    # passed objects.

    @classmethod
    def from_crawler(cls, crawler):
        # This method is used by Scrapy to create your spiders.
        s = cls()
        crawler.signals.connect(s.spider_opened, signal=signals.spider_opened)
        return s

    def process_spider_input(self, response, spider):
        # Called for each response that goes through the spider
        # middleware and into the spider.

        # Should return None or raise an exception.
        return None

    def process_spider_output(self, response, result, spider):
        # Called with the results returned from the Spider, after
        # it has processed the response.

        # Must return an iterable of Request, dict or Item objects.
        for i in result:
            yield i

    def process_spider_exception(self, response, exception, spider):
        # Called when a spider or process_spider_input() method
        # (from other spider middleware) raises an exception.

        # Should return either None or an iterable of Response, dict
        # or Item objects.
        pass

    def process_start_requests(self, start_requests, spider):
        # Called with the start requests of the spider, and works
        # similarly to the process_spider_output() method, except
        # that it doesn’t have a response associated.

        # Must return only requests (not items).
        for r in start_requests:
            yield r

    def spider_opened(self, spider):
        spider.logger.info('Spider opened: %s' % spider.name)


class DangdangDownloaderMiddleware(object):
    # Not all methods need to be defined. If a method is not defined,
    # scrapy acts as if the downloader middleware does not modify the
    # passed objects.

    @classmethod
    def from_crawler(cls, crawler):
        # This method is used by Scrapy to create your spiders.
        s = cls()
        crawler.signals.connect(s.spider_opened, signal=signals.spider_opened)
        return s

    def process_request(self, request, spider):
        # Called for each request that goes through the downloader
        # middleware.

        # Must either:
        # - return None: continue processing this request
        # - or return a Response object
        # - or return a Request object
        # - or raise IgnoreRequest: process_exception() methods of
        #   installed downloader middleware will be called
        return None

    def process_response(self, request, response, spider):
        # Called with the response returned from the downloader.

        # Must either;
        # - return a Response object
        # - return a Request object
        # - or raise IgnoreRequest
        return response

    def process_exception(self, request, exception, spider):
        # Called when a download handler or a process_request()
        # (from other downloader middleware) raises an exception.

        # Must either:
        # - return None: continue processing this exception
        # - return a Response object: stops process_exception() chain
        # - return a Request object: stops process_exception() chain
        pass

    def spider_opened(self, spider):
        spider.logger.info('Spider opened: %s' % spider.name)
