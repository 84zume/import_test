class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
         #内田追記
         :omniauthable, omniauth_providers: [:fitbit_oauth2]
  def self.from_omniauth(auth)
  where(provider: auth.provider, uid: auth.uid).first_or_create do |user|
    if auth.provider == 'fitbit_oauth2'
      user.email = "#{auth.uid}@fitbit.com"
    else
      user.email = auth.info.email
    end
    user.password = Devise.friendly_token[0,20]
    # user.name = auth.info.name   # assuming the user model has a name
    # user.image = auth.info.image # assuming the user model has an image
  end
end

end
