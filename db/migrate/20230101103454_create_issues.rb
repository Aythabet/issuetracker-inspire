class CreateIssues < ActiveRecord::Migration[7.0]
  def change
    create_table :issues do |t|
      t.string :jiraid
      t.string :project
      t.string :owner
      t.string :time_forecast
      t.string :time_real
      t.string :type

      t.timestamps
    end
  end
end
