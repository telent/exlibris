class Collection < ActiveRecord::Base
  belongs_to :user
  has_many :acls, :class_name=>"CollectionAcl"
  has_many :books
  def owner
    self.user
  end
  def permit(user,permission)
    self.acls.find_or_create_by_user_id_and_permission(user.id,permission)
  end
  def forbid(user,permission=nil)
    if permission then
      self.acls.where(:user_id=>user.id,:permission=>permission).map(&:delete)
    else
      self.acls.where(:user_id=>user.id).map(&:delete)
    end
  end
  # is user allowed to do permission to self?
  def permitted?(user,permission)
    (user == self.user) || (user.admin?) || 
      self.acls.where(:user_id=>user.id,:permission=>permission).exists?
  end
  # the users returned from this method do not include admin users
  def permitted_users(permission)
    self.acls.where(:permission=>permission).map(&:user).push(self.user)
  end
end
