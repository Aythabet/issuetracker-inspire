class CreateDailyreports < ActiveRecord::Migration[7.0]
  def change
    create_table :dailyreports do |t|
      t.text :comment

      t.timestamps
    end
  end
end
