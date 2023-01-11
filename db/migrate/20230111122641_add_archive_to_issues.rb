class AddArchiveToIssues < ActiveRecord::Migration[7.0]
  def change
    remove_column :issues, :archive
    add_column :issues, :archive, :boolean, default: false
  end
end
