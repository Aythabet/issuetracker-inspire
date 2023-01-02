class Departement < ApplicationRecord
	before_create { |departement| departement.name = departement.name.capitalize }

	validates :name, uniqueness: true
end
