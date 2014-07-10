# ToyRobot

# 20120331
# 0.4.0

# Changes since 0.3: 
# 1. ~ tick() && ~ initialize(), so as to check if the robot has been placed on the tabletop, rather than using the default grid values.  
# 2. /unary?()/unary_instruction?()/, since it is the instruction which could be unary, not the toy robot.  
# + init_name(), so as to tidy initialize() some.  
# 3. + require_relative './String'.  
# 4. ~ tick to output the name of the robots command list for when extras is true.  

require_relative './String'
require_relative './ToyRobot/BasicInstructionSet'
require 'observer'

class ToyRobot
  
  include Observable
  
  attr_accessor :tabletop, :command_list, :name, :x, :y, :f, :old_x, :old_y, :old_f, :extras
  
  def initialize(tabletop, instruction_set = BasicInstructionSet, name = nil)
    @tabletop = tabletop
    self.class.send(:include, instruction_set)
    init_name(name)
    @x = nil
    @y = nil
    @f = nil
    @old_x = nil
    @old_y = nil
    @old_f = nil
    @extras = false
  end
  
  def load(program)
    @command_list = program.split("\n")
  end
  
  # Only to be used if there is one robot, or if the robots are to be run sequentially.  
  def run
    until expired? do
      toy_robot.tick
    end
  end
  
  def tick
    puts "#{name}'s command list: #{command_list.inject([]){|a,e| a << e.wrap('"')}.join(', ')}" if extras # => #{self.x},#{self.y},#{self.f}" if extras
    if current_command = command_list.shift
      if unary_instruction?(current_command)
        if self.x && self.y && self.f # Check to ensure that the robot is on the tabletop.  
          self.send(current_command.downcase)
        end
      else
        command, arguments = current_command.split
        x, y, f = arguments.split(',')
        self.send(command.downcase, x.to_i, y.to_i, f)
      end
    end
    report if extras && !expired?
  end
  
  def expired?
    command_list.empty?
  end
  
  private
  
  def init_name(name)
    @name = (
      if name
        name
      else
        name = ''
        name << ('a'..'z').to_a[rand(26)]
        name
      end
    )
  end
  
  def valid_move?
    case self.f
    when 'NORTH'; tabletop.valid_location?(self.x, self.y+1)
    when 'SOUTH'; tabletop.valid_location?(self.x, self.y-1)
    when 'EAST'; tabletop.valid_location?(self.x+1, self.y)
    when 'WEST'; tabletop.valid_location?(self.x-1, self.y)
    end
  end
  
  def unary_instruction?(s)
    s =~ /PLACE/ ? false : true
  end
  
end
