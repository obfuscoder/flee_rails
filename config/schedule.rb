set :output, 'cron_log.log'

every :hour do
  command "echo 'you can use raw cron syntax too'"
  rake 'dumps'
end
