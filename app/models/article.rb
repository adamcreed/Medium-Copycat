class Article < ApplicationRecord
  belongs_to :source
  has_many :comments
  has_many :marks, dependent: :destroy
end
