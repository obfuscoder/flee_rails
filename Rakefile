# frozen_string_literal: true

require File.expand_path('../config/application', __FILE__)
Rails.application.load_tasks

namespace :db do
  desc 'creates backup of database'
  task :backup do
    destination_dir = "backup/db/#{Time.now.year}/#{Time.now.month}/#{Time.now.day}"
    FileUtils.mkdir_p destination_dir
    settings = Rails.configuration.database_configuration['production']
    destination = File.join(destination_dir, "flohmarkthelfer_#{Time.now.iso8601}.sql.gz")
    puts "Dumping database to #{destination}"
    username = settings['username']
    ENV['MYSQL_PWD'] = settings['password']
    database = settings['database']
    sh "mysqldump --single-transaction -u #{username} #{database} | gzip > #{destination}"
  end

  namespace :demo do
    desc 'seeds demo content'
    task :seed do
      client_seeds = YAML::load_file(Rails.root.join('db/seeds/clients.yml'))
      demo_seed = client_seeds.find { |seed| seed['key'] == 'demo' }
      client = Client.create! demo_seed

      categories = {
          'Spielzeug' => {
              limit: 20,
              children: %w[Brettspiel]
          },
          'Kleidung' => {
              limit: 50,
              children: %w[Hose Jacke Strampler]
          },
          'Kindersitz' => {},
          'Kiderwagen' => {}
      }

      categories.each do |name, data|
        category = client.categories.create! name: name, max_items_per_seller: data[:limit]
        data[:children]&.each { |child| client.categories.create! name: child, parent: category }
      end

      date = 2.weeks.from_now.at_midday
      event = client.events.create! name: 'Mustertermin',
                                    details: 'Schwangere **mit Mutterpass** inklusive einer Begleitperson haben 30 Minuten eher Einlass.',
                                    max_sellers: 100,
                                    confirmed: true,
                                    kind: :commissioned,
                                    max_items_per_reservation: 50,
                                    price_precision: 0.1,
                                    commission_rate: 0.2,
                                    reservation_fee: 2.5,
                                    reservation_start: 2.days.ago.at_midday,
                                    reservation_end: 2.days.from_now.at_midday,
                                    shopping_periods_attributes: [min: date, max: date + 2.hours],
                                    handover_periods_attributes: [min: date - 1.day, max: date - 1.day + 2.hours],
                                    pickup_periods_attributes: [min: date + 1.day, max: date + 1.day + 2.hours]

      seller = client.sellers.create! first_name: 'Maria',
                                      last_name: 'Mustermann',
                                      street: 'Musterstraße 123',
                                      zip_code: '12345',
                                      city: 'Musterstadt',
                                      email: 'maria.mustermann@flohmarkthelfer.de',
                                      phone: '0185/4711',
                                      token: 'va_oQ9k1tLbp7T98J93ekg',
                                      mailing: true,
                                      active: true
      reservation = seller.reservations.create! event: event
      #(2,'2018-01-20 13:45:09','2018-01-20 13:45:14',6,'Spielesammlung (Dame, Halma, et
      reservation.items.create! [
        {
          category: client.categories.find_by(name: 'Hose'),
          description: 'Jeans blau',
          size: '98',
          price: 2.5
        },
        {
          category: client.categories.find_by(name: 'Brettspiel'),
          description: 'Spielesammlung (Dame, Halma, etc.)',
          price: 5
        }
      ]
      client.users.create! email: 'admin@flohmarkthelfer.de', password: 'admin'
      client.stock_items.create! [
        {
          description: 'Einkaufstüte',
          price: 0.5
        },
        {
          description: 'Kuchen',
          price: 1.0
        },
        {
          description: 'Torte',
          price: 1.5
        },
        {
          description: 'Kaffee',
          price: 1.0
        },
        {
          description: 'Wiener mit Brötchen',
          price: 1.5
        }
      ]
    end

    desc 'deletes demo content'
    task :delete do
      client = Client.find_by key: 'demo'
      client.destroy_everything! if client.present?
    end

    desc 'reset demo content'
    task reset: %i[delete seed]
  end
end
