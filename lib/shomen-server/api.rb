module Shomen

  class Server

    #
    class API

      def initialize(settings)
        @path    = settings[:path]
        @name    = settings[:name]
        @version = settings[:version]
        @title   = settings[:title]
      end

      def path
        @path
      end

      def name
        @name
      end

      def version
        @version
      end

      def title
        @title
      end

    end

  end

end
