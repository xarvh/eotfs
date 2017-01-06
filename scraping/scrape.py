import scrapy


class EotfsSpider(scrapy.Spider):
    name = "eotfs"
    start_urls = [
        'https://www.rpnation.com/topic/49741-emperors-of-the-fading-suns-emperors-of-the-fading-suns-chapter-6-scene-17-renovations/'
    ]

    def parse(self, response):
        threadId = response.url.split("/")[-2]
        for post in response.css('article'):
            yield {
                    'threadId': threadId,
                    'author': post.css('h3 strong a::text').extract_first(),
                    'timestamp': post.css('time::attr(datetime)').extract_first(),
                    'content': post.css('[data-role="commentContent"] > *').extract(),
            }

        next_page = response.css('a[title="Next page"]::attr("href")').extract_first()
        if next_page is not None:
            next_page = response.urljoin(next_page)
            yield scrapy.Request(next_page, callback=self.parse)
