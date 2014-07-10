# ToyRobot::BasicInstructionSet

# 20120331
# 0.5.0

# Changes since 0.4: 
# 1. ~ place(), since the old locations were being given the new locations, but I need to check to see if the toy robot has been placed as yet, in which case I do need to use the new locations.  
# 2. ~ place(), so as the assignments of the old values will only take place if the new values are valid, since otherwise the values shouldn't be changing.  
# 3. ~ move(), so as to make the same changes as made to place().  

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
      when 'SOUTH';
        case direction.to_sym
        when :left; self.f = 'EAST'
        when :right; self.f = 'WEST'
        end
      when 'EAST';
        case direction.to_sym
        when :left; self.f = 'NORTH'
        when :right; self.f = 'SOUTH'
        end
      when 'WEST'; 
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
      if extras
        unless x && y && f
          puts "#{name}: -,-,-"
        else
          puts "#{name}: #{x},#{y},#{f}"
        end
      else
        unless x && y && f
          puts "-,-,-"
        else
          puts "#{x},#{y},#{f}"
        end
      end
    end
    
  end
end
