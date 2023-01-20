class RenameLinkColumnInProjectsTable < ActiveRecord::Migration[7.0]
  def change
    rename_column :projects, :link, :lead
  end
end
