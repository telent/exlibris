class User < ActiveRecord::Base
  has_many :shelves,:foreign_key=>:owner_id
  has_many :collections
  has_many :authorizations
  has_many :books, :through=>:shelves
  has_and_belongs_to_many :followers, class_name: "User",
   join_table: :following,
   foreign_key: :following_id, association_foreign_key: :follower_id
  has_and_belongs_to_many :following, class_name: "User",
   join_table: :following,
   foreign_key: :follower_id, association_foreign_key: :following_id
  IMAGE_STYLES = {
    :thumb=>"48x48>",
    :small=>"150x150>",
    :medium=>"300x300>"
  }
  has_attached_file :avatar,:styles=>IMAGE_STYLES

  # favour local upload then gravatar.  Pass any image set by remote
  # auth service at registration (e.g. twitter, facebook) to gravatar
  # as default, so it scales for us
  def image_url(size=:small)
    if self.avatar.present? then 
      self.avatar.url(size)
    else
      e=self.email_address || 'nobody@example.com'
      fallback= if self.image then CGI.escape(self.image) else "mm" end
      grav_id=Digest::MD5.hexdigest(e.downcase)
      "http://gravatar.com/avatar/#{grav_id}.png?s=#{IMAGE_STYLES[size]}&d=#{fallback}"
    end
  end
      

  # these are placeholder methods
  def admin?
    false
  end
  def moderator?
    false
  end
  # is self visible to u 
  def visible?(u)
    self.permitted?(u,:show)
  end

  def permitted?(user,permission)
    ((user==self) || user.admin?) ||
      case permission.to_sym
      when :show then self.collections.any? {|c| c.permitted?(user,:browse) }
      when :edit,:update,:destroy then true
      else false
      end
  end


  def self.permitted?(user,permission)
    case permission.to_sym
    when :index,:me then true
    when :new then user.admin?
    when :create then user.admin?
    end
  end
end
