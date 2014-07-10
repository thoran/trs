# 20120328, 29

require_relative './ToyRobot'
require_relative './Tabletop'

class ToyRobotSimulator
  
  attr_accessor :tabletop
  attr_writer :toy_robots
  
  def initialize
    @tabletop = Tabletop.new(5,5)
  end
  
  def run
    until toy_robots.expired
      toy_robots.each do |toy_robot|
        tabletop.toy_robots << toy_robot
        toy_robot.load(program)
        toy_robot.add_observer(self)
        toy_robot.tick
      end
    end
  end
  
  def update(x, y, f)
    tabletop.update(x, y, f)
  end
  
  def toy_robots
    @toy_robots ||= (
      [ToyRobot.new]
    )
  end
  
end
