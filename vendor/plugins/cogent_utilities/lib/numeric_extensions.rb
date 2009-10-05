module Enumerable
  
  def total(amount_method)
    # self.inject(0.0) {|sum, each| sum = sum + each.send(amount_method)}
    # the sum is explicitly in this order to coerce into a type in the collection
    # if the collection is empty this will return
    amount_sym = amount_method.to_sym
    self.inject(Zero.new) {|sum, each| sum = sum + each.send(amount_sym)}
  end
    
end

class Zero
  
  def +(something)
    something
  end
  
  def -(something)
    something * -1.0
  end
  
  def *(something)
    self
  end
  
  def /(something)
    self
  end
  
  def >(something)
    return 0.0 > something.to_f
  end
  
  def <(something)
    return 0.0 < something.to_f
  end
  
  def to_s
    '0.0'
  end
  
  def to_f
    0.0
  end
  
  def to_i
    0
  end
  
  def ==(other_object)
    0.0 == other_object.to_f
  end
  
end