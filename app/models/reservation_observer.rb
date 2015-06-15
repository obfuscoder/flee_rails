class ReservationObserver < ActiveRecord::Observer
  include Rails.application.routes.url_helpers

  def after_destroy(reservation)
    Notification.where(event: reservation.event).each do |notification|
      SellerMailer.notification(notification).deliver_later
      notification.destroy
    end
  end
end
