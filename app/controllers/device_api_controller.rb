class DeviceApiController < ApplicationController
  layout false

  skip_before_action :verify_authenticity_token

  # filters
  before_action :log_request
  before_action :validate_request

  after_action :log_after_action

  def update
    @user_id = 0
    @device_id = 0
    @received = {params: params}

    unless @valid_key
      @sent = {code: params[:code], message: 'Invalid key'}
      render json: {status: -2}, status: :ok
      return
    end

    unless (device = Device.where(code: params[:code]).first)
      @sent = {status: 0, message: "Device does not exist in the system."}
      render json: @sent, status: :ok
    else
      @user_id = device.user_id
      @device_id = device.id

      soil = params[:soil] || 0
      temperature = params[:temperature] || 0
      humidity = params[:humidity] || 0
      level = params[:level] || 0 # not having this sensor yet, but ready for when data is received

      updates = {status: true, soil: soil, temperature: temperature, humidity: humidity, water: false, level: level}

      ci, sq, tr, key = Device.generate_key

      start_pomp = device.marked_to_water?

      @received[:data] = {code: params[:code], soil: soil, temperature: temperature, humidity: humidity, level: level}

      if start_pomp
        updates[:watered_at] = Time.now
      end

      if device.update(updates)
        @sent = {status: 1, ci: ci, sq: sq, tr: tr, key: key, netname: device.network.name, netpass: device.network.password, pomp: start_pomp, duration: device.duration, limit: device.water_at}
        render json: @sent, status: :ok
      else
        @sent = {status: -1, message: "Device update failed"}
        render json: @sent, status: :ok
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

      if (calculated == key.to_i)
        @valid_key = true
      end
    end
  end

  # log each request

  def log_request
    logger.info "request params: #{params.inspect}"
  end

  # log

  def log_after_action
    logger.info "create log entry"
    Log.create(user_id: @user_id, device_id: @device_id, content: {received: @received, sent: @sent}.to_json)
  end
end
