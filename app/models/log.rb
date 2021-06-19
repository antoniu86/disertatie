class Log < ApplicationRecord
  # user
  belongs_to :user

  # device
  belongs_to :device
end
