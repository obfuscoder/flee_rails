# frozen_string_literal: true

class NotificationsController < ApplicationController
  def create
    Notification.create event_id: params[:event_id], seller: current_seller
    redirect_to seller_path, notice: t('.success')
  end

  def destroy
    Notification.destroy_all event_id: params[:event_id], seller: current_seller
    redirect_to seller_path
  end
end
