require File.expand_path('../config/application', __FILE__)
Rails.application.load_tasks

task :migrations do
  Dir.glob 'config/settings/brands/*.local.yml' do |file_path|
    settings = YAML.load Pathname.new(file_path).read
    next if settings.database.nil?
    puts "Migrating database #{settings.database.database}"
    Bundler.with_clean_env do
      ENV['DB_NAME'] = Settings.database.database
      ENV['DB_USER'] = Settings.database.username
      ENV['DB_PASS'] = Settings.database.password
      sh 'rake db:migrate'
    end
  end
end
