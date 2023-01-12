class AddArchiveToIssues < ActiveRecord::Migration[7.0]
  def change
    add_column :issues, :archive, :boolean, default: false
  end
end
