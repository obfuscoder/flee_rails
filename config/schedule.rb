# frozen_string_literal: true

set :output, 'log/cron.log'

every :hour do
  rake 'dumps'
end
