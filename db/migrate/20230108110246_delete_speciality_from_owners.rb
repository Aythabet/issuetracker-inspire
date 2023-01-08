class DeleteSpecialityFromOwners < ActiveRecord::Migration[7.0]
  def change
    remove_column :owners, :speciality
  end
end
