# encoding: utf-8
# capistrano production config
#
# config/deploy/production.rb

server 'ec2-54-227-51-178.compute-1.amazonaws.com', \
       :app, :web, :db, primary: true
set :branch,                     'master'
set :deploy_to,                  '/var/rails/tor_search'
set :rails_env,                  'production'
