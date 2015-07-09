before_exec do |server|
  ENV['BUNDLE_GEMFILE'] = "/var/www/greatminds/current/Gemfile"
end

# Set the working application directory
# working_directory "/path/to/your/app"
working_directory "/var/www/greatminds/current"

# Unicorn PID file location
# pid "/path/to/pids/unicorn.pid"
pid "/var/www/greatminds/current/tmp/pids/unicorn.pid"

preload_app true

# Path to logs
# stderr_path "/path/to/log/unicorn.log"
# stdout_path "/path/to/log/unicorn.log"
stderr_path "/var/www/greatminds/current/log/unicorn.log"
stdout_path "/var/www/greatminds/current/log/unicorn.log"

# Unicorn socket
listen "/tmp/unicorn.greatminds.sock"

# Number of processes
# worker_processes 4
worker_processes 2

# Time-out
timeout 30

before_fork do |server, worker|
  # Disconnect since the database connection will not carry over
  if defined? ActiveRecord::Base
    ActiveRecord::Base.connection.disconnect!
  end

  # Quit the old unicorn process
  old_pid = "/var/www/greatminds/current/tmp/pids/unicorn.pid.oldbin"
  if File.exists?(old_pid) && server.pid != old_pid
    begin
      Process.kill("QUIT", File.read(old_pid).to_i)
    rescue Errno::ENOENT, Errno::ESRCH
      # someone else did our job for us
    end
  end

  sleep 1
end

after_fork do |server, worker|
  # Start up the database connection again in the worker
  if defined?(ActiveRecord::Base)
    ActiveRecord::Base.establish_connection
  end
end
