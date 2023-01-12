class DeleteDailyreportsForeignKey < ActiveRecord::Migration[7.0]
  def change
    remove_foreign_key :dailyreports, :owners
    remove_column :dailyreports, :issue_id
  end
end
