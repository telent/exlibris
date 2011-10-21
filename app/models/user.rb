class User < ActiveRecord::Base
  has_many :shelves,:foreign_key=>:owner_id
  has_many :collections
  has_many :authorizations
  has_many :books, :through=>:shelves

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
    case permission.to_sym
    when :show then self.collections.any? {|c| c.permitted?(user,:browse) }
    when :edit,:update,:destroy then ((user==self) || user.admin?)
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
