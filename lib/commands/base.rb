# lib/commands/base.rb

module Commands
  class Base
    class << self
      def run(toy_robot:)
        new(toy_robot: toy_robot).run
      end
    end # class << self

    def initialize(toy_robot: nil)
      @toy_robot = toy_robot
    end
  end
end
