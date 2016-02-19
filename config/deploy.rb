# config valid only for current version of Capistrano
lock '3.4.0'

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
                                                 'config/settings/brands/demo.local.yml')

set :linked_dirs, fetch(:linked_dirs, []).push('log', 'tmp/cache', 'backup')

# Default value for default_env is {}
# set :default_env, { path: "/opt/ruby/bin:$PATH" }

# Default value for keep_releases is 5
# set :keep_releases, 5

namespace :deploy do
  after :restart, :clear_cache do
    on roles(:web), in: :groups, limit: 3, wait: 10 do
    end
  end
end
