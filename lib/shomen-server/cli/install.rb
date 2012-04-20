module Shomen
  module Server
    module CLI

      # Install command installs a viewer.
      #
      class Install < Base
        #
        # Install viewer.
        #
        def call(repo)
          Server.install(repo)
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
