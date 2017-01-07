import scrapy


class EotfsSpider(scrapy.Spider):
    name = "eotfs"

    start_urls = open('threads').read().split('\n')

    def parse(self, response):

        threadTitle = response.css('h1.ipsType_pageTitle div::text').extract_first().split(']')[-1].strip() or response.url.split("/")[-2]

        for post in response.css('article'):
            yield {
                'thread': threadTitle,
                'author': post.css('h3 strong a::text').extract_first(),
                'timestamp': post.css('time::attr(datetime)').extract_first(),
                'content': post.css('[data-role="commentContent"] > *').extract(),
            }

        next_page = response.css('a[title="Next page"]::attr("href")').extract_first()
        if next_page is not None:
            next_page = response.urljoin(next_page)
            yield scrapy.Request(next_page, callback=self.parse)
