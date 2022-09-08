class CreateCourts < ActiveRecord::Migration[7.0]
  def change
    create_table :courts do |t|

      t.timestamps
    end
  end
end
