class IssueType < ApplicationRecord
  before_create { |issue_type| issue_type.name = issue_type.name.capitalize }

  validates :name, uniqueness: true
end
