# ToyRobotSimulator.rb
# ToyRobotSimulator

require_relative './Thoran/Array/InstanceMethods'
require_relative './ToyRobot'
require_relative './Tabletop'

class ProgramNotFoundError < RuntimeError; end

class ToyRobotSimulator

  attr_accessor :instruction_set
  attr_accessor :max_ticks
  attr_accessor :number_of_toy_robots
  attr_accessor :program
  attr_accessor :programs_directory
  attr_accessor :tabletop_dimensions

  attr_accessor :tabletop
  attr_accessor :toy_robots

  class << self

    def defaults
      @defaults ||= {
        number_of_toy_robots: 1,
        programs_directory: File.join(File.dirname(__FILE__), '../programs'),
        tabletop_dimensions: '5x5',
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
    @number_of_toy_robots ||= ToyRobotSimulator.defaults[:number_of_toy_robots]
    @programs_directory ||= ToyRobotSimulator.defaults[:programs_directory]
    @tabletop_dimensions ||= ToyRobotSimulator.defaults[:tabletop_dimensions]
  end

  def setup
    init_tabletop
    init_toy_robots
  end

  def run
    tick_count = -1
    puts "TICK: #{tick_count += 1}."
    tabletop.draw
    until toy_robots.expired? || tick_count_exceeded?(tick_count)
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

  # boolean methods

  def tick_count_exceeded?(tick_count)
    if @max_ticks
      tick_count > @max_ticks
    else
      false
    end
  end

  def init_tabletop
    @tabletop = Tabletop.new(@tabletop_dimensions)
  end

  def init_toy_robots
    @toy_robots = (
      toy_robots = []
      @number_of_toy_robots.times do
        toy_robots << init_toy_robot
      end
      toy_robots
    )
  end

  def init_toy_robot
    toy_robot = ToyRobot.new
    toy_robot.tabletop = @tabletop
    toy_robot.instruction_set = @instruction_set
    toy_robot.max_ticks = @max_ticks
    if @program
      toy_robot.load(@program)
    else
      toy_robot.class.send(:include, ToyRobot::CommandListRandomizer)
      toy_robot.max_ticks = 3
      toy_robot.init_command_list
    end
    toy_robot.add_observer(self)
    toy_robot
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
