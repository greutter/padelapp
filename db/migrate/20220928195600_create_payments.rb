class CreatePayments < ActiveRecord::Migration[7.0]
  def change
    create_table :payments do |t|
      t.integer :collection_id, limit: 8
      t.string :collection_status
      t.integer :payment_id, limit: 8
      t.string :status
      t.string :external_reference
      t.string :payment_type
      t.string :merchant_order_id
      t.string :preference_id
      t.string :site_id
      t.string :processing_mode
      t.string :merchant_account_id, limit: 8
      t.bigint :payable_id
      t.string :payable_type
      t.timestamps
    end
    add_index :payments, [:payable_type, :payable_id]
  end
end
