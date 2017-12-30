# frozen_string_literal: true

class ReviewsController < ApplicationController
  before_filter :init_event, :init_reservation,
                :only_with_reservation, :only_after_event_passed, :only_without_review

  def show
    redirect_to new_event_reservation_review_path(@event, @reservation)
  end

  def new
    @review = @reservation.build_review
  end

  def create
    @review = @reservation.build_review(review_params.merge(reservation: @reservation))
    if @review.save
      redirect_to seller_path, notice: t('.success')
    else
      render :new
    end
  end

  private

  def init_event
    @event = current_client.events.find params[:event_id]
  end

  def init_reservation
    @reservation = @event.reservations.find params[:reservation_id]
    redirect_to seller_path, alert: t('.error.no_reservation') unless @reservation.seller == current_seller
  end

  def only_without_review
    redirect_to seller_path, alert: t('.error.already_reviewed') unless not_yet_reviewed?
  end

  def not_yet_reviewed?
    @reservation.review.nil?
  end

  def review_params
    attributes = %w[
      registration items print reservation_process mailing content design support
      handover payoff sale organization total recommend source to_improve
    ]
    params.require(:review).permit(attributes)
  end
end
