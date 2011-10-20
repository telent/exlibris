class Collection < ActiveRecord::Base
  belongs_to :user
  has_many :acls, :class_name=>"CollectionAcl"
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
  def permitted?(user,permission)
    (user == self.user) || (user.admin?) || 
      self.acls.where(:user_id=>user.id,:permission=>permission).exists?
  end
  def permitted_users(permission)
    self.acls.where(:permission=>permission).map(&:user).push(self.user)
  end
end
