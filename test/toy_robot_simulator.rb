# test/toy_robot_simulator.rb

require_relative '../lib/toy_robot_simulator'
require 'minitest/autorun'

describe ToyRobotSimulator do

  describe 'initialization' do
    it 'must return a ToyRobotSimulator object' do
      ToyRobotSimulator.new.class.must_equal ToyRobotSimulator
    end
  end

  describe 'setting attributes' do
    it 'must be able to set the tabletop attribute directly' do
      trs = ToyRobotSimulator.new
      trs.tabletop = Tabletop.new
      trs.instance_variable_get(:@tabletop).class.must_equal Tabletop
    end
  end

  describe 'executing a command' do
    before do
      @trs = ToyRobotSimulator.new
      @tabletop = Tabletop.new
      @trs.tabletop = @tabletop
      @trs.send(:init_toy_robot)
      @toy_robot = @trs.send(:toy_robot)
    end

    it 'must remove the next command from the command list' do
      program = 'PLACE 0,0,NORTH'
      @toy_robot.load(program)
      @toy_robot.send(:command_list).must_equal ['PLACE 0,0,NORTH']
      @trs.run
      @toy_robot.send(:command_list).must_equal []
    end

    it 'must be able to be place a robot on the tabletop' do
      program = 'PLACE 0,0,NORTH'
      @toy_robot.load(program)
      assert_nil(@tabletop[0,0])
      @trs.run
      @tabletop[0,0].must_equal @toy_robot
    end

    it 'must ignore any commands unless a place command has the toy robot on the tabletop' do
      command = 'LEFT'
      @toy_robot.load(command)
      assert_nil(@toy_robot.instance_variable_get(:@x))
      assert_nil(@toy_robot.instance_variable_get(:@y))
      assert_nil(@toy_robot.instance_variable_get(:@facing))
      @trs.run
      assert_nil(@toy_robot.instance_variable_get(:@x))
      assert_nil(@toy_robot.instance_variable_get(:@y))
      assert_nil(@toy_robot.instance_variable_get(:@facing))
    end

    it 'must be able to turn left' do
      program = "PLACE 0,0,NORTH\nLEFT\n"
      @toy_robot.load(program)
      @trs.run
      @toy_robot.facing.must_equal 'WEST'
    end

    it 'must be able to turn right' do
      program = "PLACE 0,0,NORTH\nRIGHT\n"
      @toy_robot.load(program)
      @trs.run
      @toy_robot.instance_variable_get(:@facing).must_equal 'EAST'
    end

    it 'must be able to move' do
      program = "PLACE 0,0,NORTH\nMOVE\n"
      @toy_robot.load(program)
      @trs.run
      @toy_robot.instance_variable_get(:@x).must_equal 0
      @toy_robot.instance_variable_get(:@y).must_equal 1
      @toy_robot.instance_variable_get(:@facing).must_equal 'NORTH'
    end

    it 'must be able to report' do
      program = "PLACE 0,0,NORTH\n"
      @toy_robot.load(program)
      @trs.run
      @toy_robot.load('report')
      lambda{@toy_robot.instance_variable_get(:@command_parser).report}.must_output "0,0,NORTH\n"
    end

    it 'must ignore any commands that would cause the toy robot to exit the tabletop in an unfortunate fashion' do
      program = "PLACE 0,0,NORTH\nLEFT\nMOVE\n"
      @toy_robot.load(program)
      @trs.run
      @toy_robot.instance_variable_get(:@x).must_equal 0
      @toy_robot.instance_variable_get(:@y).must_equal 0
      @toy_robot.instance_variable_get(:@facing).must_equal 'WEST'
    end
  end

end
