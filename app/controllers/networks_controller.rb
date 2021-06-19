class NetworksController < ApplicationController
  before_action :authenticate_user!

  def index
    @page = "networks"
    @networks = current_user.networks
  end
end
