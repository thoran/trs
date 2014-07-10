module ToyRobot
  
  module ThreeDInstructionSet
    
    def place(x, y, z, f, g)
      if valid_location?(x, y, z)
        @x, @y, @z, @f, @g = x, y, z, f, g
        changed
        notify_observers(name, x, y, z, f, g)
      end
    end
    
    def move
      if valid_move?
        case f
        when 'NORTH'; y += 1
        when 'SOUTH'; y -= 1
        when 'EAST'; x += 1
        when 'WEST'; x -= 1
        when 'UP'; x += 1
        when 'DOWN'; x -= 1
        end
        changed
        notify_observers(name, x, y, f)
      end
    end
    
    def turn(direction)
      case f
      when 'NORTH'
        case direction.to_sym
        when :left; f = 'WEST'
        when :right; f = 'EAST'
        end
      when 'SOUTH';
        case direction.to_sym
        when :left; f = 'EAST'
        when :right; f = 'WEST'
        end
      when 'EAST';
        case direction.to_sym
        when :left; f = 'NORTH'
        when :right; f = 'SOUTH'
        end
      when 'WEST'; 
        case direction.to_sym
        when :left; f = 'SOUTH'
        when :right; f = 'NORTH'
        end
      end
      case g
      when 'UP'
        case direction.to_sym
        when :up; g = 'UP'
        when :down; g = 'HORIZONTAL'
        end
      when 'DOWN'
        case direction.to_sym
        when :up; f = 'HORIZONTAL'
        when :down; f = 'DOWN'
        end
      end
      changed
      notify_observers(name, x, y, z, f, g)
    end
    
    def left
      turn(:left)
    end
    
    def right
      turn(:right)
    end
    
    def up
      turn(:up)
    end
    
    def down
      turn(:down)
    end
    
    def report
      puts "#{x},#{y},#{z},#{f}"
    end
    
  end
end
