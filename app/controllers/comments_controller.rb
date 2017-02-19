class CommentsController < ApplicationController
  before_action :set_comment, only: [:show, :update, :destroy]

  # GET /articles/:article_id/comments
  def index
    page = params.fetch 'page', 1
    @comments = Comment.where(article_id: params[:article_id]).page(page).map do |comment|
      comment_with_stats(comment)
    end

    render json: @comments
  end

  # GET /articles/:article_id/comments/1
  def show
    render json: comment_with_stats(@comment)
  end

  # POST /articles/:article_id/comments
  def create
    @comment = Comment.new(comment_params)
    @comment.parent_comment_id = 0 if @comment.parent_comment_id.blank?

    if @comment.save
      render json: @comment, status: :created # , location: @comment
    else
      render json: @comment.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /articles/:article_id/comments/1
  def update
    if @comment.update(comment_params)
      render json: @comment
    else
      render json: @comment.errors, status: :unprocessable_entity
    end
  end

  # DELETE /articles/:article_id/comments/1
  def destroy
    @comment.destroy
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_comment
      @comment = Comment.find(params[:id])
    end

    def comment_with_stats(comment)
      favorite_count = Mark.where('comment_id = ? AND favorited = true', comment.id).count
      bookmark_count = Mark.where('comment_id = ? AND bookmarked = true', comment.id).count
      {
        comment: comment,
        favorites: {
          count: favorite_count,
          favorited: not(favorite_count.zero?),
          bookmarked: not(bookmark_count.zero?)
        },
        number_of_replies: Comment.where(parent_comment_id: comment.id).count,
        total_pages: Comment.where(parent_comment_id: comment.id).page(1).total_pages
      }
    end
    # Only allow a trusted parameter "white list" through.
    def comment_params
      params.require(:comment).permit(:author_name, :content, :parent_comment_id, :article_id)
    end
end
