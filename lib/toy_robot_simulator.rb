# lib/toy_robot_simulator.rb

require_relative './unplaced_toy_robot_error'
require_relative './program_loader'
require_relative './tabletop'
require_relative './toy_robot'
require 'pry'

class ToyRobotSimulator
  class << self
    def defaults
      @defaults ||= {
        program_name: ProgramLoader.default_program,
        program_directory: ProgramLoader.default_programs_directory,
      }
    end

    def run(**kwargs)
      toy_robot_simulator = ToyRobotSimulator.new(**kwargs)
      toy_robot_simulator.setup
      toy_robot_simulator.run
    end
  end # class << self

  def initialize(**kwargs)
    @kwargs = kwargs
  end

  def setup
    @toy_robot = ToyRobot.new
    @tabletop = Tabletop.new
    @toy_robot.tabletop = @tabletop
    @toy_robot.load(program)
  end

  def run
    until @toy_robot.expired?
      @toy_robot.tick
    end
  rescue UnplacedToyRobotError
    puts "The toy robot could not be placed on the tabletop given the instructions presented."
  end

  private

  def program
    program_loader = ProgramLoader.new(**@kwargs)
    program_loader.load
  end
end
