class Like < ActiveRecord::Base
  belongs_to :user
  belongs_to :question

  # Many-to-Many relationship
  # this will ensure that the user_id / question_id combination is unique
  validates :question_id, uniqueness: {scope: :user_id}
end
