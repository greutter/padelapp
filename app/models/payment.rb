# == Schema Information
#
# Table name: payments
#
#  id                  :bigint           not null, primary key
#  collection_status   :string
#  external_reference  :string
#  payable_type        :string
#  payment_type        :string
#  processing_mode     :string
#  status              :string
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#  collection_id       :bigint
#  merchant_account_id :string(8)
#  merchant_order_id   :string
#  payable_id          :bigint
#  payment_id          :bigint
#  preference_id       :string
#  site_id             :string
#
# Indexes
#
#  index_payments_on_payable_type_and_payable_id  (payable_type,payable_id)
#
class Payment < ApplicationRecord
  belongs_to :payable, polymorphic: true

end
