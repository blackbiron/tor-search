set :application, "tor_search"
set :repository,  "git@bitbucket.org:IceyEC/torsearch.git"

# set :scm, :git # You can set :scm explicitly or Capistrano will make an intelligent guess based on known version control directory names
# Or: `accurev`, `bzr`, `cvs`, `darcs`, `git`, `mercurial`, `perforce`, `subversion` or `none`

role :web, "ec2-54-224-36-225.compute-1.amazonaws.com"                          # Your HTTP server, Apache/etc
role :app, "ec2-54-224-36-225.compute-1.amazonaws.com"                          # This may be the same as your `Web` server
role :db,  "ec2-54-224-36-225.compute-1.amazonaws.com", :primary => true # This is where Rails migrations will run
#role :db,  "your slave db-server here"

# if you want to clean up old releases on each deploy uncomment this:
after "deploy:restart", "deploy:cleanup"

set :rails_env, :production

set :deploy_to, "/var/rails/#{application}"

set :scm, :git

# user on the server
set :user, "ubuntu"
set :use_sudo, true


namespace :deploy do

  task :start, :roles => :app, :except => { :no_release => true } do
    run "/etc/init.d/unicorn start"
  end

  task :stop, :roles => :app, :except => { :no_release => true } do
    run "/etc/init.d/unicorn stop"
  end

  task :restart, :roles => :app, :except => { :no_release => true } do
    run "kill -s USR2 `cat /var/rails/tor_search/tmp/pids/unicorn.pid`"
  end

  # Precompile assets
  namespace :assets do
    task :precompile, :roles => :web, :except => { :no_release => true } do
      run %Q{cd #{latest_release} && #{rake} RAILS_ENV=#{rails_env} #{asset_env} assets:precompile}
    end
  end

end

# if you're still using the script/reaper helper you will need
# these http://github.com/rails/irs_process_scripts

# If you are using Passenger mod_rails uncomment this:
# namespace :deploy do
#   task :start do ; end
#   task :stop do ; end
#   task :restart, :roles => :app, :except => { :no_release => true } do
#     run "#{try_sudo} touch #{File.join(current_path,'tmp','restart.txt')}"
#   end
# end