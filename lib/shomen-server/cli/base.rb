module Shomen
  module Server
    module CLI
      require 'optparse'

      #
      # Base class for all commands.
      #
      class Base
        #
        def self.inherited(subclass)
          name = subclass.name.split('::').last.downcase
          CLI.commands[name] = subclass
        end

        #
        def initialize
          @options = {}
        end

        #
        def options
          @options
        end

        #
        def execute(*argv)
          option_parser.parse(argv)
          call(*argv)
        end
      end

    end
  end
end
