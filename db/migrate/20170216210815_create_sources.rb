class CreateSources < ActiveRecord::Migration[5.0]
  def change
    create_table :sources do |t|
      t.string :name
      t.string :description
      t.string :url
      t.string :category
      t.string :language
      t.string :country
      t.string :url_to_logo
      t.string :sort_bys

      t.timestamps
    end
  end
end
