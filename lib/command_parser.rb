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
      if valid_command?(current_command)
        if unary_command?(current_command)
          if toy_robot.placed?
            self.send(current_command.downcase)
          else
            raise UnplacedToyRobotError
          end
        else # PLACE the robot!
          command, arguments = current_command.split
          x, y, facing = arguments.split(',')
          self.send(command.downcase, x.to_i, y.to_i, facing)
        end
      end
      # Just ignoring dud instructions.
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
      toy_robot.x += movements[toy_robot.facing.downcase.to_sym].first
      toy_robot.y += movements[toy_robot.facing.downcase.to_sym].last
    end
  end


  def turn(direction)
    toy_robot.old_facing = toy_robot.facing
    toy_robot.facing = turns[toy_robot.facing.downcase.to_sym][direction.to_sym]
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

  def movements
    {
      north: [0, 1],
      south: [0, -1],
      east:  [1, 0],
      west:  [-1, 0],
    }
  end

  def turns
    {
      north: {left: 'WEST', right: 'EAST'},
      south: {left: 'EAST', right: 'WEST'},
      east:  {left: 'NORTH', right: 'SOUTH'},
      west:  {left: 'SOUTH', right: 'NORTH'},
    }
  end

  def unary_command?(command)
    command !~ /PLACE/
  end

  def valid_command?(command)
    command.strip =~ /PLACE \d, *\d, *(NORTH|SOUTH|EAST|WEST)/ ||
    %w{MOVE LEFT RIGHT REPORT}.include?(command.strip)
  end

end
