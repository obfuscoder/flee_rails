# frozen_string_literal: true

namespace :flee do
  desc 'Backup database'
  task backup: :environment do
    on roles(:app), in: :sequence do
      within release_path do
        with rails_env: :production do
          execute :rake, 'db:backup'
        end
      end
    end
  end

  before 'deploy:migrate', 'flee:backup'
end
