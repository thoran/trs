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
        case side.to_sym
        when :left
          spaces = (self.size > spaces ? self.size : spaces)
          self.postpend(' ' * (spaces - self.size))
        when :right
          spaces = (self.size > spaces ? self.size : spaces)
          self.prepend(' ' * (spaces - self.size))
        when :centered
          spaces = (self.size > spaces ? self.size : spaces)
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
