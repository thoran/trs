# Nothing in here is especially recommended, but if you're running out of time and don't wish to merely punch the duck, but want to beat the duck to death, then these methods are OK!  

class Module
  
  def rmdef(*args)
    args.each do |e|
      self.send(:remove_method, e) if self.instance_methods.include?(e.to_s)
    end
  end
  
  def override(*modules)
    modules.reverse_each do |modul|
      modul.instance_methods.each{|m| self.rmdef(m)}
      self.send(:include, modul)
    end
  end
  private :override
  alias_method :include_with_override, :override
  
end
