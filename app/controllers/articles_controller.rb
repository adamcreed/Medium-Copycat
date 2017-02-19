class ArticlesController < ApplicationController
  before_action :set_article, only: [:show, :update, :destroy]

  # GET /articles
  def index
    page = params.fetch 'page', 1
    per = params.fetch 'per_page', 15
    @articles = Article.all
    @articles = @articles.page(page).per(per).map do |article|
      article_with_stats(article)
    end

    render json: @articles
  end

  # GET /articles/1
  def show
    render json: article_with_stats(@article)
  end

  # POST /articles
  def create
    @article = Article.new(article_params)
    @article.published_at = Date.today.to_s if @article.published_at.blank?

    if @article.save
      render json: @article, status: :created, location: @article
    else
      render json: @article.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /articles/1
  def update
    if @article.update(article_params)
      render json: @article
    else
      render json: @article.errors, status: :unprocessable_entity
    end
  end

  # DELETE /articles/1
  def destroy
    @article.destroy
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_article
      @article = Article.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def article_params
      params.require(:article).permit(:author, :description, :title, :url, :url_to_image, :published_at, :source_id)
    end
end
