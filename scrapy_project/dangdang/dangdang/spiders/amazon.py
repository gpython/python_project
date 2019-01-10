# -*- coding: utf-8 -*-
#cd dangdang/dangdang
#scrapy genspider -t crawl amazon amazon.cn
from copy import deepcopy

import scrapy
from scrapy.linkextractors import LinkExtractor
from scrapy.spiders import CrawlSpider, Rule
from scrapy_redis.spiders import RedisCrawlSpider


class AmazonSpider(RedisCrawlSpider):
  name = 'amazon'
  allowed_domains = ['amazon.cn']
  # start_urls = ['https://www.amazon.cn/gp/book/all_category/ref=sv_b_1']
  redis_kye = "amazon"

  rules = (
    Rule(LinkExtractor(allow=(r'http.+ie=UTF8&node=\d+',)), follow=False),
    Rule(LinkExtractor(restrict_xpaths=('//div[@id="mainResults"]//ul//li//h2/..',)), callback="parse_list"),
    Rule(LinkExtractor(restrict_xpaths=('//div[@id="pagn"]',)), follow=True)
  )

  #解析书籍信息
  def parse_list(self, response):
    item = {}
    item["book_title"] = response.xpath('//div[@id="booksTitle"]//span[1]//text()').extract_first()
    item["book_author"] = response.xpath('//div[@id="bylineInfo"]//span//a//text()').extract()
    item["book_info"] = response.xpath('//div[@id="detail_bullets_id"]//table//ul//li//text()').extract()
    item["book_img"] = response.xpath('//div[@id="main-image-container"]//img//@src').extract_first()
    item["book_content_1"] = response.xpath('//div[@id="descriptionAndDetails"]//div[@id="s_contents"]//text()').extract()
    item["book_img"] = response.xpath('//div[@id="descriptionAndDetails"]//div[@id="s_contents"]//img//@src').extract()
    item["comment"] = []
    #更多评论 新页面显示评论
    more_url = response.xpath("//div[@id='reviews-medley-footer']//a[@data-hook='see-all-reviews-link-foot']//@href").extract_first()
    if more_url is not None:
      url = response.urljoin(more_url)
      yield scrapy.Request(
        url,
        callback=self.parse_comment,
        meta={"item": deepcopy(item)}
      )
    #少量评论 当前页面
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
        meta = {"item": item}
      )
    print(item)
    yield item



