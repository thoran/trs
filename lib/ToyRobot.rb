module ToyRobot::BasicInstructionSet
  
  def place(x, y, f)
    if valid_location?(x, y)
      @x, @y, @f = x, y, f
      changed
      notify_observers(name, x, y, f)
    end
  end
  
  def move
    if valid_move?
      case f
      when 'NORTH'; y += 1
      when 'SOUTH'; y -= 1
      when 'EAST'; x += 1
      when 'WEST'; x -= 1
      end
      changed
      notify_observers(name, x, y, f)
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
      end
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
    changed
    notify_observers(name, x, y, f)
  end
  
  def left
    turn(:left)
  end
  
  def right
    turn(:right)
  end
  
  def report
    puts "#{x},#{y},#{f}"
  end
  
end # module ToyRobot::BasicInstructionSet

class ToyRobot
  
  include Observable
  
  attr_accessor :command_list, :name, :x, :y, :f
  
  def initialize(instruction_set = BasicInstructionSet, name = nil)
    self.class.send(:include, instruction_set)
    @name = (
      if name
        name
      else
        name = ''
        (rand(8) + 1).times{name << ('a'..'z').to_a[rand(26)]}
        name
      end
    )
    @x = 0
    @y = 0
    @f = 'NORTH'
  end
  
  def load(program)
    command_list = program.split("\n")
  end
  
  def run
    until expired? do
      toy_robot.tick
    end
  end
  
  def tick
    current_command = command_list.pop
    if current_command
      if unary?(s)
        self.send(current_command.downcase)
      else
        place, arguments = current_command.split
        x, y, f = arguments.split(',')
        self.send(place.downcase, x, y, f)
      end
    end
  end
  
  private
  
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
  
  def unary?(s)
    s =~ /PLACE/ ? false : true
  end
  
end # class ToyRobot
