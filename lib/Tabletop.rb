# 20120328
# 0.0.0

class Tabletop
  
  attr_accessor :x_dimension, :y_dimension, :toy_robots
  
  def initialize(x_dimension, y_dimension)
    @x_dimension = x_dimension
    @y_dimension = y_dimension
    @toy_robots = []
  end
  
  def update(name, x, y, f)
    toy_robot = toy_robots.detect{|toy_robot| toy_robot.name == name}
    toy_robot.x = x
    toy_robot.y = y
    toy_robot.f = f
  end
  
  def valid_location?(x, y)
    x.between?(0, x_dimension) && y.between?(0, y_dimension) ? true : false
  end
  
  def draw
    y_dimensions.downto(0) do |y|
      0.upto(x_dimension) do |x|
        if 
      end
    end
  end
  
end
