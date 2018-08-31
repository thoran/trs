# lib/toy_robot.rb
# ToyRobot

require 'observer'

class ToyRobot

  include Observable

  attr_accessor :command_list
  attr_accessor :tabletop
  attr_accessor :old_x, :old_y, :old_f
  attr_accessor :x, :y, :f

  def initialize(command_list: nil, tabletop: nil)
    @command_list = command_list
    @tabletop = tabletop
    @old_x = nil
    @old_y = nil
    @old_f = nil
    @x = nil
    @y = nil
    @f = nil
  end

  def load(program)
    @command_list = program.split("\n")
  end

  def tick
    if current_command = @command_list.shift
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

  def place(x, y, f)
    if tabletop.valid_location?(x,y)
      if placed?
        @old_x, @old_y, @old_f = @x, @y, @f
      else
        @old_x, @old_y, @old_f = x, y, f
      end
      @x, @y, @f = x, y, f
      changed
      notify_observers(self)
    end
  end

  def move
    if valid_move?
      @old_x, @old_y = @x, @y
      case @f
      when 'NORTH'; @y += 1
      when 'SOUTH'; @y -= 1
      when 'EAST'; @x += 1
      when 'WEST'; @x -= 1
      end
      changed
      notify_observers(self)
    end
  end

  def turn(direction)
    @old_f = @f
    case @f
    when 'NORTH'
      case direction.to_sym
      when :left; @f = 'WEST'
      when :right; @f = 'EAST'
      end
    when 'SOUTH'
      case direction.to_sym
      when :left; @f = 'EAST'
      when :right; @f = 'WEST'
      end
    when 'EAST'
      case direction.to_sym
      when :left; @f = 'NORTH'
      when :right; @f = 'SOUTH'
      end
    when 'WEST'
      case direction.to_sym
      when :left; @f = 'SOUTH'
      when :right; @f = 'NORTH'
      end
    end
    changed
    notify_observers(self)
  end

  def left
    turn(:left)
  end

  def right
    turn(:right)
  end

  def report
    unless x && y && f
      puts "-,-,-"
    else
      puts "#{x},#{y},#{f}"
    end
  end

  def expired?
    @command_list.empty?
  end

  def placed?
    @x && @y && @f ? true : false
  end

  private

  def valid_move?
    if placed?
      case @f
      when 'NORTH'; @tabletop.valid_location?(@x, @y+1)
      when 'SOUTH'; @tabletop.valid_location?(@x, @y-1)
      when 'EAST'; @tabletop.valid_location?(@x+1, @y)
      when 'WEST'; @tabletop.valid_location?(@x-1, @y)
      end
    else
      false
    end
  end

  def unary_instruction?(s)
    s =~ /PLACE/ ? false : true
  end

end
