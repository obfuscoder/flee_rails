# frozen_string_literal: true

require File.expand_path('../config/application', __FILE__)
Rails.application.load_tasks

def for_each_database
  Dir.glob 'config/settings/brands/*.local.yml' do |file_path|
    settings = YAML.safe_load Pathname.new(file_path).read
    settings['brands'].each do |brand, brand_settings|
      next if brand_settings['database'].nil? || brand_settings['database'].nil?
      yield brand, brand_settings['database']
    end
  end
end

desc 'executes migrations on all databases configured under config/settings/brands/*.local.xml'
task :migrations do
  for_each_database do |brand, settings|
    puts "Migrating database for #{brand}"
    Bundler.with_clean_env do
      ENV['DB_NAME'] = settings['database']
      ENV['DB_USER'] = settings['username']
      ENV['DB_PASS'] = settings['password']
      ENV['DB_HOST'] = settings['host']
      sh 'bundle exec rake db:migrate'
    end
  end
end

desc 'dumps databases configured under config/settings/brands/*.local.xml'
task :dumps do
  destination_dir = "backup/db/#{Time.now.year}/#{Time.now.month}/#{Time.now.day}"
  FileUtils.mkdir_p destination_dir
  for_each_database do |brand, settings|
    destination = File.join(destination_dir, "#{brand}_#{Time.now.iso8601}.sql.gz")
    puts "Dumping database for #{brand} to #{destination}"
    ENV['MYSQL_PWD'] = settings['password']
    username = settings['username']
    database = settings['database']
    sh "mysqldump --single-transaction -u #{username} #{database} | gzip > #{destination}"
  end
end

desc 'dump all brand databases into json files'
task :dump_dbs do
  brands = %w[demo arlinger bischofsheim bobingen dammerstock
              durlach eggenfelden ersingen hohenhaslach
              koenigsbach rueppurr woessingen]
  brands.each do |brand|
    # ActiveRecord::Base.establish_connection(Settings.brands[brand].database.to_hash)
    ActiveRecord::Base.establish_connection(database: brand, adapter: 'mysql2', username: 'flohmarkthelfer', password: 'flohmarkthelfer')

    builder = Jbuilder.new do |json|
      json.categories Category.with_deleted.all
      json.events Event.all
      json.sellers Seller.with_deleted.all
      json.stock_items StockItem.all
      json.emails Email.all
      json.items Item.all
      json.messages Message.all
      json.notifications Notification.all
      json.rentals Rental.all
      json.reservations Reservation.all
      json.reviews Review.all
      json.sold_stock_items SoldStockItem.all
      json.suspensions Suspension.all
      json.time_periods TimePeriod.all
      json.users User.all
    end
    puts "#{brand} - #{Event.count}"
    File.write("#{brand}.json", builder.target!)
  end
end

desc 'merge all brand specific json dumps into current database'
task :merge_dumps do
  brands = {
    arlinger: 'kinderflohmarkt-arlinger',
    bischofsheim: 'montessori-maintal',
    bobingen: 'kita-zhf',
    dammerstock: 'friedensgemeinde',
    durlach: 'kommi-flohmarkt-durlach',
    eggenfelden: 'kinderflohmarkt-rottgauhalle',
    ersingen: 'ersingen',
    hohenhaslach: 'hohenhaslach',
    koenigsbach: 'koenigsbach',
    rueppurr: 'kinder-shm',
    woessingen: 'kita-oberlinhaus'
  }
  brands.each do |brand, client_key|
    puts "#{brand} => #{client_key}"
    client = Client.find_by key: client_key
    data = JSON.parse(File.read("#{brand}.json"), symbolize_names: true)

    categories = ActiveRecord::Base.transaction do
      puts "Categories: #{data[:categories].count}"
      data[:categories].each_with_object({}) do |data, h|
        id = data.delete(:id)
        h[id] = Category.create!(data.merge(client: client))
      end
    end

    ActiveRecord::Base.transaction do
      categories.each_value do |item|
        next if item.parent_id.nil?
        item.update! parent: categories[item.parent_id]
      end
    end

    events = ActiveRecord::Base.transaction do
      puts "Events: #{data[:events].count}"
      data[:events].each_with_object({}) do |data, h|
        id = data.delete(:id)
        data[:reservation_fee] = data.delete(:seller_fee)
        data[:number] = id
        puts "#{brand} - #{id} - #{data}"
        h[id] = Event.create!(data.merge(client: client))
      end
    end

    sellers = ActiveRecord::Base.transaction do
      puts "Sellers: #{data[:sellers].count}"
      data[:sellers].each_with_object({}) do |data, h|
        id = data.delete(:id)
        data[:phone] = nil if data[:phone].blank?
        data = { first_name: 'DELETED', last_name: 'DELETED', email: 'DELETED@DELETED.COM',
                 street: 'DELETED', city: 'DELETED', phone: '012345678', zip_code: '00000' }.merge(data.compact)
        puts "#{brand} - #{id} - #{data}"
        h[id] = Seller.create!(data.merge(client: client))
      end
    end

    stock_items = ActiveRecord::Base.transaction do
      puts "StockItems: #{data[:stock_items].count}"
      data[:stock_items].each_with_object({}) do |data, h|
        id = data.delete(:id)
        h[id] = StockItem.create!(data.merge(client: client))
      end
    end

    users = ActiveRecord::Base.transaction do
      puts "Users: #{data[:users].count}"
      data[:users].each_with_object({}) do |data, h|
        id = data.delete(:id)
        h[id] = User.create!(data.merge(client: client))
      end
    end

    emails = ActiveRecord::Base.transaction do
      puts "Emails: #{data[:emails].count}"
      data[:emails].each_with_object({}) do |data, h|
        id = data.delete(:id)
        seller_id = data.delete(:seller_id)
        h[id] = Email.create!(data.merge(seller: sellers[seller_id]))
      end
    end

    ActiveRecord::Base.transaction do
      emails.each_value do |item|
        next if item.parent_id.nil?
        item.update! parent: emails[item.parent_id]
      end
    end

    messages = ActiveRecord::Base.transaction do
      puts "Messages: #{data[:messages].count}"
      data[:messages].each_with_object({}) do |data, h|
        id = data.delete(:id)
        event_id = data.delete(:event_id)
        h[id] = Message.create!(data.merge(event: events[event_id]))
      end
    end

    notifications = ActiveRecord::Base.transaction do
      puts "notifications: #{data[:notifications].count}"
      data[:notifications].each_with_object({}) do |data, h|
        id = data.delete(:id)
        event_id = data.delete(:event_id)
        seller_id = data.delete(:seller_id)
        h[id] = Notification.create!(data.merge(event: events[event_id], seller: sellers[seller_id]))
      end
    end

    reservations = ActiveRecord::Base.transaction do
      puts "reservations: #{data[:reservations].count}"
      data[:reservations].each_with_object({}) do |data, h|
        id = data.delete(:id)
        event_id = data.delete(:event_id)
        seller_id = data.delete(:seller_id)
        obj = Reservation.new(data.merge(event: events[event_id], seller: sellers[seller_id]))
        obj.save! context: :admin
        h[id] = obj
      end
    end

    reviews = ActiveRecord::Base.transaction do
      puts "reviews: #{data[:reviews].count}"
      data[:reviews].each_with_object({}) do |data, h|
        id = data.delete(:id)
        reservation_id = data.delete(:reservation_id)
        h[id] = Review.create!(data.merge(reservation: reservations[reservation_id]))
      end
    end

    sold_stock_items = ActiveRecord::Base.transaction do
      puts "sold_stock_items: #{data[:sold_stock_items].count}"
      data[:sold_stock_items].each_with_object({}) do |data, h|
        id = data.delete(:id)
        event_id = data.delete(:event_id)
        stock_item_id = data.delete(:stock_item_id)
        h[id] = SoldStockItem.create!(data.merge(event: events[event_id], stock_item: stock_items[stock_item_id]))
      end
    end

    suspensions = ActiveRecord::Base.transaction do
      puts "suspensions: #{data[:suspensions].count}"
      data[:suspensions].each_with_object({}) do |data, h|
        id = data.delete(:id)
        event_id = data.delete(:event_id)
        seller_id = data.delete(:seller_id)
        h[id] = Suspension.create!(data.merge(event: events[event_id], seller: sellers[seller_id]))
      end
    end

    time_periods = ActiveRecord::Base.transaction do
      puts "time_periods: #{data[:time_periods].count}"
      data[:time_periods].each_with_object({}) do |data, h|
        id = data.delete(:id)
        event_id = data.delete(:event_id)
        obj = TimePeriod.new(data.merge(event: events[event_id]))
        obj.save validate: false
        h[id] = obj
      end
    end

    items = ActiveRecord::Base.transaction do
      puts "items: #{data[:items].count}"
      data[:items].each_with_object({}) do |data, h|
        id = data.delete(:id)
        reservation_id = data.delete(:reservation_id)
        category_id = data.delete(:category_id)
        data[:price] = 0.5 if data[:price] == '0.0'
        if reservations[reservation_id].nil?
          puts "ITEM-id #{id} - reservation #{reservation_id} missing!"
        else
          obj = Item.new(data.merge(reservation: reservations[reservation_id], category: categories[category_id]))
          obj.save! context: :admin
          h[id] = obj
        end
      end
    end
  end
end
