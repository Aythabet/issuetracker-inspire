class AddIssuesForeignKeyToDailyreport < ActiveRecord::Migration[7.0]
  def change
    add_reference :issues, :dailyreports, foreign_key: true

  end
end
