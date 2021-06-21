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
  validates :network_id, presence: true

  # constants
  KEY = 10021986
  CIRCLE = [*1..10]
  SQUARE = [*11..20]
  TRIANGLE = [*21..30]

  # soil humidity

  def soil_humidity
    (humidity/50)*100
  end

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

  # key

  def self.calculate_key(circle, square, triangle)
    (((KEY * triangle) / (square * circle)) / (triangle + circle - square)).abs.to_i
  end

  def self.generate_key
    circle = CIRCLE.sample
    square = SQUARE.sample
    triangle = TRIANGLE.sample

    [circle, square, triangle, (((KEY * triangle) / (square * circle)) / (triangle + circle - square)).abs.to_i]
  end
end
