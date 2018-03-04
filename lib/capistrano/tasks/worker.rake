# frozen_string_literal: true

namespace :flee do
  desc 'Restart worker'
  task :restart_worker do
    on roles(:app), in: :sequence, wait: 5 do
      within release_path do
        pid_file = File.join('tmp', 'pids', 'worker.pid')
        if File.exist? pid_file
          pid = File.read(pid_file)
          system "kill #{pid}"
        end
      end
    end
  end

  after 'deploy:symlink:release', 'flee:restart_worker'
end
