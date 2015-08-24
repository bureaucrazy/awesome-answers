class Question < ActiveRecord::Base

  # This prevents the record from saving/updating unless a title is provided.
  # validates :title, presence: true,
  #                   uniqueness: true
  # This will let you set a custom message about presence errors.
  validates :title, presence:   {message: "must be present"},
                    # this will check for the uniqueness of the title/body
                    # combination. So title doesn't have to be unique by itself
                    # but the combination with body should.
                    uniqueness: {scope: :body},
                    length:     {minimum: 3}    # title must have at least 3 chars
  validates :body, presence: true
  validates :view_count, presence:     true,
                         numericality: {greater_than_or_equal_to: 0}

  # If you had an email attribute you can validate the format of the attribute
  # using the 'format' option, it takes a regular expression
  # validates :email, format: /\A[w+\-.]+@[a-z\d\-]+(\.[a-z]+)*\.[a-z]+\z/i

  # We use validate if we want to have a custom validation metho that we can
  # have any kind of Ruby code in.
  validate :no_monkey

  after_initialize :set_defaults
  before_save :capitalize_title

  def self.search(value)
    # thing = "%#{value}%"
    # where(["title ILIKE ?" OR body ILIKE ?", thing, thing])
    search_term = "%#{value}%"
    where(["title ILIKE :term OR body ILIKE :term", {term: search_term}])
  end


  # The scope does the same as next 3 self. methods.
  # The next two lines of code do the same thing.
  scope :recent, lambda { order(:created_at).reverse_order }
  scope :recent, -> { order(:create_at).reverse_order }

  def self.recent
    order(:created_at).reverse_order
  end

  def self.ten
    limit(10)
  end

  def self.recent_ten
    recent.ten
  end

  private

  def no_monkey
    if title.present? && title.downcase.include?("monkey")
      # This will add to the errors object attached to the current object.
      # if the errors object is not an empty Hash then rails treats the
      # record as invalid.
      errors.add(:title, "Can't have monkey!")
    end
  end

  def set_defaults
    # If nil or empty, set it to 0
    self.view_count ||= 0
  end

  def capitalize_title
    self.title.capitalize!
  end

end
