#!/bin/sh
rm eotfs.json
scrapy runspider scrape.py -o eotfs.json
