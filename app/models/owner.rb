class Owner < ApplicationRecord
  has_many :issues
  max_paginates_per 10
  before_create { |owner| owner.name = owner.name.titleize }

  validates :name, uniqueness: true, presence: true
  validates :email, uniqueness: true, presence: true
end
