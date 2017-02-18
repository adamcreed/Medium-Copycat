require 'httparty'
require 'nokogiri'

def scrape_sources
  sources_page = HTTParty.get 'https://newsapi.org/v1/sources'

  if sources_page['status'] == 'ok'
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
  api_key = ENV['NEWSAPI_KEY']
  # sources_page = HTTParty.get 'https://newsapi.org/sources'
  # regex captures source name without leading slash and ending '-api'
  source_regex = /\/([\w-]+)-api/
  # regex captures the date from a time stamp
  date_regex = /(\d+[\/-]\d+[\/-]\d+)/

  # news_sources = Nokogiri::HTML(sources_page).css('.source').map do |news_source|
  #   news_source['href'][source_regex, 1]
  # end

  news_sources = Source.all

  news_sources.each do |news_source|
    sort_by = get_sort_by(news_source['sort_bys'])
    source_id = news_source['id']
    stories = HTTParty.get "https://newsapi.org/v1/articles?source=#{source_id}&sortBy=#{sort_by}&apiKey=#{api_key}"

    if stories['status'] == 'ok'
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
          source_id: source_id
        )
      end
    end
  end
end

def get_sort_by(sort_bys)
  sort_bys =~ /top/ ? 'top' : 'latest'
end

def set_author(author, source_name)
  author.blank? ? source_name : author
end

scrape_sources
scrape_articles
