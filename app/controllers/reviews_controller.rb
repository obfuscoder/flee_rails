class ReviewsController < ApplicationController
  def show
    @review = current_seller.reviews.where(event: params[:event_id]).first
    redirect_to new_event_review_path if @review.nil?
  end

  def new
    @review = current_seller.reviews.build(event_id: params[:event_id])
  end
end
