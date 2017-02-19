class SearchController < ApplicationController
  def articles
    page = params.fetch 'page', 1
    per = params.fetch 'per_page', 15
    q = params.fetch 'q', ''
    @articles = Article.where('title ILIKE ?', "%#{q}%")
    @articles = @articles.page(page).per(per).map do |article|
      article_with_stats(article)
    end

    render json: @articles
  end

  def sources
    q = params.fetch 'q', ''
    @sources = Source.where('name ILIKE ?', "%#{q}%")

    render json: @sources
  end
end
