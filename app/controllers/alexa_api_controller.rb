class AlexaApiController < ApplicationController
  layout false

  skip_before_action :verify_authenticity_token

  # filters
  before_action :log_request
  before_action :validate_request

  # get

  def check_plants
    devices = @user.devices
    list = []
    count = 0

    if devices.empty?
      render json: {count: count}, status: :ok
    else
      devices.each do |device|
        list << "Device name: #{device.name}, has soil humidity of #{device.soil_humidity}%"
      end

      render json: {count: count, list: list}, status: :ok
    end
  end

  protected

  # validate the request

  def validate_request
    logger.info "Request headers: #{request.headers.inspect}"

    if ((authorization = request.headers['Authorization']) && authorization.include?('Bearer'))
      token = request.headers['Authorization'].gsub('Bearer ', '')
      logger.info "Request token: #{token}"

      if (alexa_token = AlexaToken.where(access: token).first)
        @user = alexa_token.user
      end
    end
  end

  # log each request

  def log_request
    logger.info "request params: #{params.inspect}"
  end
end