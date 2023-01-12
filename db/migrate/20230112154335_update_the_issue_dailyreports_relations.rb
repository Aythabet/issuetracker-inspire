class UpdateTheIssueDailyreportsRelations < ActiveRecord::Migration[7.0]
  def change
    remove_foreign_key :dailyreports, :issues
    remove_foreign_key :issues, :dailyreports
  end
end
