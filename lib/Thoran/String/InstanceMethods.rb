module Thoran
  class String
    module InstanceMethods

      def prepend(s)
        s + self
      end

      def postpend(s)
        self + s
      end

      def justify(spaces, side = :centered)
        spaces = (self.size > spaces ? self.size : spaces)
        case side.to_sym
        when :left
          self.postpend(' ' * (spaces - self.size))
        when :right
          self.prepend(' ' * (spaces - self.size))
        when :centered
          ' ' * ((spaces - self.size)/2) + self + ' ' * ((spaces - self.size)/2)
        end
      end

      def wrap(wrapper)
        wrapper + self + wrapper
      end

    end
  end
end

String.send(:include, Thoran::String::InstanceMethods)
