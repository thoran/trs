module Thoran
  class Array
    module InstanceMethods
      
      def all_but_last
        d = self.dup
        d.last!
        d
      end
      
      def expired?
        all?(&:expired?)
      end
      
      def extract_options!
        last.is_a?(::Hash) ? pop : {}
      end
      
    end
  end
end

Array.send(:include, Thoran::Array::InstanceMethods)
Array.send(:alias_method, :last!, :pop)
