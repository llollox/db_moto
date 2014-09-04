class AddRootUsers < ActiveRecord::Migration
  def up
  	User.create!(:username => 'llollox', :email => 'lore91tanz@gmail.com', :password => 'llollox1', :password_confirmation => 'llollox1')
  end

  def down
  	User.find_by_username('llollox').destroy
  end
end
