class User < ActiveRecord::Base
  validates_uniqueness_of :email
  
  def self.authenticate(nick, pass)
    user = find(:first, :conditions => ['email = ?',nick])

    if Password::check(pass,user.password)
      user
    else
      return false
    end
  end

  protected

  # Hash the password before saving the record
  def before_create
    self.password = Password::update(self.password)
  end  
end
