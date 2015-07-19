namespace :flee do
  desc 'Migrate all databases mentioned in local brand settings'
  task :migrate do
    on roles(:app), in: :sequence, wait: 5 do
      within release_path do
        with rails_env: :production do
          execute :rake, 'dumps migrations'
        end
      end
    end
  end

  after 'deploy:migrate', 'flee:migrate'
end
