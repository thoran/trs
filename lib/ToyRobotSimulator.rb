# ToyRobotSimulator.rb
# ToyRobotSimulator

require_relative './Thoran/Array/InstanceMethods'
require_relative './ToyRobot'
require_relative './Tabletop'

class ProgramNotFoundError < RuntimeError; end

class ToyRobotSimulator

  attr_accessor :number_of_toy_robots
  attr_accessor :program
  attr_accessor :programs_directory
  attr_accessor :tabletop
  attr_accessor :tabletop_dimensions
  attr_accessor :random

  class << self

    def defaults
      @defaults ||= {
        programs_directory: File.join(File.dirname(__FILE__), '../programs'),
        tabletop_dimensions: '5x5',
        number_of_toy_robots: 1,
        random: false,
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
    @number_of_toy_robots = options[:number_of_toy_robots]
    @program = options[:program]
    @programs_directory = options[:programs_directory]
    @tabletop_dimensions = options[:tabletop_dimensions]
    @random = options[:random]
    set_defaults
  end

  def set_defaults
    @number_of_toy_robots = ToyRobotSimulator.defaults[:number_of_toy_robots] unless @number_of_toy_robots
    @programs_directory = ToyRobotSimulator.defaults[:programs_directory] unless @programs_directory
    @tabletop_dimensions = ToyRobotSimulator.defaults[:tabletop_dimensions] unless @tabletop_dimensions
    @random = ToyRobotSimulator.defaults[:random] unless @random
  end

  def setup
    init_tabletop
    init_toy_robots
  end

  def run
    tick_count = -1
    puts "TICK: #{tick_count += 1}."
    tabletop.draw
    until toy_robots.expired?
      puts "TICK: #{tick_count += 1}."
      toy_robots.each do |toy_robot|
        toy_robot.tick unless toy_robot.expired?
      end
      tabletop.draw
    end
    toy_robots.each{|toy_robot| toy_robot.report}
  end

  def update(toy_robot)
    tabletop.update(toy_robot)
  end

  private

  def init_tabletop
    @tabletop = Tabletop.new(@tabletop_dimensions)
  end

  def init_toy_robots
    @toy_robots = (
      toy_robots = []
      n.times do
        toy_robots << init_toy_robot
      end
      toy_robots
    )
  end

  def init_toy_robot
    toy_robot = ToyRobot.new
    toy_robot.tabletop = @tabletop
    toy_robot.random = @random
    toy_robot.load(@program)
    toy_robot.add_observer(self)
    toy_robot
  end

  def program
    if @program && !@random
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
