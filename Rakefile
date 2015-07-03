require File.expand_path('../config/application', __FILE__)
Rails.application.load_tasks

task :migrations do
  settings = YAML.load Pathname.new('config/settings.local.yml').read
  settings['brands'].each do |brand, brand_settings|
    next if brand_settings['database'].nil?
    puts "Migrating database for #{brand}"
    Bundler.with_clean_env do
      ENV['DB_NAME'] = brand_settings['database']['database']
      ENV['DB_USER'] = brand_settings['database']['username']
      ENV['DB_PASS'] = brand_settings['database']['password']
      sh 'rake db:migrate'
    end
  end
end
