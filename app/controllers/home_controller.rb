class HomeController < ApplicationController
  before_action :check_login

  protected

  def check_login
    unless user_signed_in?
      redirect_to "/users/sign_in"
    end
  end
end
