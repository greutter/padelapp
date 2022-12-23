class AddActiveToCourts < ActiveRecord::Migration[7.0]
  def change
    add_column :courts, :active, :boolean
  end
end
