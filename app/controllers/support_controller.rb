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
    @support_type = @event.support_types.find params[:id]
    supporter = @support_type.supporters.find_by seller: @seller
    supporter.destroy if supporter.present?
    redirect_to event_support_path(@event), notice: t('.success')
  end

  def create
    @support_type = @event.support_types.find params[:id]
    @support_type.supporters.create seller: @seller, comments: params[:supporter][:comments]
    redirect_to event_support_path(@event), notice: t('.success')
  end

  private

  def init_vars
    @seller = current_seller
    @event = current_client.events.find params[:event_id]
  end
end
