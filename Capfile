# Load DSL and Setup Up Stages
require 'capistrano/setup'

# Includes default deployment tasks
require 'capistrano/deploy'

# Includes tasks from other gems included in your Gemfile
#
# For documentation on these, see for example:
#
#   https://github.com/capistrano/rvm
#   https://github.com/capistrano/rbenv
#   https://github.com/capistrano/chruby
#   https://github.com/capistrano/bundler
#   https://github.com/capistrano/rails
#
# require 'capistrano/rvm'
 require 'capistrano/bundler'
 require 'capistrano/rails/assets'
 require 'capistrano/rails/migrations'
 require 'capistrano/rails'
 require 'capistrano3/unicorn'

 require 'capistrano/rbenv'
 set :rbenv_type, :user
 set :rbenv_ruby, '2.2.0'
# require 'capistrano/chruby'

set :default_env, { 
'SECRET_KEY_BASE' => '4e594a4c02abe972c66c9e891c58c81283d88b8ec215aa31edc23cf74c5e5de651692e7a5a42fd979762ae00927c880ebe6f0115862a97a0c4e7ababb86a48bb'
}

# Loads custom tasks from `lib/capistrano/tasks' if you have any defined.
Dir.glob('lib/capistrano/tasks/*.cap').each { |r| import r }
