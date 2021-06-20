class AlexaLoginKey < ApplicationRecord
  # user
  belongs_to :user

  # expired

  def expired?
    (Time.now > expires_at)
  end

  # invalidate

  def invalidate
    update_attribute(:expires_at, Time.now)
  end
end
