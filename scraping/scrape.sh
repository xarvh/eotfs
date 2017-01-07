#!/bin/sh
rm eotfs.json
scrapy runspider scrape.py -o eotfs.json
cat header.js eotfs.json > ../build/db.js
