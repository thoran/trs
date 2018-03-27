# trs/test/ToyRobot.rb

require_relative '../lib/ToyRobot'
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
