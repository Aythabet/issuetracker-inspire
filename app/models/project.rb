class Project < ApplicationRecord
  has_many :issues

  before_create { |project| project.jiraid = project.jiraid.upcase }
  before_create { |project| project.name = project.name.titleize }

  validates :jiraid, :name, uniqueness: true
  validates :jiraid, format: { with:/\A[a-zA-Z\d]{2,6}\z/, message: "must follow this format az-AZ" }
end
