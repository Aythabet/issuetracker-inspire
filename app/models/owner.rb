class Owner < ApplicationRecord
	max_paginates_per 10
	before_create { |owner| owner.name = owner.name.titleize }

	validates :name, uniqueness: true
end
