# frozen_string_literal: true

set :output, 'log/cron.log'

every 4.hours do
  rake 'db:backup'
end

every :day, at: '0:00' do
  command '/usr/sbin/logrotate -s ~/www/shared/tmp/logrotate.state ~/www/current/config/logrotate.conf > /dev/null 2>&1'
end

every :day, at: '1:00' do
  rake 'db:demo:reset'
end
