# lib/toy_robot_simulator.rb

require_relative './program_loader'
require_relative './tabletop'
require_relative './toy_robot'

class ToyRobotSimulator

  class << self

    def defaults
      @defaults ||= {
        program_name: ProgramLoader.default_program,
        program_directory: ProgramLoader.default_programs_directory,
      }
    end

    def run(**switches)
      toy_robot_simulator = ToyRobotSimulator.new(**switches)
      toy_robot_simulator.setup
      toy_robot_simulator.run
    end

  end # class << self

  attr_accessor :tabletop
  attr_accessor :toy_robot

  def initialize(**switches)
    @switches = switches
  end

  def setup
    init_tabletop
    init_toy_robot
  end

  def run
    until @toy_robot.expired?
      @toy_robot.tick
    end
  rescue UnplacedToyRobotError
    puts "The toy robot could not be placed on the tabletop given the instructions presented."
  end

  def update(toy_robot)
    @tabletop.update(toy_robot)
  end

  private

  def program
    program_loader = ProgramLoader.new(@switches)
    program_loader.load
  end

  def init_tabletop
    @tabletop = Tabletop.new
  end

  def init_toy_robot
    @toy_robot = ToyRobot.new
    @toy_robot.tabletop = @tabletop
    @toy_robot.load(program)
    @toy_robot.add_observer(self)
  end

end
