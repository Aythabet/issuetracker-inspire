class DropProjectTable < ActiveRecord::Migration[7.0]
  def change
    remove_column :issues, :project
  end
end
