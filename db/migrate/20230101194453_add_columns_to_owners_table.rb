class AddColumnsToOwnersTable < ActiveRecord::Migration[7.0]
  def change
    add_column :owners, :speciality, :string
  end
end
