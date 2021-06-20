class HomeController < ApplicationController
  def index
    if user_signed_in?
      redirect_to '/devices'
    else
      render layout: false
    end
  end
end
