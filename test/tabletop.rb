# test/tabletop.rb

require_relative '../lib/tabletop'
require 'minitest/autorun'

describe Tabletop do
  describe "valid_location?" do
    it "should be able to determine that a particular set of co-ordinates is valid and therefore on the tabletop or not" do
      tabletop = Tabletop.new
      _(tabletop.valid_location?(6,6)).must_equal(false)
      _(tabletop.valid_location?(5,5)).must_equal(false)
      _(tabletop.valid_location?(4,5)).must_equal(false)
      _(tabletop.valid_location?(5,4)).must_equal(false)
      _(tabletop.valid_location?(4,4)).must_equal(true)
      _(tabletop.valid_location?(0,4)).must_equal(true)
      _(tabletop.valid_location?(4,0)).must_equal(true)
      _(tabletop.valid_location?(0,0)).must_equal(true)
      _(tabletop.valid_location?(-1,0)).must_equal(false)
      _(tabletop.valid_location?(0,-1)).must_equal(false)
      _(tabletop.valid_location?(-1,-1)).must_equal(false)
    end
  end
end
