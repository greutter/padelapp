class CreateSchedules < ActiveRecord::Migration[7.0]
  def change
    create_table :schedules do |t|
      t.integer :club_id
      t.datetime :opens_at
      t.datetime :closes_at
      t.string :tipo
      t.integer :day_of_week
      t.timestamps
    end
  end
end
