# lib/commands/left.rb

require_relative './base'
require_relative './concerns/turning'

module Commands
  class Left < Base
    include Turning

    def run
      turn
    end
  end
end
