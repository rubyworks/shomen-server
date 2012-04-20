module Shomen
  module Server
    module CLI

      # List command outputs a list of known viewers,
      # and marks which are already installed.
      #
      class List < Base
        # Iterate over know viewers, displaying each in turn
        # and marking them it they are already present.
        #
        # @return nothing
        def call
          VIEWER_REPOS.keys.each do |name|
            if File.exist?(File.join(Server.views_directory, name))
              puts "[x] #{name}"
            else
              puts "[ ] #{name}"
            end
          end
        end

        #
        # @return [OptionParser]
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
