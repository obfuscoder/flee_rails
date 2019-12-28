namespace :flee do
  desc 'Restart worker'
  task :restart_worker do
    on roles(:app), in: :sequence do
      within release_path do
        pid_file = File.join release_path, 'tmp', 'pids', 'worker.pid'
        begin
          execute "echo Killing process `cat #{pid_file}`"
          execute "pkill -F #{pid_file}"
        rescue SSHKit::Command::Failed
          warn 'Restart of worker not possible. Killing existing worker failed.'
        end
      end
    end
  end

  before 'deploy:published', 'flee:restart_worker'
end
