# frozen_string_literal: true

source 'https://rubygems.org'

gem 'coffee-rails'
gem 'jquery-rails'
gem 'jquery-tablesorter'
gem 'rails', '~> 4.2'
gem 'sass-rails'
gem 'uglifier'
gem 'therubyracer' unless RUBY_PLATFORM =~ /darwin/

# gem 'turbolinks' disabled as it might interfere with multi domain concept
gem 'mysql2', group: :production

gem 'puma'

# bundle exec rake doc:rails generates the API under doc/api.
gem 'sdoc', group: :doc

group :development do
  gem 'capistrano-rails'
  gem 'capistrano-rvm'
  gem 'capistrano3-puma'
  gem 'spring'
end

group :test do
  gem 'capybara'
  gem 'capybara-email'
  gem 'database_cleaner'
  gem 'fuubar'
  gem 'launchy'
  gem 'pdf-inspector'
  gem 'poltergeist'
  gem 'rmagick'
  gem 'rspec-collection_matchers'
  gem 'rspec-its'
  gem 'rspec-rails'
  gem 'selenium-webdriver'
  gem 'shoulda-matchers'
  gem 'simplecov', require: false
  gem 'timecop'
end

group :test, :development do
  gem 'awesome_print'
  gem 'factory_bot_rails'
  gem 'faker'
  gem 'pry-rails'
  gem 'rubocop'
  gem 'sqlite3'
end

gem 'baby_squeel' # database query DSL
gem 'barby' # pdf barcodes
gem 'bootstrap-multiselect-rails'
gem 'bootstrap-sass'
gem 'bootstrap-will_paginate'
gem 'bootstrap3-datetimepicker-rails'
gem 'chartkick' # charts / graphics
gem 'cocoon'
gem 'config'
gem 'groupdate' # for statistics grouped by date
gem 'haml-rails'
gem 'jbuilder'
gem 'mail', '<2.7' # breaking changes in parsing emails
gem 'maildown'
gem 'momentjs-rails'
gem 'paranoia', '< 2.2' # soft delete records, 2.2+ is for rails 5
gem 'prawn' # pdf generation
gem 'prawn-table'
gem 'redcarpet' # markdown
gem 'simple_form'
gem 'sorcery'
gem 'underscore-rails'
gem 'validates_email_format_of'
gem 'whenever', require: false # cron
