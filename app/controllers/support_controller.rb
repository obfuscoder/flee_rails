# frozen_string_literal: true

class SupportController < ApplicationController
  before_action :init_vars

  def index
    @support_types = @event.support_types
  end

  def new
    @support_type = @event.support_types.find params[:id]
    @supporter = @support_type.supporters.build
  end

  def destroy
    if @event.supporters_can_retire?
      @support_type = @event.support_types.find params[:id]
      supporter = @support_type.supporters.find_by seller: @seller
      if supporter.present?
        supporter.destroy
        NotificationMailer.supporter_destroyed(@support_type, @seller).deliver_later
      end
      redirect_to event_support_path(@event), notice: t('.success')
    else
      redirect_to event_support_path(@event), alert: t('.cannot_retire')
    end
  end

  def create
    @support_type = @event.support_types.find params[:id]
    supporter = @support_type.supporters.create! seller: @seller, comments: params[:supporter][:comments]
    NotificationMailer.supporter_created(supporter).deliver_later
    redirect_to event_support_path(@event), notice: t('.success')
  end

  private

  def init_vars
    @seller = current_seller
    @event = current_client.events.find params[:event_id]
  end
end
