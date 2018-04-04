# ToyRobotSimulator.rb
# ToyRobotSimulator

require_relative './ToyRobot'
require_relative './Tabletop'

class ProgramNotFoundError < RuntimeError; end

class ToyRobotSimulator

  attr_accessor :program
  attr_accessor :programs_directory

  attr_accessor :tabletop
  attr_accessor :toy_robot

  class << self

    def defaults
      @defaults ||= {
        programs_directory: File.join(File.dirname(__FILE__), '../programs'),
      }
    end

    def run(*args)
      toy_robot_simulator = ToyRobotSimulator.new(*args)
      toy_robot_simulator.setup
      toy_robot_simulator.run
    end

  end # class << self

  def initialize(*args)
    options = args.last.is_a?(::Hash) ? args.pop : {}
    assign_ivars(options)
    set_defaults
  end

  def assign_ivars(options)
    options.each do |k,v|
      instance_variable_set("@#{k}", v)
    end
  end

  def set_defaults
    @programs_directory ||= ToyRobotSimulator.defaults[:programs_directory]
  end

  def setup
    init_tabletop
    init_toy_robot
  end

  def run
    until @toy_robot.expired?
      @toy_robot.tick
    end
    @toy_robot.report
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
    @toy_robot.load(@program)
    @toy_robot.add_observer(self)
  end

  def program
    if @program
      begin
        if program = File.basename(@program, '.program')
          if File.exist?(File.join(@programs_directory, program + '.program'))
            File.read(File.join(@programs_directory, program + '.program'))
          else
            raise ProgramNotFoundError
          end
        else
          raise ProgramNotFoundError
        end
      rescue ProgramNotFoundError => e
        puts "Program '#{program}' not found."
        exit
      end
    else
      random_program
    end
  end

  def random_program
    begin
      program_filenames = Dir["#{programs_directory}/*.program"]
      if program_filenames.empty?
        raise ProgramNotFoundError
      else
        random_program_filename = program_filenames[rand(program_filenames.size)]
        File.read(random_program_filename)
      end
    rescue ProgramNotFoundError => e
      puts "No program found."
      exit
    end
  end

end
