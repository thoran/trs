# Tabletop

# 20120330
# 0.3.0

require_relative './String'

class Tabletop
  
  attr_accessor :x_dimension, :y_dimension, :toy_robots, :grid, :extras
  
  def initialize(x_dimension, y_dimension = nil)
    if y_dimension.nil?
      x_dimension, y_dimension = x_dimension.split('x')
    end
    @x_dimension = x_dimension.to_i
    @y_dimension = y_dimension.to_i
    @extras = false
    @toy_robots = []
    init_grid
  end
  
  def update(name, x, y, f)
    toy_robot = toy_robots.detect{|toy_robot| toy_robot.name == name}
    toy_robot.report if extras
    grid[toy_robot.old_x][toy_robot.old_y] = nil
    grid[x][y] = toy_robot
    draw if extras
  end
  
  def valid_location?(x, y)
    x.to_i.between?(0, x_dimension - 1) && y.to_i.between?(0, y_dimension - 1) ? true : false
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
  
  def init_grid
    @grid = []
    (0..x_dimension - 1).inject(@grid) do |a,e|
      a << (0..y_dimension - 1).inject([]){|b,f| b << nil}
    end
  end
  
end
