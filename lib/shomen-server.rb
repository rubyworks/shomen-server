module Shomen

  # Shomen server present a web interface for viewing Shomen-based
  # documentation for all gems locally installed.
  #
  class Server

    require 'tmpdir'

    # Initialize new Server instance.
    def initialize(options={})
      @paths = Array(options[:paths] || default_paths)
    end

    # Expanded path of documentation store directory. By defaul this in the user's
    # home directory at `~/.variable/shomen`.
    #
    # Returns String of path.
    def output
      @output ||= File.expand_path('~/.variable/shomen')
    end

    #
    def paths
      @paths
    end

    # Generate documentation for given library path.
    #
    # path - 
    #
    # Returns nothing.
    def generate(path)
      temp_dir  = File.join(Dir.tmpdir, File.basename(path))
      json_file = File.join(output, File.basename(path) + '.json')

      Dir.chdir(path) do
        cli = Shomen::CLI.new('--store', temp_dir, '--format', 'json')
        json = cli.produce_json
        File.open(json_file, 'w'){ |f| f << json }
      end
    end

    # Does the JSON file already exist or not?
    def exist?(path)
      json_file = File.join(output, File.basename(path) + '.json')
      File.exist?(json_file)
    end

  private

    #
    def default_paths
      roll_paths + gem_paths + site_paths
    end

    #
    def roll_paths
       []  # TODO
    end

    #
    def gem_paths
      Dir.glob(File.join(ENV['GEM_PATH'], 'gems', '*'))
    end

    #
    def site_paths
      [] # TODO
    end

    # Simple router class for Rack.
    #
    class Router
      def initialize(routes)    
        @routes = routes
      end
      def default
        [ 404, {'Content-Type' => 'text/plain'}, 'file not found' ]
      end
      def call(env)
        @routes.each do |route|
          match = env['REQUEST_PATH'].match(route[:pattern])
          if match
            return route[:controller].call( env, match )
          end
        end
        default
      end
    end

  end

end
