module Admin
  class AdminController < ApplicationController
    before_filter :require_login
    before_filter do
      @menu = {
        admin_path => 'Adminbereich',
        admin_events_path => 'Termine',
        admin_sellers_path => 'Verkäufer',
        admin_categories_path => 'Kategorien',
        admin_emails_path => 'Mails'
      }
    end

    private

    def not_authenticated
      redirect_to admin_login_path, alert: t('admin.unauthorized')
    end
  end
end
