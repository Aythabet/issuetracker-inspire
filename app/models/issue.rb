class Issue < ApplicationRecord
  belongs_to :project
  belongs_to :owner
  has_many :dailyreport_issues, dependent: :destroy
  has_many :dailyreports, through: :dailyreport_issues
  max_paginates_per 10

  before_create { |issue| issue.jiraid = issue.jiraid.upcase }

  validates :jiraid, format: { with: /\b[a-zA-Z]{2,6}-[1-9]\d{0,3}\b/, message: 'must follow this format ABCXYZ-9999' }
  validates :jiraid, uniqueness: true
  validates :jiraid, :project, :owner, :time_forecast, :time_real, presence: true

  validates :time_real, numericality: { only_float: true }
  validates :time_forecast, numericality: { only_float: true }
end
