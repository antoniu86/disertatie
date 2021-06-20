class AlexaApiController < ApplicationController
  layout false

  skip_before_action :verify_authenticity_token

  # filters
  before_action :log_request
  before_action :validate_request

  # get - check plants

  def check_plants
    devices = @user.devices
    list = []
    count = 0

    if devices.empty?
      render json: {count: count}, status: :ok
    else
      devices.each do |device|
        list << "Device name: #{device.name}, has soil humidity of #{device.soil_humidity}%; "
        count = count + 1
      end

      render json: {count: count, list: list}, status: :ok
    end
  end

  # post - check plant

  def check_plant
    params.permit!

    unless device_name = params[:slots][:name]
      render json: {status: false, message: 'Missing parameter on request'}, status: :ok
    else
      unless device = @user.devices.where(name: device_name).first
        render json: {status: false, message: "No device found with the name: #{device_name}"}, status: :ok
      else
        render json: {status: true, message: "Device name: #{device.name}, has soil humidity of #{device.soil_humidity}%"}, status: :ok
      end
    end
  end

  # post - water plant

  def water_plant
    params.permit!

    unless device_name = params[:slots][:name]
      render json: {status: false, message: 'Missing parameter on request'}, status: :ok
    else
      unless device = @user.devices.where(name: device_name).first
        render json: {status: false, message: "No device found with the name: #{device_name}"}, status: :ok
      else
        device.mark_to_water

        render json: {status: true, message: "We will water your plant soon"}, status: :ok
      end
    end
  end

  protected

  # validate the request

  def validate_request
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