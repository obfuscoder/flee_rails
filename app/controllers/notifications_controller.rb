class NotificationsController < ApplicationController
  def create
    unless Notification.find_by event_id: params[:event_id], seller_id: current_seller_id
      Notification.create event_id: params[:event_id], seller_id: current_seller_id
    end
    redirect_to seller_path
  end

  def destroy
    notification = Notification.find_by event_id: params[:event_id], seller_id: current_seller_id
    notification.try(:destroy)
    redirect_to seller_path
  end
end
