class File
  
  def self.path_without_basename(path)
    path.split('/').all_but_last.join('/')
  end
  
end
