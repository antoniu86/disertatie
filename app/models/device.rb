class Device < ApplicationRecord
  # user
  belongs_to :user

  # network
  belongs_to :network

  # logs
  has_many :logs

  # validations
  validates :name, presence: true
  validates :code, presence: true, length: { is: 12 }
  validates :water_at, numericality: { greater_than_or_equal_to: 10, less_than_or_equal_to: 40 }
  validates :network_id, presence: true

  # check connected

  def connected?
    status == 1
  end

  # marked to water

  def marked_to_water?
    water
  end

  # water

  def mark_to_water
    update(water: true)
  end

  def unmark_to_water
    update(water: false)
  end

  # has logs

  def has_logs?
    !logs.empty?
  end
end
