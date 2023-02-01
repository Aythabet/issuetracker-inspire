class RenameDepartementInIssues < ActiveRecord::Migration[7.0]
  def change
    rename_column :issues, :departement, :issue_type
  end
end
