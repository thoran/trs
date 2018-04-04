# ToyRobot/CommandListRandomizer.rb
# ToyRobot::CommandListRandomizer

class ToyRobot
  module CommandListRandomizer

    def init_command_list(instruction_set: BasicInstructionSet)
      @command_list = (
        command_list = []
        @max_ticks.times do
          case instruction_set
          when BasicInstructionSet
            command_list << random_basic_instruction_set_command
          when AdvancedInstructionSet
            command_list << random_advanced_instruction_set_command
          end
        end
        command_list
      )
    end

    def random_basic_instruction_set_command
      random_command = %w{PLACE LEFT RIGHT MOVE REPORT}[rand(5)]
      if place?(random_command)
        random_command
      else
        "PLACE #{random_location(tabletop.x_dimension, tabletop.y_dimension).join(',')},#{random_direction}"
      end
    end

    def random_advanced_instruction_set_command
      random_command = %w{PLACE LEFT RIGHT MOVE REPORT, TELEPORT, ROOKY_MOVE}[rand(7)]
      if unary_instruction?(random_command)
        random_command
      elsif place?(random_command)
        "PLACE #{random_location(tabletop.x_dimension, tabletop.y_dimension).join(',')},#{random_direction}"
      elsif teleport?(random_command)
        "TELEPORT #{random_location(tabletop.x_dimension, tabletop.y_dimension).join(',')},#{random_direction}"
      elsif rooky_move?(random_command)
        "ROOKY_MOVE " # FIXME
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
