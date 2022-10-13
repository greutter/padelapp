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

  validates :phone, phone: { possible: true, types: [:mobile], message: "No parece ser un teléfono movil válido"}
  validates :first_name, presence: true



  def self.from_omniauth(auth)
    user = User.find_by(provider: auth.provider, uid: auth.uid)
    return user unless user.nil?

    user = User.find_by(email: auth.info.email)
    if user
      user.provider = auth.provider
      user.uid = auth.uid
      user.set_auth_info(auth)
      return user
    else
      user = User.new(provider: auth.provider, uid: auth.uid) do |user|
        user.set_auth_info(auth)
      end
      user.save(validate: false)
      return user
    end
  end

  def set_auth_info(auth)
    self.email = auth.info.email
    self.password = Devise.friendly_token[0, 20]
    self.full_name = auth.info.name # assuming the user model has a name
    self.avatar_url = auth.info.image # assuming the user model has an image
    self.first_name = auth.info.first_name
    self.last_name = auth.info.last_name
  end

end
