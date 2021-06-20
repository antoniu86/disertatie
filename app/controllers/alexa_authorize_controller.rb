class AlexaAuthorizeController < ApplicationController
  layout "alexa"

  skip_before_action :verify_authenticity_token

  before_action :log_request

  ALEXA_CLIENT_ID = 'alexa-waterplanto'
  ALEXA_CLIENT_SECRET = '24b1bd5936bcd79d3028fbe1e971e4dfa579355140f4fbca10edd00a4d669d11'
  ALEXA_REDIRECTS = ['https://layla.amazon.com/api/skill/link/MU4E509H35JT0', 'https://alexa.amazon.co.jp/api/skill/link/MU4E509H35JT0', 'https://pitangui.amazon.com/api/skill/link/MU4E509H35JT0']

  # SSO

  def login
    unless check_client? && check_redirect_uri?
      render nothing: true, status: :bad_request
      return
    end

    if params[:alexa_login_key]
      if (key = AlexaLoginKey.where(login_key: params[:alexa_login_key]).first)
        if key.expired?
          @error = expired
        else
          @user = key.user
          @form_options = {action: 'grant'}
        end
      else
        @error = invalid
      end
    end

    render template: 'alexa_authorize/login'
  end

  def grant
    logger.info "token: params: #{params.inspect}"

    unless check_client? && check_redirect_uri?
      logger.info "token: bad request"
      render nothing: true, status: :bad_request
      return
    end

    if params[:response_type].to_sym == :code
      if (user = User.where(id: params[:user_id]).first)
        query_values = {
          code: user.create_authentication_code,
          state: params[:state]
        }

        url = Addressable::URI.parse params[:redirect_uri]
        url.query_values = (url.query_values || {}).merge(query_values)

        user.invalidate_alexa_login_key

        redirect_to(url.to_s, status: 302)
      else
        logger.info "token: bad request"
        render nothing: true, status: :bad_request
      end
    else
      logger.info "token: unauthorized"
      render nothing: true, status: :unauthorized
    end
  end

  def token
    logger.info "token: params: #{params.inspect}"

    unless check_client? && check_redirect_uri? && check_code?
      logger.info "token: bad request"
      render nothing: true, status: :bad_request
      return
    end

    if params[:grant_type] == 'authorization_code'
      access, refresh = @user.create_access_and_refresh_tokens

      response = {
        token_type: 'bearer',
        access_token: access
      }

      render json: response.to_json, status: :ok
    elsif params[:grant_type] == 'refresh_token'
      # we will see
      render nothing: true, status: :bad_request
    else
      render nothing: true, status: :bad_request
    end
  end

  private

  def log_request
    logger.info "request params: #{params.inspect}"
  end

  def check_client?
    params[:client_id] == ALEXA_CLIENT_ID
  end

  def check_redirect_uri?
    ALEXA_REDIRECTS.include? params[:redirect_uri]
  end

  def check_code?
    if (params[:code] && (alexa_token = AlexaToken.where(authentication: params[:code]).first))
      @user = alexa_token.user
      true
    else
      false
    end
  end

  def expired
    'Key expired. Please generate a new one in your Neo LMS profile settings page.'
  end

  def invalid
    'Please enter a valid key or generate one in your Neo LMS profile settings page.'
  end
end
