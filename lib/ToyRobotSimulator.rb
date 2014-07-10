# ToyRobotSimulator

# 20120331
# 0.4.0

# Changes since 0.3: 
# 1. ~ run(), so as toy_robots are not inserted into the Tabletop object.  
# 2. ~ run(), by removing the unused reporting on toy robots at the end of run(), since it wasn't being used and since that has been removed from Tabletop#update and placed instead into update() here.  I think it is marginally better that the tabletop not have responsibility for outputting the toy robot's status.  
# 3. + tabletop_dimensions=(), such that as soon as that variable is set, the init_tabletop() method can be run.  
# 4. + number_of_toy_robots=(), such that as soon as that variable is set, the init_toy_robots() method can be run.  
# 5. ~ update(), such the call to draw the tabletop is here now and has been removed from Tabletop#update.  
# 6. ~ update(), moved toy_robot.report'ing to ToyRobot#tick.  
# 7. ~ run(), so that it rather than update() does the tabletop drawing, since it was being drawn for every update per robot, not per tick.  

require_relative './Array'
require_relative './File'
require_relative './ToyRobot'
require_relative './Tabletop'

class ProgramNotFoundError < RuntimeError; end

class ToyRobotSimulator
  
  attr_accessor :tabletop, :programs_directory
  attr_reader :tabletop_dimensions, :number_of_toy_robots, :extras
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
    self.program = options[:program] if options[:program]
    self.programs_directory = options[:programs_directory] if options[:programs_directory]
    self.tabletop_dimensions = options[:tabletop_dimensions] if options[:tabletop_dimensions]
    self.number_of_toy_robots = options[:number_of_toy_robots] if options[:number_of_toy_robots]
  end
  
  def run
    tick_count = -1
    puts "TICK: #{tick_count += 1}." if extras
    tabletop.draw if extras
    until toy_robots.expired?
      puts "TICK: #{tick_count += 1}." if extras
      toy_robots.each do |toy_robot|
        toy_robot.tick unless toy_robot.expired?
      end
      tabletop.draw if extras
    end
    toy_robots.each{|toy_robot| toy_robot.report} if extras
  end
  
  def update(toy_robot)
    tabletop.update(toy_robot)
  end
  
  def program=(program)
    if program
      @program = program.split(',')
    end
  end
  
  def programs_directory=(programs_directory)
    if programs_directory
      @programs_directory = programs_directory
    end
  end
  
  def tabletop_dimensions=(tabletop_dimensions)
    if tabletop_dimensions
      @tabletop_dimensions = tabletop_dimensions
      init_tabletop(tabletop_dimensions)
    end
  end
  
  def number_of_toy_robots=(number_of_toy_robots)
    if number_of_toy_robots
      @number_of_toy_robots = number_of_toy_robots
      init_toy_robots(number_of_toy_robots)
    end
  end
  
  def extras=(extras)
    if extras
      @extras = extras
      tabletop.extras = extras
      toy_robots.each{|toy_robot| toy_robot.extras = extras}
    end
  end
  
  private
  
  def init_tabletop(tabletop_dimensions = nil)
    tabletop_dimensions = (tabletop_dimensions ? tabletop_dimensions : self.tabletop_dimensions)
    @tabletop = Tabletop.new(tabletop_dimensions)
    @tabletop.extras = extras
  end
  
  def init_toy_robots(number_of_toy_robots = nil)
    number_of_toy_robots = (number_of_toy_robots ? number_of_toy_robots : self.number_of_toy_robots).to_i
    toy_robots(number_of_toy_robots)
    toy_robots.each do |toy_robot|
      toy_robot.load(program)
      toy_robot.add_observer(self)
    end
  end
  
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
    if @program && !@program.empty?
      program(@program.shift)
    elsif program_name
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
