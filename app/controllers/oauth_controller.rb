# frozen_string_literal: true

class OauthController < ApplicationController
  def callback
    result = sorcery_fetch_user_hash(params[:provider])
    puts result
  end
end
