class User < ActiveRecord::Base
  # http://api.rubyonrails.org/classes/ActiveModel/SecurePassword/ClassMethods.html
  has_secure_password

  has_many :questions, dependent: :nullify
  has_many :answers, dependent: :nullify


  # Many-to-Many relationship
  has_many :likes, dependent: :destroy
  has_many :liked_questions, through: :likes, source: :question
  has_many :favourites, dependent: :destroy
  has_many :favourite_questions, through: :favourites, source: :question


  # /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z]+)*\.[a-z]+\z/i
  validates :email, presence: true, uniqueness: true,
            format: /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z]+)*\.[a-z]+\z/i

  def full_name
    "#{first_name} #{last_name}".strip
  end

  def liked_question?(question)
    liked_questions.include?(question)
  end

  def favourite_question?(question)
    favourite_questions.include?(question)
  end
end
