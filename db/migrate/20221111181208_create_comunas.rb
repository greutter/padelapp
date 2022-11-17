class CreateComunas < ActiveRecord::Migration[7.0]
  def change
    create_table :comunas do |t|
      t.string :name
      t.string :region
      t.integer :region_north_to_south_ordering
      t.string :sector
      t.timestamps
    end
  end
end
