class Dailyreport < ApplicationRecord
  max_paginates_per 9
  belongs_to :owner
  has_many :dailyreport_issues, dependent: :destroy
  has_many :issues, through: :dailyreport_issues
  accepts_nested_attributes_for :issues, allow_destroy: true

end
