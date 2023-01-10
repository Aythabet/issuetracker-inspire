class DeleteEmailFromOwners < ActiveRecord::Migration[7.0]
  def change
    remove_column :owners, :email
  end
end
