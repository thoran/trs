# test/toy_robot.rb

require_relative '../lib/toy_robot'
require 'minitest/autorun'

describe ToyRobot do
  before do
    @tabletop = Tabletop.new
    @toy_robot = ToyRobot.new(tabletop: @tabletop)
  end

  describe "loading a command" do
    it "must be able to load commands" do
      command = 'PLACE 0,0,NORTH'
      @toy_robot.load(command)
      _(@toy_robot.send(:command_list)).must_equal(['PLACE 0,0,NORTH'])
    end
  end

  describe "placing" do
    it "must be able to be place a robot on the tabletop" do
      program = 'PLACE 0,0,NORTH'
      @toy_robot.load(program)
      assert_nil(@toy_robot.x)
      assert_nil(@toy_robot.y)
      @toy_robot.tick
      _(@toy_robot.x).must_equal(0)
      _(@toy_robot.y).must_equal(0)
      _(@toy_robot.facing).must_equal('NORTH')
    end
  end

  describe "receiving other than a place command before being placed" do
    it "will raise an error if acommand is encountered" do
      command = 'LEFT'
      @toy_robot.load(command)
      assert_nil(@toy_robot.instance_variable_get(:@x))
      assert_nil(@toy_robot.instance_variable_get(:@y))
      assert_nil(@toy_robot.instance_variable_get(:@facing))
      _(lambda{@toy_robot.tick}).must_raise(UnplacedToyRobotError)
    end
  end

  describe "turning left" do
    it "must be able to turn left" do
      program = "PLACE 0,0,NORTH\nLEFT\n"
      @toy_robot.send(:load, program)
      @toy_robot.tick
      @toy_robot.tick
      _(@toy_robot.facing).must_equal('WEST')
    end
  end

  describe "turning right" do
    it "must be able to turn right" do
      program = "PLACE 0,0,NORTH\nRIGHT\n"
      @toy_robot.send(:load, program)
      @toy_robot.tick
      @toy_robot.tick
      _(@toy_robot.instance_variable_get(:@facing)).must_equal('EAST')
    end
  end

  describe "moving" do
    it "must be able to move" do
      program = "PLACE 0,0,NORTH\nMOVE\n"
      @toy_robot.load(program)
      @toy_robot.tick
      @toy_robot.tick
      _(@toy_robot.instance_variable_get(:@x)).must_equal(0)
      _(@toy_robot.instance_variable_get(:@y)).must_equal(1)
      _(@toy_robot.instance_variable_get(:@facing)).must_equal('NORTH')
    end
  end

  describe "reporting" do
    it "must be able to report" do
      program = "PLACE 0,0,NORTH\nREPORT\n"
      @toy_robot.load(program)
      @toy_robot.tick
      _(lambda{@toy_robot.tick}).must_output("0,0,NORTH\n")
    end
  end

  describe "checking tabletop bounds" do
    it "must ignore any commands that would cause the toy robot to exit the tabletop in an unfortunate fashion" do
      program = "PLACE 0,0,NORTH\nLEFT\nMOVE\n"
      @toy_robot.load(program)
      @toy_robot.tick
      @toy_robot.tick
      @toy_robot.tick
      _(@toy_robot.instance_variable_get(:@x)).must_equal(0)
      _(@toy_robot.instance_variable_get(:@y)).must_equal(0)
      _(@toy_robot.instance_variable_get(:@facing)).must_equal('WEST')
    end
  end
end
