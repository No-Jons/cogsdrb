require 'discordrb'

module Cogs
  class Command < Discordrb::Commands::Command
    def initialize(bot, name, attributes = {}, &block)
      super(name=name, attributes=attributes, &block=block)
      @bot = bot
      @cog = attributes[:cog] || "None"
    end

    attr_reader :cog

    def call(event, arguments, chained = false, check_permissions = true)
      return unless @bot::cached_cogs.include?(@cog) || @cog == "None"
      if arguments.length < @attributes[:min_args]
        response = "Too few arguments for command `#{name}`!"
        response += "\nUsage: `#{@attributes[:usage]}`" if @attributes[:usage]
        event.respond(response)
        return
      end
      if @attributes[:max_args] >= 0 && arguments.length > @attributes[:max_args]
        response = "Too many arguments for command `#{name}`!"
        response += "\nUsage: `#{@attributes[:usage]}`" if @attributes[:usage]
        event.respond(response)
        return
      end
      unless @attributes[:chain_usable]
        if chained
          event.respond "Command `#{name}` cannot be used in a command chain!"
          return
        end
      end

      if check_permissions
        rate_limited = event.bot.rate_limited?(@attributes[:bucket], event.author)
        if @attributes[:bucket] && rate_limited
          event.respond @attributes[:rate_limit_message].gsub('%time%', rate_limited.round(2).to_s) if @attributes[:rate_limit_message]
          return
        end
      end

      result = @block.call(event, *arguments)
      event.drain_into(result)
    rescue LocalJumpError => e # occurs when breaking
      result = e.exit_value
      event.drain_into(result)
    rescue StandardError => e # Something went wrong inside our @block!
      rescue_value = @attributes[:rescue] || event.bot.attributes[:rescue]
      if rescue_value
        event.respond(rescue_value.gsub('%exception%', e.message)) if rescue_value.is_a?(String)
        rescue_value.call(event, e) if rescue_value.respond_to?(:call)
      end

      raise e
    end
  end
end
