# Load the Rails application.
require_relative 'application'

ActionMailer::Base.smtp_settings = {
  :port           => 587,
  :address        => 'smtp.mailgun.org',
  :user_name      => 'postmaster@sandbox26fb8ed5edd543eaa39b46b0aa172029.mailgun.org',
  :password       => 'dff60577e52a7c129299c7e2e4c6d77e-24e2ac64-ae8a8af9',
  :domain         => 'waterplanto.heroku.com',
  :authentication => :plain,
}
ActionMailer::Base.delivery_method = :smtp

# Initialize the Rails application.
Rails.application.initialize!
