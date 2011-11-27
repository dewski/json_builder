class User < ActiveRecord::Base
  def disabled?
    false
  end
  
  def activated?
    true
  end
end
