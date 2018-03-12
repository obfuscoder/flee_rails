# frozen_string_literal: true

set :application, 'flee_rails'
set :repo_url, 'https://github.com/obfuscoder/flee_rails'

set :linked_files, fetch(:linked_files, []).push('config/database.yml',
                                                 'config/secrets.yml',
                                                 'config/puma.rb')

set :linked_dirs, fetch(:linked_dirs, []).push('log', 'tmp', 'backup', 'public/download', 'public/docs')

set :puma_conf, -> { "#{shared_path}/config/puma.rb" }
set :puma_threads, [1, 1]
set :puma_workers, 4
set :puma_bind, 'tcp://127.0.0.1:9292'
set :rvm_ruby_string, :local

set :rollbar_token, '720d6e5df892434d93f421801f1a9f82'
set(:rollbar_env, proc { fetch :stage })
set(:rollbar_role, proc { :app })
