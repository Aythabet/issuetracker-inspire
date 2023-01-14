class DeleteArchiveColumnFromIssues < ActiveRecord::Migration[7.0]
  def change
    remove_column :issues, :archive
  end
end
