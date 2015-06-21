class ReviewsController < ApplicationController
  before_filter :init_event, :only_with_reservation, :only_after_event_passed, :only_without_review

  def show
    redirect_to new_event_review_path
  end

  def new
    @review = current_seller.reviews.build(event: @event)
  end

  def create
    @review = current_seller.reviews.build(review_params.merge(event: @event))
    if @review.save
      redirect_to seller_path, notice: t('.success')
    else
      render :new, alert: t('.error')
    end
  end

  private

  def init_event
    @event = Event.find params[:event_id]
  end

  def only_with_reservation
    redirect_to seller_path, alert: t('.error.no_reservation') if
      current_seller.reservations.where(event: @event).empty?
  end

  def only_after_event_passed
    redirect_to seller_path, alert: t('.error.event_ongoing') unless @event.shopping_end.past?
  end

  def only_without_review
    redirect_to seller_path,
                alert: t('.error.already_reviewed') unless current_seller.reviews.where(event: @event).empty?
  end

  def review_params
    attributes = %w(
      registration items print reservation mailing content design support
      handover payoff sale organization total recommend source to_improve
    )
    params.require(:review).permit(attributes)
  end
end
