class Article < ApplicationRecord
  belongs_to :source
  has_many :comments, dependent: :destroy
  has_many :marks, dependent: :destroy
end
