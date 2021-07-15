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
        message = "Device name: #{device.name}, has soil humidity of #{device.soil_humidity}%, room temperature of #{device.temperature} celsius degrees, room humidity of #{device.humidity}%, "

        if device.watered_at
          message = message + " the device last watered at #{device.watered_at.strftime("%d %B %Y at %H:%M")}; "
        else
          message = message + " the device was never started; "
        end

        list << message

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
        message = "Device name: #{device.name}, has soil humidity of #{device.soil_humidity}%, room temperature of #{device.temperature} celsius degrees, room humidity if #{device.humidity}%, "

        if device.watered_at
          message = message + " the device last watered at #{device.watered_at.strftime("%d %B %Y at %H:%M")}"
        else
          message = message + " the device was never started"
        end

        render json: {status: true, message: message}, status: :ok
      end
    end
  end

  # post - check plant description

  def check_plant_description
    params.permit!

    unless device_name = params[:slots][:name]
      render json: {status: false, message: 'Missing parameter on request'}, status: :ok
    else
      unless device = @user.devices.where(name: device_name).first
        render json: {status: false, message: "No device found with the name: #{device_name}"}, status: :ok
      else
        message = (device.description.empty? ? "The device #{device_name} has no description" : "The device description is: #{device.description}")
        render json: {status: true, message: message}, status: :ok
      end
    end
  end

  # post - check plant settings

  def check_plant_settings
    params.permit!

    unless device_name = params[:slots][:name]
      render json: {status: false, message: 'Missing parameter on request'}, status: :ok
    else
      unless device = @user.devices.where(name: device_name).first
        render json: {status: false, message: "No device found with the name: #{device_name}"}, status: :ok
      else
        message = "Device name: #{device.name}; Settings: minimum soil humidity set to be #{device.soil_humidity}%, pomp set to run for #{device.duration} seconds"
        render json: {status: true, message: message}, status: :ok
      end
    end
  end

  # post - set plant minimum humidity

  def set_plant_humidity
    params.permit!

    unless ((device_name = params[:slots][:name]) && (device_water_at = params[:slots][:water_at].to_i))
      render json: {status: false, message: 'Missing parameter on request'}, status: :ok
    else
      unless device = @user.devices.where(name: device_name).first
        render json: {status: false, message: "No device found with the name: #{device_name}"}, status: :ok
      else
        if device_water_at > 50
          render json: {status: false, message: "You cannot have a higher value than 50%"}, status: :ok
        else
          device.update(water_at: device_water_at)
          render json: {status: true, message: "The minimum level of soil humidity was changed to #{device_water_at}% for #{device_name}"}, status: :ok
        end
      end
    end
  end

  # post - set plant pomp running duration

  def set_plant_duration
    params.permit!

    unless ((device_name = params[:slots][:name]) && (pomp_duration = params[:slots][:duration].to_i))
      render json: {status: false, message: 'Missing parameter on request'}, status: :ok
    else
      unless device = @user.devices.where(name: device_name).first
        render json: {status: false, message: "No device found with the name: #{device_name}"}, status: :ok
      else
        if pomp_duration > 10
          render json: {status: false, message: "You cannot have a higher value than 10 seconds"}, status: :ok
        else
          device.update(duration: pomp_duration)
          render json: {status: true, message: "The pomp running duration was changed to #{pomp_duration} seconds for #{device_name}"}, status: :ok
        end
      end
    end
  end

  # get - water plants

  def water_plants
    devices = @user.devices
    count = 0

    if devices.empty?
      render json: {status: false, message: "There are no devices"}, status: :ok
    else
      devices.each do |device|
        device.mark_to_water
        count = count + 1
      end

      render json: {status: true, message: "#{count} devices will water the plants shortly"}, status: :ok
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

    unless @user
      render nothing: true, status: :unauthorized
      return
    end
  end

  # log each request

  def log_request
    logger.info "request params: #{params.inspect}"
  end
end