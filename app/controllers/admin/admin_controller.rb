# frozen_string_literal: true

module Admin
  class AdminController < ApplicationController
    before_filter :require_login
    before_filter do
      @menu = [
        { link: admin_path, title: 'Adminbereich', icon: :home },
        { link: admin_events_path, title: 'Termine', icon: :calendar },
        { link: admin_sellers_path, title: 'Verkäufer', icon: :user },
        { link: admin_categories_path, title: 'Kategorien', icon: :align_justify },
        { link: admin_stock_items_path, title: 'Stammartikel', icon: :list },
        { link: admin_emails_path, title: 'Mails', icon: :envelope },
        { link: '/docs/index.html', title: 'Hilfe', icon: :question_sign }
      ]
      @menu.reject! { |element| element[:link] == admin_stock_items_path } unless Settings.features.try(:stock_items)
    end

    private

    def not_authenticated
      redirect_to admin_login_path, alert: t('admin.unauthorized')
    end
  end
end
