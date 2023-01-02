class Issue < ApplicationRecord
	before_create { |issue| issue.jiraid = issue.jiraid.upcase }

	validates :jiraid, uniqueness: true

	validates :jiraid, :project, :owner, :departement, :time_forecast, :time_real, presence: true
  	validates :jiraid, format: { with: /\b[a-zA-Z]{2,4}-[1-9]\d{0,3}\b/, message: "must follow this format AAAA-9999" }

  	validates :time_real, numericality: { only_float: true }
  	validates :time_forecast, numericality: { only_float: true }
end
