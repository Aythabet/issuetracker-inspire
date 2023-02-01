class DeleteDepartementFromOwners < ActiveRecord::Migration[7.0]
  def change
    remove_column :owners, :departement
  end
end
