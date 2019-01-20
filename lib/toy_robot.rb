# lib/toy_robot.rb

require 'observer'
require_relative 'command_parser'

class UnplacedToyRobotError < StandardError; end

class ToyRobot

  include Observable

  attr_accessor :program
  attr_accessor :tabletop
  attr_accessor :old_x, :old_y, :old_facing
  attr_accessor :x, :y, :facing

  def initialize(program: nil, tabletop: nil)
    @program = program
    @tabletop = tabletop
    @old_x = nil
    @old_y = nil
    @old_facing = nil
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
  rescue UnplacedToyRobotError
  end

  def command_list
    @command_parser.command_list
  end

  # I thought about using delegation, but would need to do additional work around dynamically
  # creating those delegates depending if the set of commands is injectable, which sounds like a
  # reasonable challenge and it would allow for ensuring that the toy robot isn't being
  # given dud commands.  So for now it was either this or enumerating a fixed set of delegates.
  # And really, having methods which are delegated explicitly or implicitly is probably not ideal,
  # and I could do away with the need for this and delegates if I were to change the tests to
  # reflect the changes which have accrued by virtue of having a separate CommandParser class,
  # since this works just fine without, excepting for when being tested.
  def method_missing(method_name, *args, &block)
    @command_parser.send(method_name, *args, &block)
  end

  def expired?
    @command_parser.command_list.empty?
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
