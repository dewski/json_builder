class User < ActiveRecord::Base
  scope :old, where('id < 5')
  
  def disabled?
    false
  end
  
  def activated?
    true
  end
end
