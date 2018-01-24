# frozen_string_literal: true

namespace :flee do
  desc 'Backup database'
  task :backup do
    on roles(:app), in: :sequence, wait: 5 do
      within release_path do
        with rails_env: :production do
          execute :rake, 'db:backup'
        end
      end
    end
  end

  after 'deploy:migrate', 'flee:backup'
end
