require 'discordrb'
require "cogsdrb/version"
require "bot"
require "commands"

module Cogs
    class Cog
        def initialize(name: "Cog")
            @name = name
            @fp = fp
        end

        attr_reader :name
        attr_accessor :fp
    end

    # TODO:
    #   ✔ Loading and unloading of cogs
    #   - Event listeners
    #   - Cog meta attributes
    #   - More dpy-like implementation
    #   - Clean it up and make it not hacky af

    class CogError < StandardError; end

end
