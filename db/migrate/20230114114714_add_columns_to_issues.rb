class AddColumnsToIssues < ActiveRecord::Migration[7.0]
  def change
    add_column :issues, :status, :string
    add_column :issues, :time_spent, :string
  end
end
