describe ToyRobotSimulator do
  
  describe 'initialization' do
    it 'should return a ToyRobot object' do
      ToyRobot.new.class.must_equal ToyRobot
    end
  end
  
end
