set :output, 'log/cron.log'

every :day, at: '0:00' do
  command '/usr/sbin/logrotate -s ~/www/shared/tmp/logrotate.state ~/www/current/config/logrotate.conf > /dev/null 2>&1'
end

every :day, at: '1am' do
  rake 'db:demo:reset'
  rake 'db:backup'
end
