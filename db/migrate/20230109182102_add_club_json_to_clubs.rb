class AddClubJsonToClubs < ActiveRecord::Migration[7.0]
  def change
    add_column :clubs, :club_json, :json
    change_column :clubs, :third_party_id, :string
  end
end
