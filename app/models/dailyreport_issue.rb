class DailyreportIssue < ApplicationRecord
  belongs_to :dailyreport
  belongs_to :issue
end
