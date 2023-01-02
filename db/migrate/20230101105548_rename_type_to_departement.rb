class RenameTypeToDepartement < ActiveRecord::Migration[7.0]
  def self.up
    rename_column :issues, :type, :departement
  end
end
