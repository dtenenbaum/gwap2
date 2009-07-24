# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  
  before_filter :authenticate, :except => :login
  
  
  
  helper :all # include all helpers, all the time

  # See ActionController::RequestForgeryProtection for details
  # Uncomment the :secret if you're not using the cookie session store
  #protect_from_forgery # :secret => 'f6fcf0a90ce46d4a3bd091aab2c7de95'
  self.allow_forgery_protection = false
  
  # See ActionController::Base for details 
  # Uncomment this to filter the contents of submitted sensitive data parameters
  # from your application log (in this case, all fields with names like "password"). 
  # filter_parameter_logging :password



  def authenticate  
    puts "in authenticate"
    if cookies[:gwap2_cookie].nil? or cookies[:gwap2_cookie].empty?
      puts "cookie doesn't exist"
      redirect_to :action => "login" and return false
    end
    if (session[:user].nil?)    
      puts "session user is not set"
      puts "cookie is set to #{cookies[:gwap2_cookie]}"
      session[:user] = User.find_by_email(cookies[:gwap2_cookie])
    end
  end                              

  # todo make more secure
  def login
    if request.post?
      user = User.authenticate(params['email'],params['password'])     
      #render :text => user.email and return false
      if (user == false)
        flash[:notice] = "Invalid login, try again"
        render :action => "login" and return false
      else              
        cookies[:gwap2_cookie] = {:value => user.email,
          :expires => 1000.days.from_now }
        session[:user] = user
        redirect_to :action => "index"
      end
    end
  end
  
  def logout
    cookies.delete(:gwap2_cookie)
    session[:user] = nil  
    redirect_to :action => "login"
  end



end                                      





