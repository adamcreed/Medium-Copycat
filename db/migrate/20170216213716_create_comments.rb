class CreateComments < ActiveRecord::Migration[5.0]
  def change
    create_table :comments do |t|
      t.string :author_name
      t.text :content
      t.integer :parent_comment_id

      t.timestamps
    end
  end
end
