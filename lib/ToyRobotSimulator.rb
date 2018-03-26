# ToyRobotSimulator.rb
# ToyRobotSimulator

require_relative './Thoran/Array/InstanceMethods'
require_relative './Thoran/File/ClassMethods'
require_relative './ToyRobot'
require_relative './Tabletop'

class ProgramNotFoundError < RuntimeError; end

class ToyRobotSimulator
  
  attr_accessor :tabletop, :programs_directory
  attr_reader :tabletop_dimensions, :number_of_toy_robots, :extras, :random
  attr_writer :toy_robots, :program
  
  class << self
    
    def defaults
      @defaults ||= {
        :programs_directory => File.join(File.dirname(__FILE__), '../programs'),
        :tabletop_dimensions => '5x5',
        :number_of_toy_robots => 1,
        :extras => false
      }
    end
    
    def run
      ToyRobotSimulator.new(@defaults).run
    end
    
  end
  
  def initialize(*args)
    options = args.extract_options!
    self.program = options[:program] if options[:program]
    self.programs_directory = options[:programs_directory] if options[:programs_directory]
    self.tabletop_dimensions = options[:tabletop_dimensions] if options[:tabletop_dimensions]
    self.number_of_toy_robots = options[:number_of_toy_robots] if options[:number_of_toy_robots]
    self.extras = options[:extras] if options[:extras]
    self.random = options[:random] if options[:random]
    set_defaults
  end
  
  def set_defaults
    self.programs_directory = ToyRobotSimulator.defaults[:programs_directory] unless @programs_directory
    init_tabletop(ToyRobotSimulator.defaults[:tabletop_dimensions]) unless @tabletop
    init_toy_robots(ToyRobotSimulator.defaults[:number_of_toy_robots]) unless @toy_robots
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
      @number_of_toy_robots = number_of_toy_robots.to_i
      init_toy_robots(@number_of_toy_robots)
    end
  end
  
  def extras=(extras)
    if extras
      @extras = extras
    end
  end
  
  def random=(random)
    if random
      @random = random.to_i
    end
  end
  
  private
  
  def init_tabletop(tabletop_dimensions = nil)
    tabletop_dimensions = (tabletop_dimensions ? tabletop_dimensions : self.tabletop_dimensions)
    @tabletop = Tabletop.new(tabletop_dimensions)
    @tabletop.extras = extras
  end
  
  def init_toy_robots(number_of_toy_robots = nil)
    number_of_toy_robots = (number_of_toy_robots ? number_of_toy_robots : self.number_of_toy_robots)
    toy_robots(number_of_toy_robots)
    toy_robots.each do |toy_robot|
      toy_robot.tabletop = tabletop
      toy_robot.extras = extras
      toy_robot.random = random
      toy_robot.load(program)
      toy_robot.add_observer(self)
    end
  end
  
  def toy_robots(n = 1)
    @toy_robots ||= (
      toy_robots = []
      n.times do
        toy_robots << ToyRobot.new
      end
      toy_robots
    )
  end
  
  def program(program_name = nil)
    if random
      nil
    elsif @program && !@program.empty?
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
  
end
