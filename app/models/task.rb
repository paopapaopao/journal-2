class Task < ApplicationRecord
  belongs_to :category
  belongs_to :user

  validates :description, presence: true,
                          length: { minimum: 10, maximum: 100 }
end
