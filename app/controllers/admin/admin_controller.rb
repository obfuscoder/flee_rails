module Admin
  class AdminController < ApplicationController
    before_filter do
      @menu = {
        admin_path => 'Adminbereich',
        admin_events_path => 'Termine',
        admin_sellers_path => 'Verkäufer',
        admin_categories_path => 'Kategorien',
        admin_mails_path => 'Mails',
        admin_password_path => 'Passwort'
      }
    end
  end
end
