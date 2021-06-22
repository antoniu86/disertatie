class NetworkController < ApplicationController
  before_action :authenticate_user!
  before_action :common

  # show

  def show
    network
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
      Network.create!({user_id: current_user.id}.merge(params[:network]))
      redirect_to '/networks'
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

    unless network
      redirect_to controller: 'networks', action: nil
    end
  end

  def save
    params.permit!

    begin
      network.update_attributes(params[:network])
      redirect_to '/networks'
    rescue => exception
      params[:action] = 'edit'
      params.delete(:authenticity_token)
      redirect_to params.merge(error: exception.message)
    end
  end

  # delete

  def delete
    network.destroy
    redirect_to '/networks'
  end

  protected

  def common
    @page = "networks"
  end

  def network
    @network = current_user.networks.where(id: params[:id]).first
  end
end
