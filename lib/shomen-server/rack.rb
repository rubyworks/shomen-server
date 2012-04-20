module Shomen
  module Server

    # Shomen RackApp presents a web interface for viewing Shomen-based
    # documentation for all gems locally installed.
    #
    class RackApp

      #
      DIR = File.dirname(__FILE__)

      #
      # Serve up documention website.
      #
      def start
        Rack::Handler::Thin.run(app, :Port => 3000)
      end

      # Initialize new Server instance.
      def initialize(options={})
        @apis = []

        setup

        collect_gems
        #collect_rolls
        #collect_site
      end

      #
      def setup
        FileUtils.mkdir(shomen_home)     unless File.directory?(shomen_home)
        FileUtils.mkdir(docs_directory)  unless File.directory?(docs_directory)
        FileUtils.mkdir(views_directory) unless File.directory?(views_directory)
      end

      def shomen_home
        Server.shomen_home
      end

      def views_directory
        Server.views_directory
      end

      def docs_directory
        Server.docs_directory
      end

      #
      def views
        @views ||= (
          hash = {}
          Dir[views_directory + '/*'].each do |dir|
            hash[File.basename(dir)] = dir
          end
          hash
        )
      end

      #
      def apis
        @apis
      end

      #
      def temp_dir(path)
        File.join(Dir.tmpdir, File.basename(path))
      end

      #
      #def json_file(path)
      #  File.join(docs_directory, File.basename(path) + '.json')
      #end

      # Generate documentation for given library path.
      #
      # path - 
      #
      # Returns nothing.
      def generate(api)
        Dir.chdir(api.path) do
          if File.exist?('.yardopts')
            generate_via_yard(api)
          else
            generate_via_rdoc(api)
          end
        end
      end

      #
      def generate_via_rdoc(api)
        temp_dir = temp_dir(api.path)

        gen  = Shomen::Rdoc::Generator.new(:store=>temp_dir, :format=>'json')
        json = gen.produce_json
        File.open(api.doc_path, 'w'){ |f| f << json }
      end

      #
      def generate_via_yard(api)
        temp_dir = temp_dir(api.path)

        gen  = Shomen::Yard::Generator.new(:store=>temp_dir, :format=>'json')
        json = gen.produce_json
        File.open(api.doc_path, 'w'){ |f| f << json }
      end

      # Does the JSON file already exist or not?
      #def exist?(path)
      #  File.exist?(json_file(path))
      #end

      #
      def collect_rolls
         []  # TODO
      end

      #
      def collect_gems
        if defined?(::Gem)
          Gem::Specification.each do |spec|
            @apis << API.new(self,
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
          #use Rack::Static, :urls => [DIR + '/assets']
          use Rack::Static, :urls=>['/assets'], :root=>"/#{server.views[server.current_view]}"
          use Rack::Static, :urls=>['/docs'],   :root=>"/#{server.shomen_home}"

          server.apis.each do |api|
            map "/#{api.route}" do
              run Proc.new{ |env| [ 200, {'Content-Type' => 'text/html'}, [server.documentation_page(api, env)] ] }
            end
            #map "/#{api.doc_file}" do
            #  run Proc.new{ |env| [ 200, {'Content-Type' => 'text/json'}, [File.read(api.doc_path)] ] }
            #end
          end

          map "/" do
            run Proc.new{ |env| [ 200, {'Content-Type' => 'text/html'}, [server.index_page] ] }
          end

          map "/index.html" do
            run Proc.new{ |env| [ 200, {'Content-Type' => 'text/html'}, [server.index_page] ] }
          end



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
      def documentation_page(api, env)
        unless api.has_doc?
          generate(api)
        end
        view_index = File.join(views[current_view], 'index.html')
        File.read(view_index)
      end

      #
      def current_view
        'rebecca'
      end

      #
      # Remove a viewer.
      #
      def remove(repo)
        puts "rm -r " + File.join(views_directory, repo)
        Dir.chdir(views_directory) do
          if File.directory(repo)
            # TODO
          end
        end
      end

    end

  end

end
