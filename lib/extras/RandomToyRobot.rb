require_relative './Module'

module ToyRobotRandomness
  
  def included
    
  end
  
  def command_list
    [%w{LEFT, RIGHT, MOVE}.rand(3)]
  end
  
end
