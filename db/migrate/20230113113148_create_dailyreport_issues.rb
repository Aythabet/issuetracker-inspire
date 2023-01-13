class CreateDailyreportIssues < ActiveRecord::Migration[7.0]
  def change
    create_table :dailyreport_issues do |t|
      t.references :dailyreport, null: false, foreign_key: true
      t.references :issue, null: false, foreign_key: true

      t.timestamps
    end
  end
end
