# trs/test/ToyRobot

# 20120401
# 0.6.0

require_relative '../lib/ToyRobotSimulator'
gem 'minitest', '~> 2'
require 'minitest/autorun'

describe ToyRobotSimulator do
  
  describe 'initialization' do
    
    it 'must return a ToyRobot object' do
      ToyRobotSimulator.new.class.must_equal ToyRobotSimulator
    end
    
    it 'must set the tabletop dimensions via the constructor' do
      trs = ToyRobotSimulator.new(:tabletop_dimensions => '4x5')
      trs.instance_variable_get(:@tabletop_dimensions).must_equal '4x5'
    end
  end
  
  describe 'setting attributes' do
    
    it 'must initialize the tabletop upon setting the tabletop dimensions' do
      trs = ToyRobotSimulator.new(:tabletop_dimensions => '4x5')
      trs.instance_variable_get(:@tabletop).class.must_equal Tabletop
    end
    
    it 'must be able to set the tabletop attribute directly' do
      trs = ToyRobotSimulator.new
      trs.tabletop = Tabletop.new(4,5)
      trs.instance_variable_get(:@tabletop).class.must_equal Tabletop
    end
    
    it 'must initialize a toy robot' do
      
    end
    
  end
  
  describe 'executing a command' do
    
    it 'must be able to be place a robot on the tabletop' do
      command = 'PLACE 0,0,NORTH'
      trs = ToyRobotSimulator.new
      tabletop = Tabletop.new('5x5')
      trs.toy_robots = [ToyRobot.new(tabletop)]
      trs.tabletop = tabletop
      trs.send(:toy_robots).first.load(command)
      trs.send(:toy_robots).first.tabletop[0,0].must_equal nil
      trs.run
      # trs.send(:toy_robots).first.tabletop[0,0].must_equal trs.send(:toy_robots).first
    end
    
    it 'must ignore any commands unless a place command has the toy robot on the tabletop' do
      command = 'LEFT'
      trs = ToyRobotSimulator.new
      trs.toy_robots = [ToyRobot.new]
      trs.tabletop = Tabletop.new('5x5')
      trs.send(:toy_robots).first.load(command)
      trs.send(:toy_robots).first.x.must_equal nil
      trs.send(:toy_robots).first.y.must_equal nil
      trs.send(:toy_robots).first.f.must_equal nil
      trs.run
      trs.send(:toy_robots).first.x.must_equal nil
      trs.send(:toy_robots).first.y.must_equal nil
      trs.send(:toy_robots).first.f.must_equal nil
    end
    
    it 'must be able to turn left' do
      trs = ToyRobotSimulator.new
      tabletop = Tabletop.new('5x5')
      trs.toy_robots = [ToyRobot.new(tabletop)]
      trs.tabletop = tabletop
      trs.send(:toy_robots).first.place(0,0,'NORTH')
      trs.send(:toy_robots).first.left
      trs.send(:toy_robots).first.f.must_equal 'WEST'
    end
    
    it 'must be able to turn right' do
      trs = ToyRobotSimulator.new
      tabletop = Tabletop.new('5x5')
      trs.toy_robots = [ToyRobot.new(tabletop)]
      trs.tabletop = tabletop
      trs.send(:toy_robots).first.place(0,0,'NORTH')
      trs.send(:toy_robots).first.right
      trs.send(:toy_robots).first.f.must_equal 'EAST'
    end
    
    it 'must be able to move' do
      trs = ToyRobotSimulator.new
      tabletop = Tabletop.new('5x5')
      trs.toy_robots = [ToyRobot.new(tabletop)]
      trs.tabletop = tabletop
      trs.send(:toy_robots).first.place(0,0,'NORTH')
      trs.send(:toy_robots).first.move
      trs.send(:toy_robots).first.x.must_equal 0
      trs.send(:toy_robots).first.y.must_equal 1
      trs.send(:toy_robots).first.f.must_equal 'NORTH'
    end
    
    it 'must be able to report' do
      trs = ToyRobotSimulator.new
      tabletop = Tabletop.new('5x5')
      trs.toy_robots = [ToyRobot.new(tabletop)]
      trs.tabletop = tabletop
      trs.send(:toy_robots).first.place(0,0,'NORTH')
      trs.send(:toy_robots).first.x.must_equal 0
      lambda{trs.send(:toy_robots).first.report}.must_output "0,0,NORTH\n"
    end
    
    it 'must remove the next command from the command list' do
      trs = ToyRobotSimulator.new
      tabletop = Tabletop.new('5x5')
      trs.toy_robots = [ToyRobot.new(tabletop)]
      trs.tabletop = tabletop
      trs.send(:toy_robots).first.load('PLACE 0,0,NORTH')
      trs.send(:toy_robots).first.send(:command_list).must_equal ['PLACE 0,0,NORTH']
      trs.run
      trs.send(:toy_robots).first.send(:command_list).must_equal []
    end
    
    it 'must ignore any commands that would cause the toy robot to exit the stage in an unfortunate fashion' do
      trs = ToyRobotSimulator.new
      tabletop = Tabletop.new('5x5')
      trs.toy_robots = [ToyRobot.new(tabletop)]
      trs.tabletop = tabletop
      trs.send(:toy_robots).first.place(0,0,'NORTH')
      trs.send(:toy_robots).first.left
      trs.send(:toy_robots).first.move
      trs.send(:toy_robots).first.instance_variable_get(:@x).must_equal 0
      trs.send(:toy_robots).first.instance_variable_get(:@y).must_equal 0
      trs.send(:toy_robots).first.instance_variable_get(:@f).must_equal 'WEST'
    end
  end
  
end
