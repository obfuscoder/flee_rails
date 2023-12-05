module Admin
  class AdminController < ApplicationController
    layout 'admin'

    before_action :require_login
    before_action do
      @menu = if current_client.locked.present?
                [
                  { link: admin_path, title: 'Adminbereich', icon: :home },
                  { link: edit_admin_client_path, title: 'Systemeinstellungen', icon: :cog },
                  { link: '/docs/index.html', title: 'Hilfe', icon: :question_sign }
                ]
              else
                @menu = [
                  { link: admin_path, title: 'Adminbereich', icon: :home },
                  { link: admin_events_path, title: 'Termine', icon: :calendar },
                  { link: admin_sellers_path, title: 'Verkäufer', icon: :user },
                  { title: 'Mails', link: admin_emails_path, icon: :envelope },
                  {
                    title: 'Stammdaten', icon: :wrench, items: [
                      { link: admin_categories_path, title: 'Kategorien', icon: :align_justify },
                      { link: admin_stock_items_path, title: 'Stammartikel', icon: :th_large },
                      { link: admin_message_templates_path, title: 'Standardmails', icon: :envelope },
                      { link: admin_users_path, title: 'Nutzerverwaltung', icon: :user },
                      { link: edit_admin_client_path, title: 'Systemeinstellungen', icon: :cog }
                    ]
                  },
                  { link: '/docs/index.html', title: 'Hilfe', icon: :question_sign }
                ]
              end
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
