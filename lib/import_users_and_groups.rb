class ImportUsersAndGroups
  lusers = Legacy.find_by_sql "select * from users where email is not null"
  for luser in lusers
    u = User.new(:email => luser.email, :password => 'changeme')
    u['legacy_id'] = luser.id
    u.save
  end
  
  admingroup = Group.new(:name => 'admin', :description => "Administrators' Group")
  admingroup.save                          
  
  halogroup = Group.new(:name => 'halo', :description => 'Baliga Lab')
  halogroup.save
  
  users = User.find :all
  for user in users
    gid = halogroup.id 
    User.connection.execute("insert into users_groups (user_id,group_id) values (#{user.id},#{gid})")
    if (user.email == 'dtenenbaum@systemsbiology.org')
      gid = admingroup.id
      User.connection.execute("insert into users_groups (user_id,group_id) values (#{user.id},#{gid})")
    end                  
  end
  
end