# lib/toy_robot_simulator.rb

require_relative './program_loader'
require_relative './toy_robot'
require_relative './tabletop'

class ToyRobotSimulator

  class << self

    def defaults
      @defaults ||= {
        program: ProgramLoader.new.load,
      }
    end

    def run(**switches)
      toy_robot_simulator = ToyRobotSimulator.new(**switches)
      toy_robot_simulator.setup
      toy_robot_simulator.run
    end

  end # class << self

  attr_accessor :program
  attr_accessor :tabletop
  attr_accessor :toy_robot

  def initialize(**switches)
    assign_ivars(switches)
    set_defaults
  end

  def setup
    init_tabletop
    init_toy_robot
  end

  def run
    until @toy_robot.expired?
      @toy_robot.tick
    end
  end

  def update(toy_robot)
    @tabletop.update(toy_robot)
  end

  private

  def assign_ivars(switches)
    switches.each do |k,v|
      instance_variable_set("@#{k}", v)
    end
  end

  def set_defaults
    ToyRobotSimulator.defaults.each do |default_name, default_value|
      if instance_variable_get("@#{default_name}").nil?
        instance_variable_set("@#{default_name}", default_value)
      end
    end
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
