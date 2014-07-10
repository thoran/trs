# ToyRobotSimulator

# 20120330
# 0.3.0

require_relative './Array'
require_relative './File'
require_relative './ToyRobot'
require_relative './Tabletop'

class ProgramNotFoundError < RuntimeError; end

class ToyRobotSimulator
  
  attr_accessor :tabletop, :tabletop_dimensions, :programs_directory, :number_of_toy_robots, :extras
  attr_writer :toy_robots, :program
  
  class << self
    
    def run
      defaults = {
        :programs_directory => '../programs',
        :tabletop_dimensions => '5x5',
        :number_of_toy_robots => 1,
        :extras => false
      }
      ToyRobotSimulator.new(defaults).run
    end
    
  end
  
  def initialize(*args)
    options = args.extract_options!
    @program = options[:program]
    @programs_directory = options[:programs_directory]
    @tabletop_dimensions = options[:tabletop_dimensions]
    @number_of_toy_robots = options[:number_of_toy_robots]
    init_tabletop(tabletop_dimensions) if tabletop_dimensions
    init_toy_robots(number_of_toy_robots) if number_of_toy_robots
  end
  
  def run
    toy_robots.each do |toy_robot|
      tabletop.toy_robots << toy_robot
      toy_robot.load(program(@program))
      toy_robot.add_observer(self)
    end
    tick_count = -1
    puts "TICK: #{tick_count += 1}." if extras
    tabletop.draw if extras
    until toy_robots.expired?
      puts "TICK: #{tick_count += 1}." if extras
      toy_robots.each do |toy_robot|
        toy_robot.tick unless toy_robot.expired?
      end
    end
    unless extras
      # toy_robots.each{|toy_robot| toy_robot.report}
    end
  end
  
  def update(name, x, y, f)
    tabletop.update(name, x, y, f)
  end
  
  def init_tabletop(tabletop_dimensions = nil)
    tabletop_dimensions = (tabletop_dimensions ? tabletop_dimensions : self.tabletop_dimensions)
    @tabletop = Tabletop.new(tabletop_dimensions)
    @tabletop.extras = extras
  end
  
  def init_toy_robots(number_of_toy_robots = nil)
    number_of_toy_robots = (number_of_toy_robots ? number_of_toy_robots : self.number_of_toy_robots).to_i
    toy_robots(number_of_toy_robots)
  end
  
  private
  
  def toy_robots(n = 1)
    @toy_robots ||= (
      toy_robots = []
      n.times do
        toy_robot = ToyRobot.new(tabletop)
        toy_robot.extras = extras
        toy_robots << toy_robot
      end
      toy_robots
    )
  end
  
  def program(program_name = nil)
    if program_name
      begin
        if File.extname(program_name) == '.program'
          if File.path_without_basename(program_name).empty? && File.exist?("#{programs_directory}/#{program_name}")
            File.read("#{programs_directory}/#{program_name}")
          elsif File.exist?(program_name)
            File.read(program_name)
          else
            raise ProgramNotFoundError
          end
        else
          if File.path_without_basename(program_name).empty? && File.exist?("#{programs_directory}/#{program_name}" + '.program')
            File.read("#{programs_directory}/#{program_name}" + '.program')
          elsif File.exist?(program_name +  '.program')
            File.read(program_name + '.program')
          else
            raise ProgramNotFoundError
          end
        end
      rescue ProgramNotFoundError => e
        puts "Program #{program_name} not found."
        exit
      end
    else
      begin
        program_filenames = Dir["#{programs_directory}/*.program"]
        random_program_filename = program_filenames[rand(program_filenames.size)]
        File.read(random_program_filename)
      rescue
        puts "No program found."
        exit
      end
    end
  end
  
end
