# ToyRobot

# 20120330
# 0.3.0

require_relative './ToyRobot/BasicInstructionSet'
require 'observer'

class ToyRobot
  
  include Observable
  
  attr_accessor :tabletop, :command_list, :name, :x, :y, :f, :old_x, :old_y, :old_f, :extras
  
  def initialize(tabletop, instruction_set = BasicInstructionSet, name = nil)
    @tabletop = tabletop
    self.class.send(:include, instruction_set)
    @name = (
      if name
        name
      else
        name = ''
        # (rand(8) + 1).times{name << ('a'..'z').to_a[rand(26)]}
        name << ('a'..'z').to_a[rand(26)]
        name
      end
    )
    @x = 0
    @y = 0
    @f = 'NORTH'
    @old_x = 0
    @old_y = 0
    @old_f = 'NORTH'
  end
  
  def load(program)
    @command_list = program.split("\n")
  end
  
  def run
    until expired? do
      toy_robot.tick
    end
  end
  
  def tick
    p command_list if extras
    current_command = command_list.shift
    if current_command
      if unary?(current_command)
        self.send(current_command.downcase)
      else
        command, arguments = current_command.split
        x, y, f = arguments.split(',')
        self.send(command.downcase, x.to_i, y.to_i, f)
      end
    end
  end
  
  def expired?
    command_list.empty?
  end
  
  private
  
  def valid_move?
    case self.f
    when 'NORTH'; tabletop.valid_location?(self.x, self.y+1)
    when 'SOUTH'; tabletop.valid_location?(self.x, self.y-1)
    when 'EAST'; tabletop.valid_location?(self.x+1, self.y)
    when 'WEST'; tabletop.valid_location?(self.x-1, self.y)
    end
  end
  
  def unary?(s)
    s =~ /PLACE/ ? false : true
  end
  
end
