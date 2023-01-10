class DeleteDepartementOwnerForeignKey < ActiveRecord::Migration[7.0]
  def change
    remove_foreign_key :departements, :owners
    remove_foreign_key :owners, :departements
  end
end
