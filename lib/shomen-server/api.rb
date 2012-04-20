module Shomen
  module Server

    #
    class API

      def initialize(server, settings)
        @server  = server
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

      def route
        "#{name}-#{version}"
      end

      def link
        "#{name}-#{version}?doc=docs/#{doc_file}"
      end

      #
      def doc_path
        @doc_path ||= File.join(@server.docs_directory, doc_file)
      end

      #
      def doc_file
        "#{name}-#{version}.json"
      end

      # TODO: update to date instead?
      def has_doc?
        File.exist?(doc_path)
      end

    end

  end
end
