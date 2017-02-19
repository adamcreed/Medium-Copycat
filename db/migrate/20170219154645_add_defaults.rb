class AddDefaults < ActiveRecord::Migration[5.0]
  def change
    change_column :articles, :published_at, :string, default: -> { "to_char(now(), 'YYYY-MM-DD'::text)" }
    change_column :articles, :source_id, :string, default: 'other'
    change_column :comments, :parent_comment_id, :integer, default: 0
    change_column :marks, :favorited, :boolean, default: false
    change_column :marks, :bookmarked, :boolean, default: false
    change_column :marks, :article_id, :integer, default: 0
    change_column :marks, :comment_id, :integer, default: 0
  end
end
