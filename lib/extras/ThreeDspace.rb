class ThreeDspace
  
  attr_accessor :x_dimension, :y_dimension, :z_dimension, :toy_robots, :grid
  
  def initialize(x_dimension, y_dimension = nil, z_dimension = nil)
    if y_dimension.nil? && z_dimension.nil?
      xdimension, y_dimension, z_dimension = x_dimension.split(',')
    end
    @x_dimension = x_dimension
    @y_dimension = y_dimension
    @z_dimension = z_dimension
    @toy_robots = []
    init_grid
  end
  
  def update(name, x, y, z, f)
    toy_robot = toy_robots.detect{|toy_robot| toy_robot.name == name}
    toy_robot.x = x
    toy_robot.y = y
    toy_robot.z = z
    toy_robot.f = f
    toy_robot.g = g
    grid[x][y][z] = toy_robot
  end
  
  def valid_location?(x, y)
    x.between?(0, x_dimension) && y.between?(0, y_dimension) && z.between(0, z_dimension)? true : false
  end
  
  def draw
    z_dimensions.downto(0) do |z|
      y_dimensions.downto(0) do |y|
        0.upto(x_dimension) do |x|
          if !grid[x][y][z].nil?
            print grid[x][y][z].name
          else
            print '    .    '
          end
        end
        puts
      end
      puts
    end
  end
  
  def init_grid
    @grid = []
    (0..x_dimension - 1).inject(@grid) do |a,e|
      a << (0..y_dimension - 1).inject([]){|b,f| b << nil}
        b << (0..z_dimension - 1).inject([]){|c,g| b << nil}
      end
    end
  end
  
end
