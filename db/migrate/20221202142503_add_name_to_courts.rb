class AddNameToCourts < ActiveRecord::Migration[7.0]
  def change
    add_column :courts, :name, :string
  end
end
