class CreateMarks < ActiveRecord::Migration[5.0]
  def change
    create_table :marks do |t|
      t.boolean :favorited
      t.boolean :bookmarked
      t.references :comment, foreign_key: true
      t.references :article, foreign_key: true

      t.timestamps
    end
  end
end
