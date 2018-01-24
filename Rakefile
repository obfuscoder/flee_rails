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
end
