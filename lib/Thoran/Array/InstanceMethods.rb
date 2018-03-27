module Thoran
  class Array
    module InstanceMethods

      def expired?
        all?(&:expired?)
      end

    end
  end
end

Array.send(:include, Thoran::Array::InstanceMethods)
