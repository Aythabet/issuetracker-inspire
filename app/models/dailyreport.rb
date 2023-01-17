class Dailyreport < ApplicationRecord
  max_paginates_per 10
  belongs_to :owner
  has_many :dailyreport_issues
  has_many :issues, through: :dailyreport_issues
  accepts_nested_attributes_for :issues, allow_destroy: true
end
