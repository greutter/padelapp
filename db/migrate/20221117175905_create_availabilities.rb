class CreateAvailabilities < ActiveRecord::Migration[7.0]
  def change
    create_table :availabilities do |t|
      t.string :query
      t.json :results, default: {}

      t.timestamps
    end
  end
end
