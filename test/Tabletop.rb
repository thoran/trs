describe ToyRobot do
    
    describe 'parse()' do
      it 'should return an object of class ImpURI' do
        ImpURI.parse('http://example.com').class.must_equal ImpURI
      end
    end
  end
  
end

describe Tabletop do
  
end
