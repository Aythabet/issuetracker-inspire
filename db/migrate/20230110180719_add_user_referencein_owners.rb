class AddUserReferenceinOwners < ActiveRecord::Migration[7.0]
  def change
    add_reference :owners, :user, foreign_key: true
  end
end
