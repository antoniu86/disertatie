class Network < ApplicationRecord
  # user
  belongs_to :user

  # devices
  has_many :devices

  # validations
  validates_length_of :name, maximum: 20 , allow_blank: true
  validates_length_of :password, maximum: 20 , allow_blank: true

  # devices

  def has_devices?
    !devices.empty?
  end
end
