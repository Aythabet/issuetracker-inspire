class AddProjectReferenceInIssues < ActiveRecord::Migration[7.0]
  def change
    add_reference :issues, :project, foreign_key: true
  end
end
