# Load the Rails application.
require_relative 'application'

ActionMailer::Base.smtp_settings = {
  :port           => 465,
  :address        => 'mail.tonydesign.ro',
  :user_name      => 'test@tonydesign.ro',
  :password       => 'fFg0%0d$zj2F',
  :domain         => 'waterplanto.heroku.com',
  :authentication => :plain,
}
ActionMailer::Base.delivery_method = :smtp

# Initialize the Rails application.
Rails.application.initialize!
