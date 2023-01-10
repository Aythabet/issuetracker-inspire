class AddOwnerReferenceInIssues < ActiveRecord::Migration[7.0]
  def change
    add_reference :issues, :owner, foreign_key: true
  end
end
