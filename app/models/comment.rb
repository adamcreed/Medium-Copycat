class Comment < ApplicationRecord
  belongs_to :article
  has_many :marks
end
