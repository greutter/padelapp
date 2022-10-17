class AddPhoneToClubs < ActiveRecord::Migration[7.0]
  def change
    add_column :clubs, :phone, :string
  end
end
