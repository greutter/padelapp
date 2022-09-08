class CreateCourts < ActiveRecord::Migration[7.0]
  def change
    create_table :courts do |t|
      t.integer :club_id
      t.integer :number

      t.timestamps
    end
  end
end
