class Task < ApplicationRecord
  validates :description, presence: true,
                          length: { minimum: 10 }
end
