class AddDepartementToOwnersTable < ActiveRecord::Migration[7.0]
  def change
    add_column :owners, :departement, :string
  end
end
