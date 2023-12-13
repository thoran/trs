# lib/commands/concerns/turning.rb

module Turning
  def turn
    currently_facing = @toy_robot.facing.downcase.to_sym
    turning = self.class.to_s.split('::').last.downcase.to_sym
    @toy_robot.facing = turns[currently_facing][turning]
  end

  def turns
    {
      north: {left: 'WEST', right: 'EAST'},
      south: {left: 'EAST', right: 'WEST'},
      east:  {left: 'NORTH', right: 'SOUTH'},
      west:  {left: 'SOUTH', right: 'NORTH'},
    }
  end
end
