# Tabletop

# 20120331
# 0.4.0

# Changes since 0.3: 
# 1. - @toy_robots array---I never liked it being there, since the tabletop shouldn't need to have 'awareness' of all robots, unless they are placed in the grid, and even then, it is quite sufficient for the robot to be placed into the grid only at the current position.  
# 2. ~ update(), so as it receives a toy_robot object, rather making use of the @toy_robots array.  
# 3. - attr_accessor :toy_robots, since there is no @toy_robots array anymore.  
# 4. ~ update(), so as it doesn't send the report message to a toy robot, which is now handled in ToyRobotSimulator.  
# 5. ~ valid_location(), so as it will check to see if there is another toy robot is in the proposed location the toy robot wishes to move.  
# 6. ~ update(), so as it doesn't draw itself from within itself.  It should be able to update it's state without drawing itself, extras or no extras.  

require_relative './String'

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
  
  def init_grid
    @grid = []
    (0..x_dimension - 1).inject(@grid) do |a,e|
      a << (0..y_dimension - 1).inject([]){|b,f| b << nil}
    end
  end
  
end
