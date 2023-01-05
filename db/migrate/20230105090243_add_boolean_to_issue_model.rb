class AddBooleanToIssueModel < ActiveRecord::Migration[7.0]
  def change
    add_column :issues, :retour_test, :boolean
  end
end
