class LogsController < ApplicationController
  before_action :authenticate_user!

  def index
    @page = "logs"
  end
end
