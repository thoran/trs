# lib/toy_robot.rb

require 'observer'
require_relative 'command_parser'

class ToyRobot

  include Observable

  attr_accessor :program
  attr_accessor :tabletop
  attr_accessor :x, :y, :facing

  def initialize(program: nil, tabletop: nil)
    @program = program
    @tabletop = tabletop
    @x = nil
    @y = nil
    @facing = nil
  end

  def load(program = nil)
    @program = program || @program
    @command_parser = CommandParser.new(toy_robot: self)
    @command_parser.load(@program)
  end

  def tick
    @command_parser.next
    changed
    notify_observers(self)
  end

  def command_list
    @command_parser.command_list
  end

  def expired?
    command_list.empty?
  end

  def placed?
    @x && @y && @facing
  end

  def valid_move?
    if placed?
      case @facing
      when 'NORTH'; @tabletop.valid_location?(@x, @y+1)
      when 'SOUTH'; @tabletop.valid_location?(@x, @y-1)
      when 'EAST'; @tabletop.valid_location?(@x+1, @y)
      when 'WEST'; @tabletop.valid_location?(@x-1, @y)
      end
    else
      false
    end
  end

end
