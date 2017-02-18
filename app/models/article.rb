class Article < ApplicationRecord
  belongs_to :source, foreign_type: :string
end
