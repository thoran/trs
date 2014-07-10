
class ToyRobot
  
  def self.place(x, y, f)
    ToyRobot.new(x, y, f)
  end
  
  attr_accessor :command_list, :x, :y, :f
  
  def initialize(x, y, f)
    @x, @y, @f = x, y, f
  end
  
  def load(program)
    command_list = program.split("\n")
  end
  
  def tick
    current_command = command_list.pop
    if unary?
      self.send(command_list.pop)
    else
      self.send(place, current_command)
    end
  end
  
  def update(x, y, f)
    
  end
  
  def valid_move?
    case f
    when 'NORTH'; valid_location?(x, y+1)
    when 'SOUTH'; valid_location?(x, y-1)
    when 'EAST'; valid_location?(x+1, y)
    when 'WEST'; valid_location?(x-1, y)
    end
  end
  
  def expired?
    command_list.empty?
  end
  
  def place(x, y, f)
    
  end
  
  def move
    if valid_move?
      
    end
  end
  
  def turn(direction)
    case f
    when 'NORTH'
      case direction.to_sym
      when :left; f = 'WEST'
      when :right; f = 'EAST'
      end
    when 'SOUTH';
      case direction.to_sym
      when :left; f = 'EAST'
      when :right; f = 'WEST'
    when 'EAST';
      case direction.to_sym
      when :left; f = 'NORTH'
      when :right; f = 'SOUTH'
      end
    when 'WEST'; 
      case direction.to_sym
      when :left; f = 'SOUTH'
      when :right; f = 'NORTH'
      end
  end
  
  def left
    turn(:left)
  end
  
  def right
    turn(:right)
  end
  
  def report
    puts "#{x} #{y} #{f}"
  end
  
  private
  
  def unary?(s)
    s =~ /PLACE/ ? false : true
  end
  
end
