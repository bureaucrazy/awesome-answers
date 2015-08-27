class Category < ActiveRecord::Base
  # we chose :nullfiy because we want when a category is deleted to just
  # have the category_id in the questions table record become null instead
  # of deleting the questions
  has_many :questions, dependent: :nullify

  validates :name, presence: true, uniqueness: true
end
