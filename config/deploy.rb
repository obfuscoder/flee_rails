# frozen_string_literal: true

set :application, 'flee_rails'
set :repo_url, 'https://github.com/obfuscoder/flee_rails'

set :linked_files, fetch(:linked_files, []).push('config/database.yml',
                                                 'config/secrets.yml',
                                                 'config/settings/brands/koenigsbach.local.yml',
                                                 'config/settings/brands/ersingen.local.yml',
                                                 'config/settings/brands/dammerstock.local.yml',
                                                 'config/settings/brands/rueppurr.local.yml',
                                                 'config/settings/brands/woessingen.local.yml',
                                                 'config/settings/brands/bobingen.local.yml',
                                                 'config/settings/brands/hohenhaslach.local.yml',
                                                 'config/settings/brands/durlach.local.yml',
                                                 'config/settings/brands/bischofsheim.local.yml',
                                                 'config/settings/brands/arlinger.local.yml',
                                                 'config/settings/brands/eggenfelden.local.yml',
                                                 'config/settings/brands/demo.local.yml',
                                                 'config/settings/brands/default.local.yml',
                                                 'config/puma.rb')

set :linked_dirs, fetch(:linked_dirs, []).push('log', 'tmp', 'backup', 'public/download', 'public/docs')

set :puma_conf, -> { "#{shared_path}/config/puma.rb" }
set :puma_threads, [4, 16]
set :puma_workers, 2
set :puma_bind, 'tcp://127.0.0.1:9292'
set :puma_preload_app, true
set :activate_control_app, true
set :puma_worker_timeout, nil
set :puma_init_active_record, true
