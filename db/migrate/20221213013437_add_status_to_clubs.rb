class AddStatusToClubs < ActiveRecord::Migration[7.0]
  def change
    add_column :clubs, :active, :boolean
  end
end
