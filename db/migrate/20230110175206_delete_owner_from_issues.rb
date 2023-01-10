class DeleteOwnerFromIssues < ActiveRecord::Migration[7.0]
  def change
    remove_column :issues, :owner
  end
end
