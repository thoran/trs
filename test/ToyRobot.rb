# trs/test/ToyRobot

# 20121009
# 0.8.0

require_relative '../lib/ToyRobot'
gem 'minitest', '~> 2'
require 'minitest/autorun'

describe ToyRobot do
  
  describe 'initialization' do
    
    it 'must return a ToyRobot object' do
      ToyRobot.new.class.must_equal ToyRobot
    end
    
  end
  
  describe 'loading a command' do
    
    it 'must be able to load commands' do
      command = 'PLACE 0,0,NORTH'
      tr = ToyRobot.new
      tr.load(command)
      tr.send(:command_list).must_equal ['PLACE 0,0,NORTH']
    end
    
  end
  
end
