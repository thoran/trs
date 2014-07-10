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
      tr.command_list.must_equal ['PLACE 0,0,NORTH']
    end
    
  end
  
  describe 'executing a command' do
    
    it 'must be able to be placed on the tabletop' do
      command = 'PLACE 0,0,NORTH'
      tr = ToyRobot.new
      tr.load(command)
      tr.command_list.must_equal ['PLACE 0,0,NORTH']
      tr.tick
      
    end
    
    it 'should ignore any commands unless a place command has the toy robot on the tabletop' do
      
    end
    
    it 'should turn left' do
      
    end
    
    it 'should turn right' do
      
    end
    
    it 'should move' do
      
    end
    
    it 'should report' do
      
    end
    
    it 'should remove the command from the command list' do
      
    end
    
  end
  
end
