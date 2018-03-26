# ToyRobot.rb
# ToyRobot

require_relative './ToyRobot/BasicInstructionSet'
require 'observer'

class ToyRobot
  
  include Observable
  
  attr_accessor :tabletop, :x, :y, :f, :old_x, :old_y, :old_f
  attr_writer :command_list
  
  def initialize(tabletop = nil, instruction_set = BasicInstructionSet)
    @tabletop = tabletop
    self.class.send(:include, instruction_set)
    @x = nil
    @y = nil
    @f = nil
    @old_x = nil
    @old_y = nil
    @old_f = nil
  end
  
  def load(program)
    if program
      @command_list = program.split("\n")
    end
  end
  
  def tick
    if current_command = command_list.shift
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
  end
  
  def expired?
    command_list.empty?
  end
  
  def placed?
    self.x && self.y && self.f ? true : false
  end
  
  private
  
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
