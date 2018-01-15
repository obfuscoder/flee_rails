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
    destination = File.join("#{brand}_#{Time.now.iso8601}.sql.gz")
    puts "Dumping database for #{brand} to #{destination}"
    ENV['MYSQL_PWD'] = settings['password']
    username = settings['username']
    database = settings['database']
    sh "mysqldump --single-transaction -u #{username} #{database} | gzip > #{destination}"
  end
end

desc 'dump all brand databases into json files'
task :dump_dbs do
  brands = %w[arlinger bischofsheim bobingen dammerstock
              durlach eggenfelden ersingen hohenhaslach
              koenigsbach rueppurr woessingen]
  brands.each do |brand|
    # ActiveRecord::Base.establish_connection(Settings.brands[brand].database.to_hash)
    ActiveRecord::Base.establish_connection(database: brand, adapter: 'mysql2', username: 'flohmarkthelfer', password: 'flohmarkthelfer')

    builder = Jbuilder.new do |json|
      json.categories Category.with_deleted.all
      json.emails Email.all
      json.events Event.all
      json.hardware Hardware.all
      json.items Item.all
      json.messages Message.all
      json.notifications Notification.all
      json.rentals Rental.all
      json.reservations Reservation.all
      json.reviews Review.all
      json.sellers Seller.with_deleted.all
      json.sold_stock_items SoldStockItem.all
      json.suspensions Suspension.all
      json.time_periods TimePeriod.all
      json.stock_items StockItem.all
      json.users User.all
    end
    puts "#{brand} - #{Event.count}"
    File.write("#{brand}.json", builder.target!)
  end
end
