require 'httparty'
require 'nokogiri'

def main
  scrape_sources
  scrape_articles
end

def scrape_sources
  sources_page = HTTParty.get 'https://newsapi.org/v1/sources'

  seed_news_sources(sources_page) if response_is_ok?(sources_page)
end

def response_is_ok?(page)
  page['status'] == 'ok'
end

def seed_news_sources(sources_page)
  sources_page['sources'].each do |news_source|
    url_to_logo = set_logo(news_source)
    Source.create(
      id: news_source['id'],
      name: news_source['name'],
      description: news_source['description'],
      url: news_source['url'],
      category: news_source['category'],
      language: news_source['language'],
      country: news_source['country'],
      url_to_logo: url_to_logo,
      sort_bys: news_source['sortBysAvailable'].join(', ')
    )
  end
end

def set_logo(news_source)
  if source_is_missing_logo?(news_source)
    'https://image.freepik.com/free-icon/news-logo_318-38132.jpg'
  else
    news_source['urlsToLogos']['large']
  end
end

def source_is_missing_logo?(news_source)
  news_source['urlsToLogos'].nil? or news_source['urlsToLogos']['large'].nil?
end

def scrape_articles
  news_sources = Source.all

  news_sources.each do |news_source|
    stories = read_stories_from_url(news_source)

    seed_stories(stories, news_source) if response_is_ok?(stories)
  end
end

def read_stories_from_url(news_source)
  api_key = ENV['NEWSAPI_KEY']
  sort_by = get_sort_by(news_source['sort_bys'])
  HTTParty.get "https://newsapi.org/v1/articles?source=#{news_source['id']}&sortBy=#{sort_by}&apiKey=#{api_key}"
end

def get_sort_by(sort_bys)
  sort_bys =~ /top/ ? 'top' : 'latest'
end

def seed_stories(stories, news_source)
  # regex captures the date from a time stamp
  date_regex = /(\d+[\/-]\d+[\/-]\d+)/

  stories['articles'].each do |story|
    story['author'] = set_author(story['author'], news_source['name'])
    story['publishedAt'] = story['publishedAt'] || '1999-09-09'

    article = Article.create(
      author: story['author'],
      title: story['title'],
      description: story['description'],
      url: story['url'],
      url_to_image: story['urlToImage'],
      published_at: story['publishedAt'][date_regex],
      source_id: news_source['id']
    )
  end
end

def set_author(author, source_name)
  author.blank? ? source_name : author
end

main
