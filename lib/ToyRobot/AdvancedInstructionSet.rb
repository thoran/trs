# ToyRobot/AdvancedInstructionSet.rb
# ToyRobot::AdvancedInstructionSet

class ToyRobot
  module AdvancedInstructionSet

    include BasicInstructionSet

    def teleport(new_x = nil, new_y = nil)
      if valid_teleport_move?(new_x, new_y)
        self.old_x, self.old_y = self.x, self.y
        self.x = new_x || rand(@tabletop.x_dimension)
        self.y = new_y || rand(@tabletop.y_dimension)
        changed
        notify_observers(self)
      end
    end

    # FIXME
    def rooky_move()
      if valid_rooky_move?
        self.old_x, self.old_y = self.x, self.y

        changed
        notify_observers(self)
      end
    end
  end

  def valid_teleport_move?(new_x, new_y)
    @tabletop.valid_location?(new_x, new_y)
  end

  def valid_rooky_move?
    if placed?
      @tabletop.valid_location?(self.x+1, self.y+2) ||
      @tabletop.valid_location?(self.x-1, self.y+2) ||      
      @tabletop.valid_location?(self.x+2, self.y+1) ||
      @tabletop.valid_location?(self.x-2, self.y+1) ||
      @tabletop.valid_location?(self.x+2, self.y-1) ||
      @tabletop.valid_location?(self.x-2, self.y-1) ||
      @tabletop.valid_location?(self.x+1, self.y-2) ||
      @tabletop.valid_location?(self.x-1, self.y-2)
    else
      false
    end
  end

  def unary_instruction?(s)
    place?(s) || teleport?(s) || rooky_move?(s) ? false : true
  end

  def teleport?(s)
    s =~ /TELEPORT/
  end

  def rooky_move?(s)
    s =~ /ROOKY_MOVE/
  end

end
