# lib/toy_robot_simulator.rb

require_relative './toy_robot'
require_relative './tabletop'

class ProgramNotFoundError < RuntimeError; end

class ToyRobotSimulator

  class << self

    def default_programs_directory
      File.join(File.dirname(__FILE__), '../programs')
    end

    def random_program(programs_directory)
      begin
        program_filenames = Dir["#{programs_directory}/*.program"]
        if program_filenames.empty?
          raise ProgramNotFoundError
        else
          File.basename(program_filenames[rand(program_filenames.size)])
        end
      rescue ProgramNotFoundError => e
        puts "No program found."
        exit
      end
    end

    def default_program(default_programs_directory)
      random_program(default_programs_directory)
    end

    def defaults
      @defaults ||= {
        program: default_program(default_programs_directory),
        programs_directory: default_programs_directory
      }
    end

    def run(**switches)
      toy_robot_simulator = ToyRobotSimulator.new(**switches)
      toy_robot_simulator.setup
      toy_robot_simulator.run
    end

  end # class << self

  attr_accessor :program
  attr_accessor :programs_directory
  attr_accessor :tabletop
  attr_accessor :toy_robot

  def initialize(**switches)
    assign_ivars(switches)
    set_defaults
  end

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

  def init_tabletop
    @tabletop = Tabletop.new
  end

  def init_toy_robot
    @toy_robot = ToyRobot.new
    @toy_robot.tabletop = @tabletop
    @toy_robot.load(program)
    @toy_robot.add_observer(self)
  end

  def program_filename
    if File.exist?(File.join(@programs_directory, @program + '.program'))
      File.join(@programs_directory, @program + '.program')
    elsif File.exist?(File.join(@programs_directory, @program)) && File.extname(@program) == '.program'
      File.join(@programs_directory, @program)
    else
      raise ProgramNotFoundError
    end
  rescue ProgramNotFoundError => e
    puts "Program '#{@program}' not found."
    exit
  end

  def program
    File.read(program_filename)
  end

end
