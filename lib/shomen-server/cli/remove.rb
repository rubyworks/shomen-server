module Shomen
  module Server
    module CLI

      # Remove command removes a viewer.
      #
      class Remove < Base
        #
        # Remove viewer.
        #
        def call(repo)
          Server.remove(repo)
        end

        #
        # @return [OptionParser]
        #
        def option_parser
          OptionParser.new do |opt|
            opt.on('-h', '--help') do
              puts opt
              exit 0
            end
          end
        end
      end

    end
  end
end
