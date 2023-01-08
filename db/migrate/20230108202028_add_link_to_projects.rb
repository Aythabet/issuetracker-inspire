class AddLinkToProjects < ActiveRecord::Migration[7.0]
  def change
    add_column :projects, :link, :string
  end
end
