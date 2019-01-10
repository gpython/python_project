# -*- coding: utf-8 -*-
from copy import deepcopy
import re
import scrapy
from scrapy.linkextractors import LinkExtractor
from scrapy.spiders import CrawlSpider, Rule
from scrapy_redis.spiders import RedisCrawlSpider


class ZSpider(RedisCrawlSpider):
  name = 'z'
  allowed_domains = ['amazon.cn']
  # start_urls = ['https://www.amazon.cn/gp/book/all_category/ref=sv_b_1']
  redis_key = "amazon"

  rules = (
    # Rule(LinkExtractor(restrict_xpaths=('//div[@id="content"]//div[@class="a-row a-size-base"]//td',)), callback="parse_book_list"),
    Rule(LinkExtractor(restrict_xpaths=('//div[@id="mainResults"]//ul//li//h2/..',)), callback="parse_list"),
    Rule(LinkExtractor(restrict_xpaths=('//div[@id="pagn"]',)), follow=True)
  )

  def parse_book_list(self, response):
    #response.body.decode()
    item = {}
    book_list = response.xpath('//div[@id="mainResults"]//ul//li//h2/..')
    for book in book_list:
      book_detail_url = book.xpath('./@href').extract_first()
      yield scrapy.Request(
        book_detail_url,
        callback=self.parse_list,
        meta={"item": item},
      )

    #书籍列表 下一页
    # next_url = response.xpath('//div[@id="pagn"]//a[@title="下一页"]//@href').extract_first()
    # next_url  = response.urljoin(next_url)
    # if next_url:
    #   yield scrapy.Request(
    #     next_url,
    #     callback=self.parse_list,
    #     meta={"item":item}
    #   )

  # 解析书籍信息
  def parse_list(self, response):
    print("*"*50)
    # item = response.meta.get("item")
    item = {}
    item["book_title"] = response.xpath('//div[@id="booksTitle"]//span[1]//text()').extract_first()
    item["book_author"] = response.xpath('//div[@id="bylineInfo"]//span//a//text()').extract()
    book_info = response.xpath('//div[@id="detail_bullets_id"]//table//ul//li//text()').extract()
    item["book_info"] = [re.sub(r"[\s]", "", info) for info in book_info if book_info is not None]
    item["book_img"] = response.xpath('//div[@id="main-image-container"]//img//@src').extract_first()
    book_content = response.xpath('//div[@id="descriptionAndDetails"]//div[@id="s_contents"]//text()').extract()
    item["book_content"] = [re.sub(r"[\s]", "", content) for content in book_content if book_content is not None]
    item["book_img"] = response.xpath('//div[@id="descriptionAndDetails"]//div[@id="s_contents"]//img//@src').extract()
    item["comment"] = []
    # print(item)

    # 更多评论 新页面显示评论
    more_url = response.xpath("//div[@id='reviews-medley-footer']//a[@data-hook='see-all-reviews-link-foot']//@href").extract_first()
    if more_url is not None:
      url = response.urljoin(more_url)
      yield scrapy.Request(
        url,
        callback=self.parse_comment,
        meta={"item": deepcopy(item)}
      )
    # 少量评论 当前页面
    else:
      comment_list = response.xpath("//div[re:test(@id, 'customer_review-.*')]")
      for comment in comment_list:
        comments = {}
        comments["comment_username"] = comment.xpath(".//span[@class='a-profile-name']//text()").extract_first()
        comments["comment_content"] = comment.xpath(".//div[@data-hook='review-collapsed']//text()").extract()
        comments["comment_star"] = comment.xpath(".//a[@class='a-link-normal']//@title").extract_first()
        comments["comment_title"] = comment.xpath(".//a[@data-hook='review-title']//text()").extract_first()
        comments["comment_time"] = comment.xpath(".//span[@data-hook='review-date']//text()").extract_first()
        item["comment"].append(comments)
      print(item)
    yield item

  def parse_comment(self, response):
    item = response.meta.get("item")
    comment_list = response.xpath("//div[re:test(@id, 'customer_review-.*')]")
    for comment in comment_list:
      comments = {}
      comments["comment_username"] = comment.xpath(".//span[@class='a-profile-name']//text()").extract_first()
      comments["comment_content"] = comment.xpath(".//span[@data-hook='review-body'][1]//text()").extract()
      comments["comment_star"] = comment.xpath(".//a[@class='a-link-normal']//@title").extract_first()
      comments["comment_title"] = comment.xpath(".//a[@data-hook='review-title']//text()").extract_first()
      comments["comment_time"] = comment.xpath(".//span[@data-hook='review-date']//text()").extract_first()
      item["comment"].append(comments)
    next_url = response.xpath("//li[@class='a-last']//@href").extract_first()
    if next_url is not None:
      next_url = response.urljoin(next_url)
      yield scrapy.Request(
        next_url,
        callback=self.parse_comment,
        meta={"item": item}
      )
    print(item)
    yield item
