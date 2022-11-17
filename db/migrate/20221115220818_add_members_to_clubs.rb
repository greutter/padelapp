class AddMembersToClubs < ActiveRecord::Migration[7.0]
  def change
    add_column :clubs, :members_only, :boolean
  end
end
