# lib/command_parser.rb

class CommandParser

  attr_accessor :command_list
  attr_accessor :toy_robot

  def initialize(program: nil, toy_robot: nil)
    @command_list = load(program) if program
    @toy_robot = toy_robot
  end

  def load(program)
    @command_list = program.split("\n")
  end

  def next
    if current_command = @command_list.shift
      if unary_instruction?(current_command)
        if toy_robot.placed?
          self.send(current_command.downcase)
        else
          raise UnplacedToyRobotError
        end
      else
        command, arguments = current_command.split
        x, y, facing = arguments.split(',')
        self.send(command.downcase, x.to_i, y.to_i, facing)
      end
    end
  end

  def place(x, y, facing)
    if toy_robot.tabletop.valid_location?(x,y)
      if toy_robot.placed?
        toy_robot.old_x, toy_robot.old_y, toy_robot.old_facing = toy_robot.x, toy_robot.y, toy_robot.facing
      else
        toy_robot.old_x, toy_robot.old_y, toy_robot.old_facing = x, y, facing
      end
      toy_robot.x, toy_robot.y, toy_robot.facing = x, y, facing
    end
  end

  def move
    if toy_robot.valid_move?
      toy_robot.old_x, toy_robot.old_y = toy_robot.x, toy_robot.y
      case toy_robot.facing
      when 'NORTH'; toy_robot.y += 1
      when 'SOUTH'; toy_robot.y -= 1
      when 'EAST'; toy_robot.x += 1
      when 'WEST'; toy_robot.x -= 1
      end
    end
  end

  def turn(direction)
    toy_robot.old_facing = toy_robot.facing
    case toy_robot.facing
    when 'NORTH'
      case direction.to_sym
      when :left; toy_robot.facing = 'WEST'
      when :right; toy_robot.facing = 'EAST'
      end
    when 'SOUTH'
      case direction.to_sym
      when :left; toy_robot.facing = 'EAST'
      when :right; toy_robot.facing = 'WEST'
      end
    when 'EAST'
      case direction.to_sym
      when :left; toy_robot.facing = 'NORTH'
      when :right; toy_robot.facing = 'SOUTH'
      end
    when 'WEST'
      case direction.to_sym
      when :left; toy_robot.facing = 'SOUTH'
      when :right; toy_robot.facing = 'NORTH'
      end
    end
  end

  def left
    turn(:left)
  end

  def right
    turn(:right)
  end

  def report
    unless toy_robot.x && toy_robot.y && toy_robot.facing
      puts "-,-,-"
    else
      puts "#{toy_robot.x},#{toy_robot.y},#{toy_robot.facing}"
    end
  end

  private

  def unary_instruction?(s)
    s !~ /PLACE/
  end

end
