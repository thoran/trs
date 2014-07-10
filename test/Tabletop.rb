require_relative '../lib/Tabletop'
require 'minitest/autorun'

describe Tabletop do
  
  describe 'initialization' do
    
    it 'should return a Tabletop object' do
      Tabletop.new('5x5').class.must_equal Tabletop
    end
    
    it 'should receive a string in the format XxY, where X and Y are integers and the lowercase x is literal and set the desired x and y dimensions of the tabletop' do
      tabletop = Tabletop.new('4x5')
      tabletop.x_dimension.must_equal 4
      tabletop.y_dimension.must_equal 5
    end
    
    it 'should optionally receive x and y dimensions as separate parameters' do
      tabletop = Tabletop.new(4, 5)
      tabletop.x_dimension.must_equal 4
      tabletop.y_dimension.must_equal 5
    end
    
  end
  
end
