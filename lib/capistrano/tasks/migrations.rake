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

  task :seed_message_templates do
    on roles(:app) do
      within release_path do
        with rails_env: :production do
          execute :rake, 'db:seed:message_templates'
        end
      end
    end
  end

  before 'deploy:migrate', 'flee:backup'
  after 'deploy:migrate', 'flee:seed_message_templates'
end
