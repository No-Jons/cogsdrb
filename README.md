# CogsDRB

Cogs for [discordrb](https://github.com/discordrb/discordrb), in the style of [discord.py](https://github.com/Rapptz/discord.py)'s cog implementation

Cogs allow you to load commands, events, and variables from outside of the main bot file, 
which helps improve organization and readability of code.

#### Note: This gem is in extremely early development. As of now, it is extremely bare bones. More features will be added soon, and everyone is welcome to contribute. Additionally, the code is kinda hacky in some parts, and that will be fixed.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'cogsdrb'
```

And then execute:

    $ bundle install

Or install it yourself as:

    $ gem install cogsdrb

## Usage

When requiring the gem, you gain access to a few new classes through the `Cogs` module.
 - `Cogs::Cog`
 - `Cogs::BaseBotClass`

`Cogs::BaseBotClass` is a class that inherits from `Discordrb::Commands::CommandBot` and adds the functions necessary
for cogs to be implemented.

Here is a quickstart example:

```ruby
require 'discordrb'
require 'cogsdrb'

bot = Cogs::BaseBotClass.new(token="<token>", prefix="r!")
path_to_cogs = "C:/FULL/PATH/TO/COGS/" # As of now, cogs can only be loaded using the full path to the file

%w(mod fun).each do |i| # in this example, the path leads to the folder containing `mod.rb` and `fun.rb`
  bot.load_cog(fp="#{path_to_cogs}#{i}")
end

bot.run
```

And here is what `fun.rb` looks like:

```ruby
require 'discordrb'
require 'cogsdrb'

class Fun < Cogs::Cog # Class *must* inherit from `Cogs::Cog`
  def initialize(bot: Discordrb::Commands::CommandBot)
    @bot = bot
  end

  def commands # all commands for a cog *must* be contained in a function named `commands`
    @bot.command :test do |event| # As many commands as you want can be added in this function
      event.respond "Works"
    end
  end
end

def setup(bot)
  bot.add_cog(Fun.new bot: bot) # Additionally, all cog files *must* contain this function, or else an error will be thrown and the cog not loaded
end
```

Support for events and unloading/loading cogs will come in the near future.

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake test` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/No-Jons/drb-cogs. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [code of conduct](https://github.com/No-Jons/drb-cogs/blob/master/CODE_OF_CONDUCT.md).


## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the Drb::Cogs project's codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/[USERNAME]/drb-cogs/blob/master/CODE_OF_CONDUCT.md).
