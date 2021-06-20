require 'bcrypt'

class AccountController < ApplicationController
  before_action :authenticate_user!

  skip_before_action :verify_authenticity_token

  # edit

  def edit
    if params[:error]
      @exception = params[:error]
    end
  end

  # save

  def save
    params.permit!

    begin
      current_user.update(params[:user])
      redirect_to '/account'
    rescue => exception
      params[:action] = 'edit'
      params.delete(:authenticity_token)
      redirect_to params.merge(error: exception.message)
    end
  end

  # password

  def change_password
    params.permit!

    pepper = nil
    stretches = 12

    begin
      unless (params[:user][:password] == params[:user][:password_confirmation])
        render json: {error: "Passwords do not match"}, status: :ok
        return
      end

      encrypted_password = ::BCrypt::Engine.hash_secret([params[:user][:password], pepper].join, ::BCrypt::Engine.generate_salt(stretches), stretches)
      current_user.update(encrypted_password: encrypted_password)

      render json: {success: true}, status: :ok
    rescue => exception
      render json: {error: exception.message}, status: :ok
    end
  end

  # public profile

  def public_profile
    params.permit!

    begin
      current_user.update(params[:user])
      render json: {success: true}, status: :ok
    rescue
      render json: {error: 'The username is not unique. Please try a new one.'}, status: :ok
    end
  end

  # alexa

  def generate_alexa_key
    current_user.generate_alexa_login_key
    redirect_to '/account'
  end

  # delete

  def delete
    current_user.destroy
    redirect_to "/?account_deleted"
  end
end
