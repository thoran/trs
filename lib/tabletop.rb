# lib/tabletop.rb

class Tabletop

  attr_accessor :grid
  attr_accessor :x_dimension
  attr_accessor :y_dimension

  def initialize
    @x_dimension = 5
    @y_dimension = 5
    init_grid
  end

  def update(toy_robot)
    grid[toy_robot.x][toy_robot.y] = toy_robot
  end

  def [](x,y)
    grid[x][y]
  end

  def []=(x, y, toy_robot)
    grid[x][y] = toy_robot
  end

  def valid_location?(x,y)
    valid_x_location?(x) && valid_y_location?(y)
  end

  private

  def init_grid
    @grid = []
    (0..x_dimension - 1).inject(@grid) do |a,e|
      a << (0..y_dimension - 1).inject([]){|b,f| b << nil}
    end
  end

  def valid_x_location?(x)
    x.to_i.between?(0, x_dimension - 1)
  end

  def valid_y_location?(y)
    y.to_i.between?(0, y_dimension - 1)
  end

end
