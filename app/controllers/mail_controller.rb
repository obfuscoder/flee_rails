# frozen_string_literal: true

class MailController < ApplicationController
  skip_before_action :verify_authenticity_token

  def receive
    ReceiveMailer.receive request.raw_post
    render plain: '', status: :no_content
  rescue ActiveRecord::RecordNotFound
    render plain: '', status: :not_found
  rescue ActiveRecord::RecordInvalid, ActiveRecord::RecordNotSaved
    render plain: '', status: :bad_request
  end
end
