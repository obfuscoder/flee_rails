# frozen_string_literal: true

set :application, 'flee_rails'
set :repo_url, 'https://github.com/obfuscoder/flee_rails'

set :linked_files, fetch(:linked_files, []).push('config/database.yml',
                                                 'config/secrets.yml',
                                                 'config/settings/brands/koenigsbach.local.yml',
                                                 'config/settings/brands/ersingen.local.yml',
                                                 'config/settings/brands/friedensgemeinde.local.yml',
                                                 'config/settings/brands/kinder-shm.local.yml',
                                                 'config/settings/brands/kita-oberlinhaus.local.yml',
                                                 'config/settings/brands/kita-zhf.local.yml',
                                                 'config/settings/brands/hohenhaslach.local.yml',
                                                 'config/settings/brands/kommi-flohmarkt-durlach.local.yml',
                                                 'config/settings/brands/montessori-maintal.local.yml',
                                                 'config/settings/brands/kinderflohmarkt-arlinger.local.yml',
                                                 'config/settings/brands/kinderflohmarkt-rottgauhalle.local.yml',
                                                 'config/settings/brands/demo.local.yml',
                                                 'config/puma.rb')

set :linked_dirs, fetch(:linked_dirs, []).push('log', 'tmp', 'backup', 'public/download', 'public/docs')

set :puma_conf, -> { "#{shared_path}/config/puma.rb" }
set :puma_threads, [1, 1]
set :puma_workers, 4
set :puma_bind, 'tcp://127.0.0.1:9292'
set :rvm_ruby_string, :local
