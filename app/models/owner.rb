class Owner < ApplicationRecord
	before_create { |owner| owner.name = owner.name.titleize }

	validates :name, uniqueness: true
end
