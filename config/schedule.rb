# Use this file to easily define all of your cron jobs.
#
# It's helpful, but not entirely necessary to understand cron before proceeding.
# http://en.wikipedia.org/wiki/Cron

# Example:
#
# set :output, "/path/to/my/cron_log.log"
#
# every 2.hours do
#   command "/usr/bin/some_great_command"
#   runner "MyModel.some_method"
#   rake "some:great:rake:task"
# end
#
# every 4.days do
#   runner "AnotherModel.prune_old_records"
# end

# Learn more: http://github.com/javan/whenever

job_type :rbenv_rake, %Q{export PATH=/home/deploy/.rbenv/shims:/home/deploy/.rbenv/bin:/usr/bin:$PATH; eval "$(rbenv init -)"; \ cd :path && RAILS_ENV=:environment bundle exec rake :task --silent :output }

#every 1.day do
#  rbenv_rake "medium:import_posts"
#end

every 1.day do
  rbenv_rake "regonline:import_events"
  rbenv_rake "regonline:invisible_events"
end

every 1.day, at: '00:00 am' do
  command %Q{export PATH=/home/deploy/.rbenv/shims:/home/deploy/.rbenv/bin:/usr/bin:$PATH; eval "$(rbenv init -)"; backup perform -t db_backup}
end

every 1.day, at: '1:00 am' do
  runner "LicenseReminderWorker.new.perform"
end

every 2.hour do
  rbenv_rake "salesforce:sync"
end

every 1.day do
  rbenv_rake "salesforce:cleanup"
end

every 1.days do
  rbenv_rake "searchkick:reindex:all"
end
