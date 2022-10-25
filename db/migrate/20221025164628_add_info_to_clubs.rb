class AddInfoToClubs < ActiveRecord::Migration[7.0]
  def change
    add_column :clubs, :third_party_software, :string
    add_column :clubs, :third_party_id, :integer
    add_column :clubs, :website, :string
    add_column :clubs, :comuna, :string
    add_column :clubs, :region, :string
    add_column :clubs, :city, :string
    add_column :clubs, :latitude, :integer
    add_column :clubs, :longitude, :integer
  end
end
