class User < ApplicationRecord
  # devise modules
  devise :database_authenticatable
  devise :registerable
  devise :recoverable
  devise :rememberable
  devise :validatable
  devise :timeoutable, :timeout_in => 30.minutes

  # devices
  has_many :devices, dependent: :destroy

  # networks
  has_many :networks, dependent: :destroy

  # logs
  has_many :logs, dependent: :delete_all

  # alexa
  has_one :alexa_login_key, :dependent => :delete
  has_one :alexa_token, :dependent => :delete

  # name

  def full_name
    first_name + " " + last_name
  end

  # booleans

  def has_devices?
    !devices.empty?
  end

  def has_networks?
    !networks.empty?
  end

  # ALEXA

  # login key

  def get_alexa_login_key
    if (alexa_login_key && !alexa_login_key.expired?)
      alexa_login_key.login_key
    end
  end

  def generate_alexa_login_key
    expires_at = Time.now + (60 * 30) # expires in 1 hour
    max_tries = 50
    tries = 0
    token = nil

    while (token.nil? && tries < max_tries)
      tries += 1
      key = SecureRandom.hex(3).upcase

      begin
        if alexa_login_key
          alexa_login_key.update_attributes(login_key: key, expires_at: expires_at)
        else
          AlexaLoginKey.create!(user_id: id, login_key: key, expires_at: expires_at)
        end

        token = key
      rescue => exception
        # a duplicate mysql error will be raised which means that the key is not unique
        # stay in loop
      end
    end

    token
  end

  def invalidate_alexa_login_key
    if alexa_login_key
      alexa_login_key.invalidate
    end
  end

  # tokens

  def create_authentication_code
    if alexa_token
      alexa_token.delete
    end

    token = generate_token
    AlexaToken.create!(user_id: id, authentication: token)
    token
  end

  def create_access_and_refresh_tokens
    access = generate_token
    refresh = generate_token

    alexa_token.update_attributes(access: access, refresh: refresh)

    [access, refresh]
  end

  def generate_token
    SecureRandom.base64(64)
  end
end
