# frozen_string_literal: true

namespace :flee do
  desc 'Restart worker'
  task :restart_worker do
    on roles(:app), in: :sequence do
      within release_path do
        pid_file = File.join release_path, 'tmp', 'pids', 'worker.pid'
        info pid_file
        begin
          info File.read(pid_file)
        rescue
          info 'File does not exist'
        end
        if File.exist? pid_file
          pid = File.read pid_file
          info "Killing worker process #{pid}"
          puts "Killing worker process #{pid}"
          execute "kill #{pid}"
        end
      end
    end
  end

  before 'deploy:published', 'flee:restart_worker'
end
