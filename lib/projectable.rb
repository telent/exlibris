module Projectable
  def project(keys)
    Hash[keys.map {|x| [x,self[x]] }]
  end
end
class Hash
  include Projectable
end
