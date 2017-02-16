class CreateArticles < ActiveRecord::Migration[5.0]
  def change
    create_table :articles do |t|
      t.string :author
      t.string :description
      t.string :title
      t.string :url
      t.string :url_to_image
      t.string :published_at

      t.timestamps
    end
  end
end
