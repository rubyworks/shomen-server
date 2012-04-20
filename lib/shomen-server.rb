module Shomen
  module Server

    #
    # Known viewer repos.
    #
    VIEWER_REPOS = {
      'hypervisor' => 'git://github.com/rubyworks/hypervisor.git',
      'rebecca'    => 'git://github.com/rubyworks/rebecca.git',
      'rubyfaux'   => 'git://github.com/rubyworks/rubyfaux.git'
    }

    #
    # Expanded path of shomen directory. By default this in the user's
    # home directory at `~/.shomen`. It can be changed via the `SHOMEN_HOME`
    # environment variable.
    #
    def self.shomen_home
      @shomen_home ||= (
        File.expand_path(ENV['SHOMEN_HOME'] || '~/.shomen')
      )
    end

    #
    # Location of installed viewers. By default this in the user's
    # home directory at `~/.shomen/views`.
    #
    # @return [String] Directory for viewers.
    #
    def self.views_directory
      @views_directory ||= File.join(shomen_home, 'views')
    end

    #
    # Expanded path of documentation store directory. By default this in the user's
    # home directory at `~/.shomen/docs`.
    #
    # @return [String] Directory for documentation files.
    #
    def self.docs_directory
      @docs_directory ||= File.join(shomen_home, 'docs')
    end

    #
    # Run webserver.
    #
    def self.start(options)
      RackApp.new(options).start
    end

    #
    # Install a viewer.
    #
    def self.install(repo)
      repo = VIEWER_REPOS[repo] || repo
      Dir.chdir(views_directory) do
        system "git clone #{repo}"
      end
    end

    #
    # Remove a viewer.
    #
    def self.remove(repo)
    end

    #
    # Update a viewer.
    #
    def self.update(repo)
    end

  end
end

require 'rack'
require 'erb'
require 'tmpdir'

require 'shomen-yard'

require 'shomen-server/cli'
require 'shomen-server/rack'
require 'shomen-server/api'


