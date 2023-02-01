class RenameDepatementsToIssueTypes < ActiveRecord::Migration[7.0]
  def change
    rename_table :departements, :issue_types
  end
end
