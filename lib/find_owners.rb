class FindOwners
  exps = Experiment.find :all
  
  for exp in exps
    next unless exp.owner_id.nil?
    old = Legacy.find_by_sql("select * from condition_groups where id = #{exp.gwap1_id}").first
    next if old.owner_id.nil?
    olduser = Legacy.find_by_sql("select email from users where id = #{old.owner_id}").first.email
    newuser = User.find_by_email(olduser)
    exp.owner_id = newuser.id
    puts "#{exp.gwap1_id}  #{olduser} #{newuser.email} #{exp.owner_id}"
    exp.save
  end
end