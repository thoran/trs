# lib/commands/move.rb

require_relative './base'

module Commands
  class Move < Base
    def run
      if @toy_robot.valid_move?
        @toy_robot.x += movements[@toy_robot.facing.downcase.to_sym].first
        @toy_robot.y += movements[@toy_robot.facing.downcase.to_sym].last
      end
    end

    private

    def movements
      {
        north: [0, 1],
        south: [0, -1],
        east:  [1, 0],
        west:  [-1, 0],
      }
    end
  end
end
