class Book < ActiveRecord::Base
  has_and_belongs_to_many :authors

  MIN_YEAR = 1945
  MAX_YEAR = Time.now.year

  validates :name, presence: true
  validates :year, numericality: { only_integer: true,
                                   greater_than_or_equal_to: MIN_YEAR,
                                   less_than_or_equal_to: MAX_YEAR }

  before_save :set_first_letter

  private

  def set_first_letter
    self.first_letter = name.first
  end
end
