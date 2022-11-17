class CreateAvailabilities < ActiveRecord::Migration[7.0]
  def change
    create_table :availabilities do |t|
      t.string :date
      t.string :club_id
      t.integer :duration
      t.json :slots, default: {}

      t.timestamps
    end
  end
end
