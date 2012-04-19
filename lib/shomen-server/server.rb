module Shomen

  # Shomen server present a web interface for viewing Shomen-based
  # documentation for all gems locally installed.
  #
  class Server
    #
    DIR = File.dirname(__FILE__)

    def self.start(options={})
      new(options).run
    end

    # Initialize new Server instance.
    def initialize(options={})
      @apis = []

      collect_gems
      #collect_rolls
      #collect_site
    end

    # Expanded path of documentation store directory. By default this in the user's
    # home directory at `~/.variable/shomen`.
    #
    # Returns String of path.
    def output
      @output ||= File.expand_path('~/.variable/shomen')
    end

    #
    def apis
      @apis
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
        if File.exist?('.yardopts')
          generate_via_yard
        else
          generate_via_rdoc
        end
      end
    end

    #
    def generate_via_rdoc(path)
      cli = Shomen::Rdoc::Generator.new(:store=>temp_dir, :format=>'json')
      json = cli.produce_json
      File.open(json_file, 'w'){ |f| f << json }
    end

    #
    def generate_via_yard(path)
      cli = Shomen::Yard::Generator.new(:store=>temp_dir, :format=>'json')
      json = cli.produce_json
      File.open(json_file, 'w'){ |f| f << json }
    end

    # Does the JSON file already exist or not?
    def exist?(path)
      json_file = File.join(output, File.basename(path) + '.json')
      File.exist?(json_file)
    end

    #
    def collect_rolls
       []  # TODO
    end

    #
    def collect_gems
      if defined?(::Gem)
        Gem::Specification.each do |spec|
          @apis << API.new(
            :path    => spec.gem_dir,
            :name    => spec.name,
            :version => spec.version.to_s,
            :title   => spec.name.capitalize
          )
        end
      end
    end

    #
    def collect_site
      [] # TODO
    end

=begin
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
            return route[:controller].call(env, match)
          end
        end
        default
      end
    end
=end

    #
    def app
      server = self
      Rack::Builder.new do
        use Rack::CommonLogger
        use Rack::ShowExceptions
        use Rack::Lint
        use Rack::Static, :urls => [DIR + '/assets']

        map "/" do
          run Proc.new{ |env| [ 200, {'Content-Type' => 'text/html'}, [server.index_page] ] }
        end

        run Proc.new{ |env| [ 200, {'Content-Type' => 'text/html'}, [server.documentation_page(env['REQUEST_PATH'])] ] }

        #run Router.new([
        #  {
        #    :pattern => %r{^/page1$}, 
        #    :controller => lambda do |env, match|
        #      [ 200, {'Content-Type' => 'text/html'}, 'page 1' ]
        #    end
        #  },
        #  {
        #    :pattern => %r{^/}, 
        #    :controller => lambda do |env, match|
        #      [ 200, {'Content-Type' => 'text/html'}, index_page ]
        #    end
        #  }
        #]);
      end
    end

    #
    def index_page
      text = File.read(DIR + '/index.rhtml')
      ERB.new(text).result(binding)
    end

    #
    def documentation_page(require_path)
      request_path.to_s
    end

    #
    def run
      Rack::Handler::Thin.run(app, :Port => 3000)
    end

  end

end
