class Task < ApplicationRecord
  belongs_to :category
  belongs_to :user

  validates :description, presence: true,
                          length: { minimum: 10, maximum: 100 }

  validate :priority_date_cannot_be_in_the_past

  def priority_date_cannot_be_in_the_past
    errors.add(:priority, "can't be in the past") if priority.present? && priority < Date.today
  end
end
