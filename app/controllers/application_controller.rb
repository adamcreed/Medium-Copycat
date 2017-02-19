class ApplicationController < ActionController::API
  def article_with_stats(article)
    favorite_count = Mark.where('article_id = ? AND favorited = true', article.id).count
    bookmark_count = Mark.where('article_id = ? AND bookmarked = true', article.id).count
    {
      article: article,
      favorites: {
        count: favorite_count,
        favorited: not(favorite_count.zero?),
        bookmarked: not(bookmark_count.zero?)
      },
      number_of_comments: Comment.where(article_id: article.id).count,
      total_pages: @articles.page(1).total_pages
    }
  end
end
