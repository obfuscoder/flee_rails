# frozen_string_literal: true

class NotificationsController < ApplicationController
  before_filter :init_event

  def create
    @event.notifications.create seller: current_seller
    redirect_to seller_path, notice: t('.success')
  end

  def destroy
    @event.notifications.where(seller: current_seller).destroy_all
    redirect_to seller_path
  end

  private

  def init_event
    @event = current_client.events.find params[:event_id]
  end
end
