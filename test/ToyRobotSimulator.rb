# trs/test/ToyRobot.rb

require_relative '../lib/ToyRobotSimulator'
gem 'minitest', '~> 2'
require 'minitest/autorun'

describe ToyRobotSimulator do

  describe 'initialization' do

    it 'must return a ToyRobotSimulator object' do
      ToyRobotSimulator.new.class.must_equal ToyRobotSimulator
    end

    it 'must set the tabletop dimensions via the constructor' do
      trs = ToyRobotSimulator.new(tabletop_dimensions: '4x5')
      trs.instance_variable_get(:@tabletop_dimensions).must_equal '4x5'
    end

    it 'must initialize a default tabletop' do
      trs = ToyRobotSimulator.new
      trs.tabletop.wont_equal nil
    end

    it 'must initialize a default toy robot' do
      trs = ToyRobotSimulator.new
      trs.send(:toy_robots).wont_equal nil
    end

  end

  describe 'setting attributes' do

    it 'will initialize the tabletop upon setting the tabletop dimensions' do
      trs = ToyRobotSimulator.new(tabletop_dimensions: '4x5')
      trs.instance_variable_get(:@tabletop).class.must_equal Tabletop
    end

    it 'must be able to set the tabletop attribute directly' do
      trs = ToyRobotSimulator.new
      trs.tabletop = Tabletop.new(4,5)
      trs.instance_variable_get(:@tabletop).class.must_equal Tabletop
    end

  end

  describe 'executing a command' do

    before do
      @trs = ToyRobotSimulator.new
      @tabletop = Tabletop.new('5x5')
      @trs.tabletop = @tabletop
      @toy_robot = @trs.send(:toy_robots).first
    end

    it 'must remove the next command from the command list' do
      @toy_robot.load('PLACE 0,0,NORTH')
      @toy_robot.send(:command_list).must_equal ['PLACE 0,0,NORTH']
      @trs.run
      @toy_robot.send(:command_list).must_equal []
    end

    it 'must be able to be place a robot on the tabletop' do
      command = 'PLACE 0,0,NORTH'
      @toy_robot.load(command)
      @tabletop[0,0].must_equal nil
      @trs.run
      @tabletop[0,0].must_equal @toy_robot
    end

    it 'must ignore any commands unless a place command has the toy robot on the tabletop' do
      command = 'LEFT'
      @toy_robot.load(command)
      @toy_robot.instance_variable_get(:@x).must_equal nil
      @toy_robot.instance_variable_get(:@y).must_equal nil
      @toy_robot.instance_variable_get(:@f).must_equal nil
      @trs.run
      @toy_robot.instance_variable_get(:@x).must_equal nil
      @toy_robot.instance_variable_get(:@y).must_equal nil
      @toy_robot.instance_variable_get(:@f).must_equal nil
    end

    it 'must be able to turn left' do
      @toy_robot.place(0,0,'NORTH')
      @toy_robot.left
      @toy_robot.f.must_equal 'WEST'
    end

    it 'must be able to turn right' do
      @toy_robot.place(0,0,'NORTH')
      @toy_robot.right
      @toy_robot.instance_variable_get(:@f).must_equal 'EAST'
    end

    it 'must be able to move' do
      @toy_robot.place(0,0,'NORTH')
      @toy_robot.move
      @toy_robot.instance_variable_get(:@x).must_equal 0
      @toy_robot.instance_variable_get(:@y).must_equal 1
      @toy_robot.instance_variable_get(:@f).must_equal 'NORTH'
    end

    it 'must be able to report' do
      @toy_robot.place(0,0,'NORTH')
      lambda{@toy_robot.report}.must_output "0,0,NORTH\n"
    end

    it 'must ignore any commands that would cause the toy robot to exit the stage in an unfortunate fashion' do
      @toy_robot.place(0,0,'NORTH')
      @toy_robot.left
      @toy_robot.move
      @toy_robot.instance_variable_get(:@x).must_equal 0
      @toy_robot.instance_variable_get(:@y).must_equal 0
      @toy_robot.instance_variable_get(:@f).must_equal 'WEST'
    end
  end

end
