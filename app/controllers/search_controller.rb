class SearchController < ApplicationController
  def articles
    page = params.fetch 'page', 1
    per = params.fetch 'per_page', 15
    q = params.fetch 'q', ''
    @articles = Article.where("").page(page).per(per).map do |article|
      article_with_stats(article)
    end

    render json: @articles
  end
end
