# ToyRobotSimulator.rb
# ToyRobotSimulator

require_relative './ToyRobot'
require_relative './Tabletop'

class ProgramNotFoundError < RuntimeError; end

class ToyRobotSimulator
  
  attr_accessor :program_name
  attr_accessor :programs_directory
  attr_accessor :tabletop
  attr_accessor :tabletop_dimensions
  attr_accessor :toy_robot
  
  class << self
    
    def defaults
      @defaults ||= {
        :programs_directory => File.join(File.dirname(__FILE__), '../programs'),
        :tabletop_dimensions => '5x5'
      }
    end
    
    def run
      ToyRobotSimulator.new(@defaults).run
    end
    
  end # class << self
  
  def initialize(*args)
    options = args.last.is_a?(::Hash) ? args.pop : {}
    @program_name = options[:program_name] if options[:program_name]
    @programs_directory = options[:programs_directory] || ToyRobotSimulator.defaults[:programs_directory]
    @tabletop_dimensions = options[:tabletop_dimensions] || ToyRobotSimulator.defaults[:tabletop_dimensions]
  end
  
  def setup
    init_tabletop(tabletop_dimensions)
    init_toy_robot
  end
  
  def run
    until @toy_robot.expired?
      @toy_robot.tick
    end
  end
  
  def update(toy_robot)
    tabletop.update(toy_robot)
  end
  
  private
  
  def init_tabletop(tabletop_dimensions = nil)
    tabletop_dimensions = (tabletop_dimensions ? tabletop_dimensions : self.tabletop_dimensions)
    @tabletop = Tabletop.new(tabletop_dimensions)
  end
  
  def init_toy_robot
    @toy_robot = ToyRobot.new
    @toy_robot.tabletop = tabletop
    @toy_robot.load(program)
    @toy_robot.add_observer(self)
  end
  
  def program
    if @program_name
      begin
        if program_name = File.basename(@program_name, '.program')
          if File.exist?(File.join(@programs_directory, program_name + '.program'))
            File.read(File.join(@programs_directory, program_name + '.program'))
          else
            raise ProgramNotFoundError
          end
        else
          raise ProgramNotFoundError          
        end
      rescue ProgramNotFoundError => e
        puts "Program '#{program_name}' not found."
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
