class AddForeignKeysToDailyreports < ActiveRecord::Migration[7.0]
  def change
    add_reference :dailyreports, :owner, foreign_key: true
    add_reference :dailyreports, :issue, foreign_key: true
  end
end
