# test/tabletop.rb

require_relative '../lib/tabletop'
require 'minitest/autorun'

describe Tabletop do

  describe 'initialization' do
    it 'should return a Tabletop object' do
      Tabletop.new.class.must_equal Tabletop
    end
  end

  describe 'how a toy robot knows that a potential move is valid or not' do
    it 'should be able to determine that a particular set of co-ordinates is valid and therefore on the tabletop or not' do
      tabletop = Tabletop.new
      tabletop.valid_location?(6,6).must_equal false
      tabletop.valid_location?(5,5).must_equal false
      tabletop.valid_location?(4,5).must_equal false
      tabletop.valid_location?(5,4).must_equal false
      tabletop.valid_location?(4,4).must_equal true
      tabletop.valid_location?(0,4).must_equal true
      tabletop.valid_location?(4,0).must_equal true
      tabletop.valid_location?(0,0).must_equal true
      tabletop.valid_location?(-1,0).must_equal false
      tabletop.valid_location?(0,-1).must_equal false
      tabletop.valid_location?(-1,-1).must_equal false
    end
  end

  describe 'getting a value in the grid' do
    before do
      @tabletop = Tabletop.new
    end

    it 'must be able to done via the grid method' do
      assert_nil(@tabletop.grid[0][0])
      @tabletop.grid[0][0] = 'toy_robot'
      @tabletop.grid[0][0].must_equal 'toy_robot'
    end

    it 'must be able to done via the bracket method' do
      assert_nil(@tabletop.grid[0][0])
      @tabletop.grid[0][0] = 'toy_robot'
      @tabletop[0,0].must_equal 'toy_robot'
    end
  end

  describe 'setting a value in the grid' do
    before do
      @tabletop = Tabletop.new
    end

    it 'must be able to done via the grid method' do
      assert_nil(@tabletop.grid[0][0])
      @tabletop.grid[0][0] = 'toy_robot'
      @tabletop.grid[0][0].must_equal 'toy_robot'
    end

    it 'must be able to done via the bracket method' do
      assert_nil(@tabletop.grid[0][0])
      @tabletop[0,0] = 'toy_robot'
      @tabletop[0,0].must_equal 'toy_robot'
    end
  end

end
