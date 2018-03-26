# Tabletop.rb
# Tabletop

require_relative './Thoran/String/InstanceMethods'

class Tabletop
  
  attr_accessor :x_dimension, :y_dimension, :grid, :extras
  
  def initialize(x_dimension, y_dimension = nil)
    if y_dimension.nil?
      x_dimension, y_dimension = x_dimension.split('x')
    end
    @x_dimension = x_dimension.to_i
    @y_dimension = y_dimension.to_i
    @extras = false
    init_grid
  end
  
  def update(toy_robot)
    grid[toy_robot.old_x][toy_robot.old_y] = nil
    grid[toy_robot.x][toy_robot.y] = toy_robot
  end
  
  def [](x,y)
    grid[x][y]
  end
  
  def []=(x, y, toy_robot)
    grid[x][y] = toy_robot
  end
  
  def valid_location?(x,y)
    if extras
      x.to_i.between?(0, x_dimension - 1) && y.to_i.between?(0, y_dimension - 1) && grid[x][y].nil? ? true : false
    else
      x.to_i.between?(0, x_dimension - 1) && y.to_i.between?(0, y_dimension - 1) ? true : false
    end
  end
  
  def draw
    (y_dimension - 1).downto(0) do |y|
      0.upto(x_dimension - 1) do |x|
        if !grid[x][y].nil?
          print grid[x][y].name.justify(8)
        else
          print '.'.justify(8)
        end
      end
      puts
    end
  end
  
  private
  
  def init_grid
    @grid = []
    (0..x_dimension - 1).inject(@grid) do |a,e|
      a << (0..y_dimension - 1).inject([]){|b,f| b << nil}
    end
  end
  
end
