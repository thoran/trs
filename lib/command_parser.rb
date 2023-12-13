# lib/command_parser.rb

require_relative './unplaced_toy_robot_error'

command_files = Dir.glob(File.expand_path('../commands/*', __FILE__))\
  .reject{|command_file| command_file.match(/base/)}\
  .reject{|command_file| File.directory?(command_file)}

command_files.each{|command_file| require command_file}

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
            Object.const_get("Commands::#{current_command.capitalize}").run(toy_robot: toy_robot)
          else
            raise UnplacedToyRobotError
          end
        else # PLACE the robot!
          _command, arguments = current_command.split
          x, y, facing = arguments.split(',')
          Commands::Place.run(toy_robot: toy_robot, x: x.to_i, y: y.to_i, facing: facing)
        end
      else
        raise "Invalid command"
      end
    end
  end

  private

  def unary_command?(command)
    command !~ /PLACE/
  end

  def valid_command?(command)
    command.strip =~ /PLACE \d+, *\d+, *(NORTH|SOUTH|EAST|WEST)/ ||
      %w{MOVE LEFT RIGHT REPORT}.include?(command.strip)
  end
end
