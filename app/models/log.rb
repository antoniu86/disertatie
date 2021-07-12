class Log < ApplicationRecord
  # user
  belongs_to :user

  # device
  belongs_to :device

  # pagination
  self.per_page = 30
end
