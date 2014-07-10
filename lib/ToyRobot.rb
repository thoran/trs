# ToyRobot

# 20120331
# 0.5.0

# Changes since 0.4: 
# 1. ~ tick(), so as it makes reference to placed?(), rather than implement that logic itself.  
# 2. + placed?().  

require_relative './String'
require_relative './ToyRobot/BasicInstructionSet'
require_relative './ToyRobot/Randomness'
require 'observer'

class ToyRobot
  
  include Observable
  
  attr_accessor :tabletop, :name, :x, :y, :f, :old_x, :old_y, :old_f, :extras
  attr_reader :random
  attr_writer :command_list
  
  def initialize(tabletop = nil, instruction_set = BasicInstructionSet, name = nil)
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
    @random = false
  end
  
  def load(program)
    if program
      @command_list = program.split("\n")
    end
  end
  
  def random=(random)
    if random
      @random = random
      ToyRobot.send(:include, Randomness)
      init_command_list
    end
  end
  
  # Only to be used if there is one robot, or if the robots are to be run sequentially.  
  def run
    until expired? do
      toy_robot.tick
    end
  end
  
  def tick
    if current_command = command_list.shift
      puts "#{name}'s pending command list: #{command_list.inject([]){|a,e| a << e.wrap('"')}.join(', ')}" if extras
      puts "#{name}'s next command is #{current_command}" if extras
      if unary_instruction?(current_command)
        if placed?
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
  
  def placed?
    self.x && self.y && self.f ? true : false
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
  
  def command_list
    @command_list
  end
  
  def valid_move?
    if placed?
      case self.f
      when 'NORTH'; tabletop.valid_location?(self.x, self.y+1)
      when 'SOUTH'; tabletop.valid_location?(self.x, self.y-1)
      when 'EAST'; tabletop.valid_location?(self.x+1, self.y)
      when 'WEST'; tabletop.valid_location?(self.x-1, self.y)
      end
    else
      false
    end
  end
  
  def unary_instruction?(s)
    s =~ /PLACE/ ? false : true
  end
  
end
