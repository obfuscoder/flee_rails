source 'https://rubygems.org'

gem 'awesome_print'
gem 'baby_squeel' # database query DSL
gem 'barby' # pdf barcodes
gem 'bootsnap'
gem 'bootstrap3-datetimepicker-rails'
gem 'bootstrap-multiselect-rails'
gem 'bootstrap-sass'
gem 'bootstrap-will_paginate'
gem 'chartkick' # charts / graphics
gem 'cocoon'
gem 'coffee-rails'
gem 'config'
gem 'delayed_job_active_record'
gem 'groupdate' # for statistics grouped by date
gem 'haml-rails'
gem 'jbuilder'
gem 'jquery-rails'
gem 'jquery-tablesorter'
gem 'mail', '<2.7' # breaking changes in parsing emails
gem 'maildown'
gem 'momentjs-rails'
gem 'mysql2'
gem 'paranoia' # soft delete records
gem 'prawn' # pdf generation
gem 'prawn-table'
gem 'puma', '< 5' # we need to stay below 5.x as capistrano3-puma 5.x is not yet released
gem 'rails', '~> 5.1.0'
gem 'rake'
gem 'redcarpet' # markdown
gem 'rollbar'
gem 'sass-rails'
gem 'simple_form'
gem 'sorcery'
gem 'therubyracer' unless RUBY_PLATFORM.match?(/darwin/)
gem 'uglifier'
gem 'underscore-rails'
gem 'validates_email_format_of'
gem 'whenever', require: false # cron

# gem 'turbolinks' disabled as it might interfere with multi domain concept

group :development do
  gem 'capistrano3-puma'
  gem 'capistrano-rails'
  gem 'capistrano-rvm'
  gem 'spring'
end

group :test do
  gem 'capybara'
  gem 'capybara-email'
  gem 'capybara-selenium'
  gem 'fuubar'
  gem 'launchy'
  gem 'pdf-inspector'
  gem 'rails-controller-testing'
  gem 'rmagick'
  gem 'rspec-collection_matchers'
  gem 'rspec-its'
  gem 'rspec-rails'
  gem 'shoulda-matchers'
  gem 'simplecov', require: false
end

group :test, :development do
  gem 'factory_bot_rails'
  gem 'faker'
  gem 'pry-rails'
  gem 'rubocop'
  gem 'rubocop-faker'
  gem 'rubocop-performance'
  gem 'rubocop-rails'
  gem 'rubocop-rspec'

  gem 'timecop'

  # sqlite3 version 1.4.0+ is not compatible with latest rails 4 or 5.0.
  # See https://github.com/sparklemotion/sqlite3-ruby/issues/249
  # and https://github.com/rails/rails/issues/35161
  # and https://github.com/rails/rails/issues/35153
  gem 'sqlite3', '< 1.4.0'
end
