class AddEmailToClubs < ActiveRecord::Migration[7.0]
  def change
    add_column :clubs, :email, :string
  end
end
