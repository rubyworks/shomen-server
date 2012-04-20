module Shomen
  module Server
    module CLI

      # Help command displays help document.
      #
      class Help < Base
        #
        # Display help.
        #
        def call
          puts
          puts "#{$0} list"
          puts "#{$0} install"
          puts "#{$0} update"
          puts "#{$0} remove"
          puts
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
