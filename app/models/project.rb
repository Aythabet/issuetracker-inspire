class Project < ApplicationRecord
	before_create { |project| project.jiraid = project.jiraid.upcase }
	before_create { |project| project.name = project.name.titleize }

	validates :jiraid, :name, uniqueness: true
  	validates :jiraid, format: { with:/\A[a-zA-Z\d]{2,4}\z/, message: "must follow this format az-AZ" }

end
