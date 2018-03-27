# ToyRobot/BasicInstructionSet.rb
# ToyRobot::BasicInstructionSet

class ToyRobot
  module BasicInstructionSet

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

  end
end
