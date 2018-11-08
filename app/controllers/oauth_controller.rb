# frozen_string_literal: true

class OauthController < ApplicationController
  skip_before_action :verify_authenticity_token
  def login
    sso :login
  end

  def connect
    sso :connect
  end

  def callback
    if session[:auth_reason] == 'connect'
      add_provider_to_user params[:provider]
    else
      login_from params[:provider]
    end
    redirect_back_or_to admin_path
  end

  private

  def sso(reason)
    session[:auth_reason] = reason
    login_at params[:provider], login_hint: 'ma.ma@web.de', claims: { user_info: { email: { essential: true } } }.to_json
  end
end
