class ChangeColumnsTypeInIssuesTable < ActiveRecord::Migration[7.0]
  def change
      change_column :issues, :time_forecast, :float
      change_column :issues, :time_real, :float
  end
end
