class HomeController < ApplicationController
  before_action :check_login

  protected

  def check_login
    unless user_signed_in?
      redirect_to "/login"
    end
  end
end
