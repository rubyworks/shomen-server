module Shomen
  module Server
    module CLI
      #
      # Command name to class mapping.
      #
      # @return [Hash] 
      #
      def self.commands
        @commands ||= {}
      end

      #
      # Run command designated by `argv`.
      #
      def self.run(*argv)
        if cmd = commands[argv.first]
          argv.shift
         else
          cmd = CLI::Serve
        end
        cmd.new.execute(*argv)
      end

      require 'optparse'
      require 'shomen-server/cli/base'
      require 'shomen-server/cli/serve'
      require 'shomen-server/cli/list'
      require 'shomen-server/cli/install'
      require 'shomen-server/cli/update'
      require 'shomen-server/cli/remove'
      require 'shomen-server/cli/help'
    end
  end
end
