require 'discordrb'
require "cogsdrb/version"

module Cogs
    class Error < StandardError; end
    # Your code goes here...

    class BaseBotClass < Discordrb::Commands::CommandBot
        def initialize(token, prefix)
            super token: token, prefix: prefix
            @cogs = []
        end

        def cogs
            @cogs
        end

        def add_commands
            nil
        end

        def run_bot
            self.before
            self.add_commands
            begin
                self.run
            ensure
                self.after
            end
        end

        def before
            nil
        end

        def after
            nil
        end

        def load_cog(fp)
            begin
                require fp
                setup(self)
            rescue LoadError, NoMethodError => error
                self.log_exception(error)
            end
        end

        def add_cog(cog)
            begin
                cog.commands
                @cogs.append(cog)
            rescue NoMethodError => error
                self.log_exception(error)
            end
        end
    end

    class Cog
        def initialize(name: "Cog")
            @name = name
        end

        def name
            @name
        end
    end

    # TODO:
    #   - Loading and unloading of cogs
    #   - Event listeners
    #   - Cog meta attributes
    #   - More dpy-like implementation
    #   - Clean it up and make it not hacky af

end
