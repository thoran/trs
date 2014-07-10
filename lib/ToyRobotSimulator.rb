class ToyRobotSimulator
  
  attr_accessor :tabletop, :toy_robot, :commands
  
  def initialize(command_string = nil)
    @command_string = command_string
    @tabletop = Tabletop.new(5,5)
    @toy_robot = ToyRobot.new(5,5)
    @toy_robot.program(command_string) if command_string
    @tabletop.add_observer(@toy_robot)
  end
  
  def run
    until toy_robot.expired? do
      toy_robot.tick
    end
  end
  
end
