# == Schema Information
#
# Table name: users
#
#  id                     :bigint           not null, primary key
#  avatar_url             :string
#  current_sign_in_at     :datetime
#  current_sign_in_ip     :string
#  email                  :string           default(""), not null
#  encrypted_password     :string           default(""), not null
#  first_name             :string
#  full_name              :string
#  last_name              :string
#  last_sign_in_at        :datetime
#  last_sign_in_ip        :string
#  phone                  :string
#  provider               :string
#  remember_created_at    :datetime
#  reset_password_sent_at :datetime
#  reset_password_token   :string
#  sign_in_count          :integer          default(0), not null
#  uid                    :string
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#
# Indexes
#
#  index_users_on_email                 (email) UNIQUE
#  index_users_on_reset_password_token  (reset_password_token) UNIQUE
#
class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable

  has_many :reservations
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, :trackable,
          :omniauthable, omniauth_providers: [:google_oauth2]

  # validates :attribute, phone: { possible: true, types: [:mobile] }

  devise :database_authenticatable, :registerable,
       :recoverable, :rememberable, :validatable,
       # for Google OmniAuth
       :omniauthable, omniauth_providers: [:google_oauth2]

def self.from_omniauth(auth)
  where(provider: auth.provider, uid: auth.uid).first_or_create do |user|
    user.email = auth.info.email
    user.password = Devise.friendly_token[0, 20]
    user.full_name = auth.info.name # assuming the user model has a name
    user.avatar_url = auth.info.image # assuming the user model has an image
    user.first_name = auth.info.first_name
    user.last_name = auth.info.last_name
  end
end

end
