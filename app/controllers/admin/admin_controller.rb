# frozen_string_literal: true

module Admin
  class AdminController < ApplicationController
    before_action :require_login
    before_action do
      @menu = [
        { link: admin_path, title: 'Adminbereich', icon: :home },
        { link: admin_events_path, title: 'Termine', icon: :calendar },
        { link: admin_sellers_path, title: 'Verkäufer', icon: :user },
        {
          title: 'Stammdaten', icon: :wrench, items: [
            { link: admin_categories_path, title: 'Kategorien', icon: :align_justify },
            { link: admin_stock_items_path, title: 'Stammartikel', icon: :th_large },
            { link: admin_message_templates_path, title: 'Standardmails', icon: :envelope },
            { link: edit_admin_client_path, title: 'Systemeinstellungen', icon: :cog }
          ]
        },
        { title: 'Mails', link: admin_emails_path, icon: :envelope },

        { link: '/docs/index.html', title: 'Hilfe', icon: :question_sign }
      ]
    end

    private

    def remote_request_on_demo?
      current_client.key == 'demo' && !request.local? && !request.host.ends_with?('demo.test.host')
    end

    def not_authenticated
      redirect_to admin_login_path, alert: t('admin.unauthorized')
    end
  end
end
