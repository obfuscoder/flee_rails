# frozen_string_literal: true

set :output, 'log/cron.log'

every :hour do
  rake 'db:backup'
end

every :day, at: '1:00' do
  rake 'db:demo:reset'
end
