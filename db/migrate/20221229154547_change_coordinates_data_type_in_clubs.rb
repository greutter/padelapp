class ChangeCoordinatesDataTypeInClubs < ActiveRecord::Migration[7.0]
  def change
    change_column :clubs, :latitude, :decimal
    change_column :clubs, :longitude, :decimal
  end
end
