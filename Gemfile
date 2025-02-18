source 'https://rubygems.org'

gem 'awesome_print'
gem 'baby_squeel' # database query DSL
gem 'barby' # pdf barcodes
gem 'bootsnap'
gem 'bootstrap3-datetimepicker-rails'
gem 'bootstrap-multiselect-rails'
gem 'bootstrap-sass'
gem 'bootstrap-will_paginate'
gem 'will_paginate', '< 4' # breaking changes in 4
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
gem 'maildown'
gem 'momentjs-rails'
gem 'mysql2'
gem 'paranoia' # soft delete records
gem 'prawn' # pdf generation
gem 'prawn-table'
gem 'puma'
gem 'rails', '~> 6.0.0'
gem 'concurrent-ruby', '1.3.4' # Remove with rails 7.1 - dependency needs to be pinned for logger transient dependency being removed in 1.3.5
gem 'rake'
gem 'redcarpet' # markdown
gem 'rollbar'
gem 'sass-rails'
gem 'simple_form'
gem 'sorcery'
gem 'uglifier'
gem 'underscore-rails'
gem 'validates_email_format_of'
gem 'whenever', require: false # cron
gem 'ffi', '~> 1.16.0' # pinned due to 1.17 requiring ruby 3

# gem 'turbolinks' disabled as it might interfere with multi domain concept

group :development do
  gem 'capistrano3-puma', '~> 5'
  gem 'capistrano-rails'
  gem 'capistrano-rvm'
  gem 'rubocop'
  gem 'rubocop-faker'
  gem 'rubocop-performance'
  gem 'rubocop-rails'
  gem 'rubocop-rspec'
  gem 'solargraph'
  gem 'spring'
  gem 'web-console'
  gem 'listen'
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
  gem 'debase'
  gem 'factory_bot_rails'
  gem 'faker'
  gem 'pry-rails'
  gem 'ruby-debug-ide'
  gem 'sqlite3', '~> 1.6.9' # pinned due to 1.7.0 requiring ruby 3
  gem 'timecop'
end

