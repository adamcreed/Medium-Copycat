class MarksController < ApplicationController
  before_action :set_mark, only: [:show, :update, :destroy]

  # GET /marks
  def index
    @marks = Mark.all

    render json: @marks
  end

  # GET /marks/1
  def show
    render json: @mark
  end

  # POST /marks
  def create
    @mark = Mark.new(mark_params)
    @mark.article_id = 0 if @mark.article_id.blank?
    @mark.comment_id = 0 if @mark.comment_id.blank?
    @mark.favorited = false if @mark.favorited.blank?
    @mark.bookmarked = false if @mark.bookmarked.blank?


    if @mark.save
      render json: @mark, status: :created, location: @mark
    else
      render json: @mark.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /marks/1
  def update
    if @mark.update(mark_params)
      render json: @mark
    else
      render json: @mark.errors, status: :unprocessable_entity
    end
  end

  # DELETE /marks/1
  def destroy
    if @mark.blank?
      render json: @mark, status: :unprocessable_entity
    else
      @mark.destroy
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_mark
      params[:mark][:article_id] = 0 if params[:mark][:article_id].blank?
      params[:mark][:comment_id] = 0 if params[:mark][:comment_id].blank?
      params[:mark][:favorited] = false if params[:mark][:favorited].blank?
      params[:mark][:bookmarked] = false if params[:mark][:bookmarked].blank?
      @mark = Mark.find_by("article_id = ? AND comment_id = ? AND favorited = ? AND bookmarked = ?", params[:mark][:article_id], params[:mark][:comment_id], params[:mark][:favorited], params[:mark][:bookmarked])
    end

    # Only allow a trusted parameter "white list" through.
    def mark_params
      params.require(:mark).permit(:favorited, :bookmarked, :comment_id, :article_id)
    end
end
