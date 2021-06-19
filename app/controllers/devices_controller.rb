class DevicesController < ApplicationController
  before_action :authenticate_user!

  def index
    @page = "devices"
    @devices = current_user.devices
  end
end
