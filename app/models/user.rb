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
end
