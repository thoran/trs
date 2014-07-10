# 20120328
# 0.0.0

class Tabletop
  
  include Observable
  
  attr_accessor :x, :y
  
  def initialize(x, y)
    @x_dimension = x_dimension
    @y_dimension = y_dimension
    @toy_robots = []
  end
  
  def toy_robots
    
  end
  
  def tick
    @toy_robots.tick
  end
  
  def valid_location?(x, y)
    x.between?(0, x_dimension) && y.between?(0, y_dimension) ? true : false
  end
  
end
