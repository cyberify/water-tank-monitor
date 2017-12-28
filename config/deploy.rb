# Deployment settings for Vlad

# defaults
set :application, 'water-tank-sensor-control'
set :web, nil

# repository settings
set :scm, :git
set :repository, 'git@bitbucket.org:SteveBenner09/ranch-water-tank-sensor-project.git'
# set :repository, 'git@bitbucket.org:SteveBenner09/ranch-water-tank-sensor-project.git'
set :branch, 'master'
set :scm_username, 'SteveBenner09'
set :scv_verbose, true
set :deploy_via, :remote_cache # copy direct from repo host to deploy target

# pi settings
# set :user, 'pi'
set :deploy_to, "/home/pi/#{application}"
# set :use_sudo, true
# exclude following files from deployment: todo: specify all ignore paths
set :copy_exclude, %w[.DS_Store .git .gitignore .gitmodules *.lock config]
set :pty, true # Must be set to enable git password prompt
# set :ssh_options, { :forward_agent => true } # use local RSA keys for server access

set :keep_releases, 1 # maximum copies of deployed 'release' to keep on the server (checked in cleanup stage)