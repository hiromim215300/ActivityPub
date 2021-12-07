require 'json'
require 'openssl'
require 'time'
require 'uri'
require 'net/http'

class ApplicationController < ActionController::Base
  include Pundit

  before_action :configure_permitted_parameters, if: :devise_controller?
#  skip_before_action :verify_authenticity_token, if: :json_request?

  rescue_from ActiveRecord::RecordNotFound, with: :error_not_found
  rescue_from ActionController::InvalidAuthenticityToken, with: :error_csrf
  rescue_from ActionController::ParameterMissing, with: :error_unprocessable
  rescue_from Pundit::NotAuthorizedError, with: :error_not_authorized

  def get_inbox(req)
    puts req
    res = HTTP[accept: 'application/activity+json'].get(req)
    JSON.parse(res)
  end

  def post_inbox(req, res, headers)
    puts req, res
    HTTP[headers].post(req, json: res)
  end

  def tweet(str_name, str_host, x)
    str_inbox = "https://192.168.2.101:3000/actors/1/inbox"
    res = ApplicationController.renderer.new.render(
      template: 'federation/activities/show',
      locals:   { :@activity => activity },
      format:   :json
    )
    headers = "https://192.168.2.101:3000/actors/1/inbox"
    post_inbox(str_inbox, res, headers)
      
  end

  def apipost(data)

    uri = URI.parse("https://192.168.2.101:3000/acrors/1/inbox")
    http = Net::HTTP.new(uri.host, uri.port)

    http.use_ssl = true
    http.verify_mode = OpenSSL::SSL::VERIFY_NONE

    req = Net::HTTP::Post.new(uri.path)
    req.set_form_data(data)

    res = http.request(req)

  end

  private

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys:  [:username, :name])
    devise_parameter_sanitizer.permit(:account_update, keys: [:name])
  end

  def error_fallback(exception, fallback_message, status)
    message = exception&.message || fallback_message
    respond_to do |format|
      format.json { render json: { error: message }, status: status }
      format.html { raise exception }
    end
  end

  def error_not_found(exception = nil)
    
  end

  def error_unprocessable(exception = nil)
    #error_fallback(exception, I18n.t('controller.application.error_unprocessable.error'), :unprocessable_entity)
  end

  def error_csrf(exception = nil)
    #error_fallback(exception, I18n.t('controller.application.error_csrf.error'), :unprocessable_entity)
  end

  def error_not_authorized(exception = nil)
   # message = I18n.t('controller.application.error_not_authorized.error')
    respond_to do |format|
      #format.json { render json: { error: message }, status: :unauthorized }
      format.html do
        # User is signed in but don't have the rights to perform the action
        raise exception if current_user.present?

        redirect_to new_user_session_path
      end
    end
  end

  def json_request?
    request.format.json?
  end

end
