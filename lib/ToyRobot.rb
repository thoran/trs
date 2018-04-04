# ToyRobot.rb
# ToyRobot

require 'observer'

class ToyRobot

  include Observable

  attr_accessor :command_list
  attr_accessor :tabletop
  attr_accessor :old_x, :old_y, :old_f
  attr_accessor :x, :y, :f

  def initialize(command_list: nil, tabletop: nil)
    self.command_list = command_list
    @tabletop = tabletop
    @old_x = nil
    @old_y = nil
    @old_f = nil
    @x = nil
    @y = nil
    @f = nil
  end

  def load(program)
    if program
      @command_list = program.split("\n")
    end
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
        self.old_x, self.old_y, self.old_f = self.x, self.y, self.f
      else
        self.old_x, self.old_y, self.old_f = x, y, f
      end
      self.x, self.y, self.f = x, y, f
      changed
      notify_observers(self)
    end
  end

  def move
    if valid_move?
      self.old_x, self.old_y = self.x, self.y
      case self.f
      when 'NORTH'; self.old_y = self.y; self.y += 1
      when 'SOUTH'; self.old_y = self.y; self.y -= 1
      when 'EAST'; self.old_x = self.x; self.x += 1
      when 'WEST'; self.old_x = self.x; self.x -= 1
      end
      changed
      notify_observers(self)
    end
  end

  def turn(direction)
    self.old_f = self.f
    case self.f
    when 'NORTH'
      case direction.to_sym
      when :left; self.f = 'WEST'
      when :right; self.f = 'EAST'
      end
    when 'SOUTH'
      case direction.to_sym
      when :left; self.f = 'EAST'
      when :right; self.f = 'WEST'
      end
    when 'EAST'
      case direction.to_sym
      when :left; self.f = 'NORTH'
      when :right; self.f = 'SOUTH'
      end
    when 'WEST'
      case direction.to_sym
      when :left; self.f = 'SOUTH'
      when :right; self.f = 'NORTH'
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
    self.x && self.y && self.f ? true : false
  end

  private

  def valid_move?
    if placed?
      case self.f
      when 'NORTH'; @tabletop.valid_location?(self.x, self.y+1)
      when 'SOUTH'; @tabletop.valid_location?(self.x, self.y-1)
      when 'EAST'; @tabletop.valid_location?(self.x+1, self.y)
      when 'WEST'; @tabletop.valid_location?(self.x-1, self.y)
      end
    else
      false
    end
  end

  def unary_instruction?(s)
    s =~ /PLACE/ ? false : true
  end

end
