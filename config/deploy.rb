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
                                                 'config/settings/brands/demo.local.yml',
                                                 'config/settings/brands/default.local.yml')

set :linked_dirs, fetch(:linked_dirs, []).push('log', 'tmp', 'backup', 'public/download', 'public/docs')

set :puma_threads, [4, 16]
set :puma_workers, 2
set :puma_state,      "#{shared_path}/tmp/puma/state"
set :puma_pid,        "#{shared_path}/tmp/puma/pid"
set :puma_access_log, "#{release_path}/log/puma.error.log"
set :puma_error_log,  "#{release_path}/log/puma.access.log"
set :puma_preload_app, true
set :activate_control_app, true
set :puma_worker_timeout, nil
set :puma_init_active_record, true

# Default value for default_env is {}
# set :default_env, { path: "/opt/ruby/bin:$PATH" }

# Default value for keep_releases is 5
# set :keep_releases, 5

namespace :puma do
  desc 'Create Directories for Puma Pids and Socket'
  task :make_dirs do
    on roles(:app) do
      execute "mkdir #{shared_path}/tmp/puma -p"
    end
  end

  before :start, :make_dirs
end
