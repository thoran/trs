if __FILE__ == $0
  require 'minitest/autorun'
  
  class TC_place < MiniTest::Unit::TestCase
    
    def test
      
    end
    
  end
  
end


hallway = Hallway.new(ARGV[0])
BoxProblem.new(hallway)
