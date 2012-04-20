module Shomen
  module Server
    module CLI

      # Run Shomen web server.
      #
      class Serve < Base
        #
        # Start the server.
        #
        def call
          Server.start(options)
        end

        #
        # @return [OptionParser]
        #
        def option_parser
          OptionParser.new do |opt|
            opt.on('--port PORT', 'server port number [3000]') do |port|
              options[:port] = port
            end
            opt.on('--debug', 'set $DEBUG to true') do
              $DEBUG = true
            end
            opt.on('--warn', 'set $VERBOSE to true') do
              $VERBOSE = true
            end
            opt.on('--help', 'display this help message') do
              puts opt
              puts "Viewer Commands: list, install, remove"
              exit 0
            end
          end
        end
      end

    end
  end
end
