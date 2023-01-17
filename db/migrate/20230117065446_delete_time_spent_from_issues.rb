class DeleteTimeSpentFromIssues < ActiveRecord::Migration[7.0]
  def change
    remove_column :issues, :time_spent
  end
end
