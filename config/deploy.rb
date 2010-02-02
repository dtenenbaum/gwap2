load 'deploy'

# ================================================================
# ROLES
# ================================================================


    role :app, "bragi.systemsbiology.net"
  
    role :db, "bragi.systemsbiology.net", {:primary=>true}
  
    role :web, "bragi.systemsbiology.net"
  

# ================================================================
# VARIABLES
# ================================================================

# Webistrano defaults
  set :webistrano_project, "gwap2"
  set :webistrano_stage, "prod"


  set :application, "gwap2"

  set :deploy_to, "/local/rails_apps/gwap2"

  set :deploy_via, :checkout

  set :password, "deployment_user(SSH user) password"

  set :rails_env, "production"

  set :repository, "git://github.com/dtenenbaum/gwap2.git"

  set :runner, "user to run as with sudo"

  set :scm, "git"

  set :use_sudo, false

  set :user, "dtenenba"




# ================================================================
# TEMPLATE TASKS
# ================================================================

        # allocate a pty by default as some systems have problems without
        default_run_options[:pty] = true
      
        # set Net::SSH ssh options through normal variables
        # at the moment only one SSH key is supported as arrays are not
        # parsed correctly by Webistrano::Deployer.type_cast (they end up as strings)
        [:ssh_port, :ssh_keys].each do |ssh_opt|
          if exists? ssh_opt
            logger.important("SSH options: setting #{ssh_opt} to: #{fetch(ssh_opt)}")
            ssh_options[ssh_opt.to_s.gsub(/ssh_/, '').to_sym] = fetch(ssh_opt)
          end
        end
      
        namespace :webistrano do
          namespace :mod_rails do
            desc "start mod_rails & Apache"
            task :start, :roles => :app, :except => { :no_release => true } do
              as = fetch(:runner, "app")
              invoke_command "#{apache_init_script} start", :via => run_method, :as => as
            end
            
            desc "stop mod_rails & Apache"
            task :stop, :roles => :app, :except => { :no_release => true } do
              as = fetch(:runner, "app")
              invoke_command "#{apache_init_script} stop", :via => run_method, :as => as
            end
            
            desc "restart mod_rails"
            task :restart, :roles => :app, :except => { :no_release => true } do
              as = fetch(:runner, "app")
              restart_file = fetch(:mod_rails_restart_file, "#{deploy_to}/current/tmp/restart.txt")
              invoke_command "touch #{restart_file}", :via => run_method, :as => as
            end
          end
        end
        
        namespace :deploy do
          task :restart, :roles => :app, :except => { :no_release => true } do
            webistrano.mod_rails.restart
          end
          
          task :start, :roles => :app, :except => { :no_release => true } do
            webistrano.mod_rails.start
          end
          
          task :stop, :roles => :app, :except => { :no_release => true } do
            webistrano.mod_rails.stop
          end
        end


# ================================================================
# CUSTOM RECIPES
# ================================================================

  after "deploy:update_code", :post_update_code_hook

  desc "Link in assorted bits that aren't in git, get permissions fixed"
task :post_update_code_hook do
 local_rails_root = `pwd`
 run "echo '__BEGINNING OF after_update_code recipe'"
 
 #run "echo #{shared_dir} #{shared_path}"
 run "cp #{shared_path}/config/environment.rb #{release_path}/config/environment.rb"
 ['development','production','test'].each do |i|
   run "cp #{shared_path}/config/environments/#{i}.rb #{release_path}/config/environments/#{i}.rb"
 end
 run "cp #{shared_path}/config/boot.rb #{release_path}/config/boot.rb"
 run "cp #{shared_path}/config/database.yml #{release_path}/config/database.yml"
 run "mv #{release_path}/app/controllers/application.rb #{release_path}/app/controllers/application_controller.rb"
 # todo deal with history
# files = %w{AC_OETags.js index.html echidna.swf}
# files.reverse.each do |file|
#  upload "public/#{file}", "#{release_path}/public", :via => :scp
# end
 


 # todo - deal with history

 # restart app - not sure if this is already done by cap deploy:update
 run "touch #{current_release}/tmp/restart.txt"
end





