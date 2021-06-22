class DeviceController < ApplicationController
  before_action :authenticate_user!
  before_action :common

  # show

  def show
    device

    @logs = @device.logs.order('id desc').paginate(page: params[:page])
    @logs_count = @device.logs.count
  end

  # add

  def add
    if params[:error]
      @exception = params[:error]
    end
  end

  def create
    params.permit!

    begin
      params[:device][:network_id]
      Device.create!({user_id: current_user.id}.merge(params[:device]))
      redirect_to '/devices'
    rescue => exception
      params[:action] = 'add'
      params.delete(:authenticity_token)
      redirect_to params.merge(error: exception.message)
    end
  end

  # edit

  def edit
    if params[:error]
      @exception = params[:error]
    end

    unless device
      redirect_to controller: 'devices', action: nil
    end
  end

  def save
    params.permit!

    begin
      device.update(params[:device])
      redirect_to '/devices'
    rescue => exception
      params[:action] = 'edit'
      params.delete(:authenticity_token)
      redirect_to params.merge(error: exception.message)
    end
  end

  # delete

  def delete
    device.destroy
    redirect_to '/devices'
  end

  # water

  def mark_to_water
    device.mark_to_water
    redirect_to '/devices'
  end

  def unmark_to_water
    device.unmark_to_water
    redirect_to '/devices'
  end

  protected

  def common
    @page = "devices"
  end

  def device
    @device = current_user.devices.where(id: params[:id]).first
  end
end
