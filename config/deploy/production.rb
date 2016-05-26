# Simple Role Syntax
# ==================
# Supports bulk-adding hosts to roles, the primary
# server in each group is considered to be the first
# unless any hosts have the primary property set.
# Don't declare `role :all`, it's a meta role
# role :app, %w{administrator@prosim.ing.puc.cl}
# role :web, %w{administrator@prosim.ing.puc.cl}
# role :db,  %w{administrator@prosim.ing.puc.cl}

set :port, 22
set :user, 'administrator'
set :deploy_via, :remote_cache
set :use_sudo, false

# Extended Server Syntax
# ======================
# This can be used to drop a more detailed server
# definition into the server list. The second argument
# something that quacks like a hash can be used to set
# extended properties on the server.
server 'prosim.ing.puc.cl',
	roles: %w{web app}, 
	user: fetch(:user), 
	port: fetch(:port), 
	primary: true

set :deploy_to, "/home/#{fetch(:user)}/apps/#{fetch(:application)}" 
# you can set custom ssh options
# it's possible to pass any option but you need to keep in mind that net/ssh understand limited list of options
# you can see them in [net/ssh documentation](http://net-ssh.github.io/net-ssh/classes/Net/SSH.html#method-c-start)
# set it globally
set :ssh_options, {
	forward_agent: true,
	auth_methods: %w(password),
	user: 'administrator'
}
# and/or per server
# server 'example.com',
#   user: 'user_name',
#   roles: %w{web app},
#   ssh_options: {
#     user: 'user_name', # overrides user setting above
#     keys: %w(/home/user_name/.ssh/id_rsa),
#     forward_agent: false,
#     auth_methods: %w(publickey password)
#     # password: 'please use keys'
#   }
# setting per server overrides global ssh_options
set :rails_env, :production
set :conditionally_migrate, true
