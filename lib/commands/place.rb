# lib/commands/place.rb

require_relative './base'
require_relative '../unplaced_toy_robot_error'

module Commands
  class Place < Base
    class << self
      def run(toy_robot:, x:, y:, facing:)
        new(toy_robot: toy_robot, x: x, y: y, facing: facing).run
      end
    end # class << self

    def initialize(toy_robot:, x:, y:, facing:)
      @toy_robot = toy_robot
      @x, @y = x, y
      @facing = facing
    end

    def run
      if @toy_robot.tabletop.valid_location?(@x, @y)
        @toy_robot.x, @toy_robot.y, @toy_robot.facing = @x, @y, @facing
      else
        raise UnplacedToyRobotError
      end
    end
  end
end
