# ToyRobot::Randomness

# 20120401
# 0.7.0

# Changes since 0.6: 
# 0. None---version number bump.  

class ToyRobot
  module Randomness
    
    def init_command_list
      @command_list = (
        command_list = []
        random.times do
          command_list << random_command
        end
        command_list
      )
      p @command_list if extras
    end
    
    def random_command
      random_command = %w{PLACE LEFT RIGHT MOVE REPORT}[rand(5)]
      if unary_instruction?(random_command)
        random_command
      else
        "PLACE #{random_location(tabletop.x_dimension, tabletop.y_dimension).join(',')},#{random_direction}"
      end
    end
    
    def random_location(x,y)
      [rand(x), rand(y)]
    end
    
    def random_direction
      %w{NORTH SOUTH EAST WEST}[rand(4)]
    end
    
  end
end
