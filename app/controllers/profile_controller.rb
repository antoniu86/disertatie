class ProfileController < ApplicationController
  # profile page

  def profile
    username = params[:username]

    unless (@user = User.where(username: username, public_profile: true).first)
      redirect_to '/'
      return
    end

    @devices = @user.devices#.where(status: 1)
  end
end
