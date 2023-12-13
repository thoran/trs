# lib/commands/right.rb

require_relative './base'
require_relative './concerns/turning'

module Commands
  class Right < Base
    include Turning

    def run
      turn
    end
  end
end
