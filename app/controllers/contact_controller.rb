# frozen_string_literal: true

class ContactController < ApplicationController
  before_action :set_seller

  def show
    @contact = Contact.new
  end

  def submit
    @contact = Contact.new contact_params.merge(client: current_client, seller: @seller)
    if @contact.valid?
      NotificationMailer.contact(@contact.to_options).deliver_later
      redirect_to contact_submitted_path
    else
      render :show
    end
  end

  def submitted; end

  private

  def set_seller
    @seller = current_seller if current_seller?
  end

  def contact_params
    params.require(:contact).permit(:topic, :body, :email, :name)
  end
end
