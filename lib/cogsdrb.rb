require 'discordrb'
require "cogsdrb/version"
require "bot"
require "commands"

module Cogs
    class Cog
        def initialize(bot)
            @bot = bot
        end

        attr_accessor :name
        attr_accessor :fp

        def command(name, attributes = {}, &block)
            attributes[:cog] = @name unless attributes[:cog]
            @bot.command(name, attributes, &block)
        end

        def commands; end
    end

    # TODO:
    #   ✔ Loading and unloading of cogs
    #   - Event listeners
    #   - Cog meta attributes
    #   - More dpy-like implementation
    #   - Clean it up and make it not hacky af

    class CogError < StandardError; end

end
