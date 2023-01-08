class AddNewColumnsToOwners < ActiveRecord::Migration[7.0]
  def change
    add_column :owners, :jiraid, :string
    add_column :owners, :email, :string
    add_column :owners, :status, :string
    add_column :owners, :date_joined_jira, :string
    add_column :owners, :last_seen_on_jira, :string
  end
end
