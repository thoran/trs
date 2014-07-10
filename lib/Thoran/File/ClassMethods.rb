module Thoran
  class File
    module ClassMethods
      
      def path_without_basename(path)
        path.split('/').all_but_last.join('/')
      end
      
    end
  end
end

File.send(:extend, Thoran::File::ClassMethods)
