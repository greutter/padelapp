class CreateReservations < ActiveRecord::Migration[7.0]
  def change
    create_table :reservations do |t|
      t.integer :user_id
      t.integer :court_id
      t.datetime :starts_at
      t.datetime :ends_at

      t.timestamps
    end
  end
end
