# ToyRobot.rb
# ToyRobot

require_relative './Thoran/String/InstanceMethods'
require_relative './ToyRobot/BasicInstructionSet'
require_relative './ToyRobot/Randomness'
require 'observer'

class ToyRobot
  
  include Observable

  attr_accessor :command_list
  attr_accessor :name  
  attr_accessor :tabletop
  attr_accessor :old_x, :old_y, :old_f
  attr_accessor :x, :y, :f
  attr_reader :random
  
  def initialize(tabletop = nil, instruction_set = BasicInstructionSet, name = nil)
    @tabletop = tabletop
    self.class.send(:include, instruction_set)
    init_name(name)
    @old_x = nil
    @old_y = nil
    @old_f = nil
    @x = nil
    @y = nil
    @f = nil
    @random = false
  end
  
  def load(program)
    if program
      @command_list = program.split("\n")
    end
  end
  
  def random=(random)
    @random = random
    ToyRobot.send(:include, Randomness)
    init_command_list
  end
    
  def tick
    if current_command = @command_list.shift
      puts "#{name}'s pending command list: #{@command_list.inject([]){|a,e| a << e.wrap('"')}.join(', ')}"
      puts "#{name}'s next command is #{current_command}"
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
    report if !expired?
  end
  
  def expired?
    @command_list.empty?
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
