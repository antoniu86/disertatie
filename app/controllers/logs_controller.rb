class LogsController < ApplicationController
  before_action :authenticate_user!

  def index
    @page = "logs"

    @logs = current_user.logs.order('id desc').paginate(page: params[:page])
    @logs_count = current_user.logs.count
  end
end
