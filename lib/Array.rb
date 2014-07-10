class Array
  
  def all?(test)
    inject(true){|a,e| a && e.send(test)}
  end
  
  def expired?
    all?(:expired)
  end
  
end
