class Network < ApplicationRecord
  # user
  belongs_to :user

  # devices
  has_many :devices

  # validations
  validates :name, presence: true
  validates_length_of :ssid, maximum: 20
  validates_length_of :password, maximum: 20

  # devices

  def has_devices?
    !devices.empty?
  end
end
