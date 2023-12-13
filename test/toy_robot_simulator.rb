# test/toy_robot_simulator.rb

require_relative '../lib/toy_robot_simulator'
require 'minitest/autorun'

describe ToyRobotSimulator do
  before do
    @trs = ToyRobotSimulator.new
    @trs.setup
    @toy_robot = @trs.instance_variable_get(:@toy_robot)
  end

  describe "setup" do
    it "must be able to set the tabletop attribute directly" do
      _(@trs.instance_variable_get(:@toy_robot).class).must_equal(ToyRobot)
    end
  end

  describe "run" do
    it "must remove the next command from the command list" do
      program = 'PLACE 0,0,NORTH'
      @toy_robot.load(program)
      _(@toy_robot.send(:command_list)).must_equal(['PLACE 0,0,NORTH'])
      @trs.run
      _(@toy_robot.send(:command_list)).must_equal([])
    end
  end
end
