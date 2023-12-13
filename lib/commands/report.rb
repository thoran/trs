# lib/commands/report.rb

require_relative './base'

module Commands
  class Report < Base
    def run
      unless @toy_robot.x && @toy_robot.y && @toy_robot.facing
        puts "-,-,-"
      else
        puts "#{@toy_robot.x},#{@toy_robot.y},#{@toy_robot.facing}"
      end
    end
  end
end
