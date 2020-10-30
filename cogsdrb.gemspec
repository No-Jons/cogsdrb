require_relative 'lib/cogsdrb/version'

Gem::Specification.new do |spec|
  spec.name          = "cogsdrb"
  spec.version       = Cogs::VERSION
  spec.authors       = ["No-Jons"]
  spec.email         = ["61525221+No-Jons@users.noreply.github.com"]

  spec.summary       = %q{Cogs for discordrb, in the style of discord.py}
  spec.homepage      = "https://www.github.com/No-Jons/"
  spec.license       = "MIT"
  spec.required_ruby_version = Gem::Requirement.new(">= 2.3.0")

  #spec.metadata["allowed_push_host"] = "TODO: Set to 'http://mygemserver.com'"

  spec.metadata["homepage_uri"] = spec.homepage
  #spec.metadata["source_code_uri"] = "TODO: Put your gem's public repo URL here."
  #spec.metadata["changelog_uri"] = "TODO: Put your gem's CHANGELOG.md URL here."

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files         = Dir.chdir(File.expand_path('..', __FILE__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]
end
