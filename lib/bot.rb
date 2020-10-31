require 'discordrb'

module Cogs
  class BaseBotClass < Discordrb::Commands::CommandBot
    def initialize(token, prefix)
      super token: token, prefix: prefix
      @cached_cogs = {}
      @loaded_cogs = {}

    end

    attr_accessor :cogs
    attr_reader :cached_cogs
    attr_reader :loaded_cogs

    def run_bot
      self.before
      self.add_commands
      begin
        self.run
      ensure
        self.after
      end
    end

    def add_commands; end
    def before; end
    def after; end

    def command(name, attributes = {}, &block)
      @commands ||= {}

      if name.is_a?(Array)
        name, *aliases = name
        attributes[:aliases] = aliases if attributes[:aliases].nil?
        Discordrb::LOGGER.warn("While registering command #{name.inspect}")
        Discordrb::LOGGER.warn('Arrays for command aliases is removed. Please use `aliases` argument instead.')
      end

      new_command = Cogs::Command.new(self, name, attributes, &block)
      new_command.attributes[:aliases].each do |aliased_name|
        @commands[aliased_name] = CommandAlias.new(aliased_name, new_command)
      end
      @commands[name] = new_command
    end

    def _remove_all_cog_commands(cogname)
      @commands ||= {}
      @commands.each do |cmd|
        if cmd[1]::cog == cogname
          self.remove_command cmd[1]::name
          p cmd[1]::name
        end
      end
    end

    def load_extension(fp)
      fp = fp + ".rb" unless fp.end_with?".rb"
      raise Cogs::CogError.new "Nonexistant filepath #{fp}" unless File.file?fp + ".rb" unless fp.end_with?".rb"
      begin
        load fp
        cog = setup(self)
        cog::fp = fp
        cog::name = cog.to_s[2..].split(':')[0]
        @loaded_cogs[cog::name] = cog
        @cached_cogs[cog::name] = cog.class
      rescue LoadError, NoMethodError => error
        self.log_exception(error)
      end
    end

    def add_cog(cog)
      begin
        cog = cog.new bot: self
        cog.commands
        return cog
      rescue NoMethodError => error
        self.log_exception(error)
      end
    end

    def unload_cog(cog: nil, cogname: "")
      if cog.is_a?Cogs::Cog
        if @cached_cogs.keys.include? cog::name
          @loaded_cogs = @loaded_cogs.tap { |key| delete(key) if key == cog::name }
          self._remove_all_cog_commands(cog::name)
          Discordrb::LOGGER.info "Unloaded cog #{cog::name}"
          return
        end
      end
      if @loaded_cogs.keys.include?cogname
        @loaded_cogs = @loaded_cogs.tap { |key| delete(key) if key == cogname }
        self._remove_all_cog_commands(cogname)
        Discordrb::LOGGER.info "Unloaded cog #{cogname}"
        return
      end
      raise Cogs::CogError.new "Cog already unloaded"
    end

    def reload_cog(cog)
      raise Cogs::CogError.new "Cog not found" unless @cached_cogs.include?cog or @loaded_cogs.include?cog
      if @loaded_cogs.include?cog
        self.unload_cog(cogname: cog)
      end
      self.load_extension(@loaded_cogs[cog]::fp)
      Discordrb::LOGGER.info "Loaded cog #{cog}"
    end

    def load_cog(cog)
      self.reload_cog(cog)
    end
  end
end