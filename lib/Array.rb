class Array
  
  alias_method :last!, :pop
  
  def all?(test)
    inject(true){|a,e| a && e.send(test)}
  end
  
  def all_but_last
    d = self.dup
    d.last!
    d
  end
  
  def expired?
    all?(:expired?)
  end
  
  def extract_options!
    last.is_a?(::Hash) ? pop : {}
  end
  
end
