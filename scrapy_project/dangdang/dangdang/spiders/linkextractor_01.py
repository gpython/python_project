#encoding:utf-8
#encoding:utf-8
from scrapy.http import HtmlResponse
from scrapy.linkextractors import LinkExtractor
html1='''
    <html>
        <body>      
            <div id="top">         
                <p>下面是一些站内链接</p>         
                <a class="internal" href="/intro/install.html">Installation guide</a>
                <a class="internal" href="/intro/tutorial.html">Tutorial</a>         
                <a class="internal" href="../examples.html">Examples</a>      
            </div>      
            <div id="bottom">         
                <p>下面是一些站外链接</p>         
                <a href="http://stackoverflow.com/tags/scrapy/info">StackOverflow</a>         
                <a href="https://github.com/scrapy/scrapy">Fork on Github</a>      
            </div>
        </body>
    </html>
'''
html2='''
    <html>   
        <head>       
            <script type='text/javascript' src='/js/app1.js'/>       
            <script type='text/javascript' src='/js/app2.js'/>   response1

        </head>   
        <body>       
            <a href="/home.html">主页</a>       
            <a href="javascript:goToPage('/doc.html'); return false">文档</a>       
            <a href="javascript:goToPage('/example.html'); return false">案例</a>   
        </body>
    </html>
'''
response1=HtmlResponse(url='http://example1.com',body=html1,encoding='utf-8')
response2=HtmlResponse(url='http://example2.com',body=html2,encoding='utf-8')

#特例情况，LinkExtractor构造器的所有参数都有默认值，如果构造对象时不传递任何参数（使用默认值），就提取页面中所有链接
le = LinkExtractor()
links = le.extract_links(response1)
print([link.url for link in links])

#allow
#接收一个正则表达式或一个正则表达式列表，提取绝对url与正则表达式匹配的链接
pattern = r'/intro/.+.html$'

le = LinkExtractor(allow=pattern)
links = le.extract_links(response1)
print([link for link in links])

#
pattern=r'.*.html$'
le=LinkExtractor(deny=pattern)
links=le.extract_links(response1)
print([link.url for link in links])

#
domains=['stackoverflow.com','github.com']
le=LinkExtractor(allow_domains=domains)
links=le.extract_links(response1)
print([link.url for link in links])


