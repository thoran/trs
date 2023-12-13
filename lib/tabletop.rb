# lib/tabletop.rb

class Tabletop
  def initialize
    @x_dimension = 5
    @y_dimension = 5
  end

  def valid_location?(x, y)
    valid_x_location?(x) && valid_y_location?(y)
  end

  private

  def valid_x_location?(x)
    x.to_i.between?(0, @x_dimension - 1)
  end

  def valid_y_location?(y)
    y.to_i.between?(0, @y_dimension - 1)
  end
end
