class Category < ApplicationRecord
  validates :title, presence: true, uniqueness: true
  validates :description, presence: true,
                          length: { minimum: 10, maximum: 100 }

  has_many :tasks
end
