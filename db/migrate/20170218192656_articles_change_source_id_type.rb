class ArticlesChangeSourceIdType < ActiveRecord::Migration[5.0]
  def change
    change_column(:articles, :source_id, :string)
  end
end
