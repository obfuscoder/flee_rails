# frozen_string_literal: true

class MailController < ApplicationController
  skip_before_filter :verify_authenticity_token

  def receive
    ReceiveMailer.receive request.raw_post
    render plain: '', status: :no_content
  end
end
