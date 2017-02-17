require 'dotenv/load'
require 'httparty'
require 'nokogiri'
require 'json'
require 'pry'
require 'csv'

api_key = ENV['NEWSAPI_KEY']
sources_page = HTTParty.get 'https://newsapi.org/sources'
# regex captures source name without leading slash and ending '-api'
source_regex = /\/([\w-]+)-api/
# regex captures the date from a time stamp
date_regex = /(\d+[\/-]\d+[\/-]\d+)/

news_sources = Nokogiri::HTML(sources_page).css('.source').map do |news_source|
  news_source['href'][source_regex, 1]
end

news_sources.each do |news_source|
  stories = HTTParty.get "https://newsapi.org/v1/articles?source=#{news_source}&sortBy=top&apiKey=#{api_key}"

  if stories['status'] == 'ok'
  stories['articles'].each do |story|
    Article.create(
      author: story['author'],
      title: story['title'],
      description: story['description'],
      url: story['url'],
      url_to_image: story['urlToImage'],
      published_at: story['publishedAt'][date_regex]
    )
  end
end
