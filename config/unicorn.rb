# Set your full path to application.
root = File.expand_path('../../', __FILE__)
shared = File.expand_path('../../../shared/', __FILE__)
working_directory root

pid "#{shared}/pids/unicorn.pid"

stderr_path "#{shared}/log/unicorn.log"
stdout_path "#{shared}/log/unicorn.log"

worker_processes 3
timeout 30
preload_app true

listen "/tmp/unicorn.project-manager-simulator.sock", backlog: 64

before_fork do |server, worker|
  Signal.trap 'TERM' do
    puts 'Unicorn master intercepting TERM and sending myself QUIT instead'
    Process.kill 'QUIT', Process.pid
  end

  defined?(ActiveRecord::Base) and
    ActiveRecord::Base.connection.disconnect!
end

after_fork do |server, worker|
  Signal.trap 'TERM' do
    puts 'Unicorn worker intercepting TERM and doing nothing. Wait for master to send QUIT'
  end

  defined?(ActiveRecord::Base) and
    ActiveRecord::Base.establish_connection
end

# Force the bundler gemfile environment variable to
# reference the capistrano "current" symlink
before_exec do |_|
  ENV['BUNDLE_GEMFILE'] = File.join(root, 'Gemfile')
end
