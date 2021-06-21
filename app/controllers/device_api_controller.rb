class DeviceApiController < ApplicationController
  layout false

  skip_before_action :verify_authenticity_token

  # filters
  before_action :log_request
  before_action :validate_request

  def update
    unless @valid_key
      #close_database_connection
      render json: {status: -2}.to_json, status: :ok
      return
    end

    unless (device = Device.where(code: params[:code]).first)
      Log.create(user_id: 0, device_id: 0, content: {code: params[:code], message: 'no device registered with this code'}.to_json)
      close_database_connection
      render json: {status: 0}.to_json, status: :ok
    else
      humidity = params[:humidity] || 0
      level = params[:level] || 0
      temperature = params[:temperature] || 0

      updates = {humidity: humidity, level: level, temperature: temperature, water: false}

      ci, sq, tr, key = Device.generate_key

      to_water = device.marked_to_water?

      Log.create(user_id: device.user_id, device_id: device.id, content: {code: params[:code], humidity: humidity, level: level, temperature: temperature}.to_json)

      if to_water
        updates[:watered_at] = Time.now
      end

      if device.update(updates)
        close_database_connection
        render json: {status: 1, ci: ci, sq: sq, tr: tr, key: key, netname: device.network.name, netpass: device.network.password, water: to_water, limit: device.water_at}.to_json, status: :ok
      else
        close_database_connection
        render json: {status: -1}.to_json, status: :ok
      end
    end
  end

  protected

  # validate the request

  def validate_request
    @valid_key = false

    logger.info "Token header: #{request.headers['Token'].inspect}"

    if ((authorization = request.headers['Token']) && authorization.include?('Key'))
      key = request.headers['Token'].gsub('Key ', '')
      logger.info "Request key: #{key}"

      calculated = Device.calculate_key(params[:ci].to_i, params[:sq].to_i, params[:tr].to_i)

      logger.info "Calculated key: #{calculated}"

      unless (calculated == key.to_i)
        @valid_key = true
      end
    end
  end

  # log each request

  def log_request
    logger.info "request params: #{params.inspect}"
  end

  # close database connection

  def close_database_connection
    logger.info "Closing DB connection"
    ActiveRecord::Base.connection.close
  end
end
