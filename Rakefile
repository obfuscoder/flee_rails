require File.expand_path('../config/application', __FILE__)
Rails.application.load_tasks

def for_each_database
  Dir.glob 'config/settings/brands/*.local.yml' do |file_path|
    settings = YAML.load Pathname.new(file_path).read
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
  for_each_database do |brand, settings|
    destination = "backup/db/#{brand}_#{Time.now.iso8601}.sql.gz"
    puts "Dumping database for #{brand} to #{destination}"
    ENV['MYSQL_PWD'] = settings['password']
    sh "mysqldump --single-transaction -u #{settings['username']} -h #{settings['host']} #{settings['database']} | gzip > #{destination}"
  end
end
