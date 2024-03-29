require_relative 'lib/prog_scorer/version'

Gem::Specification.new do |spec|
  spec.name          = "prog_scorer"
  spec.version       = ProgScorer::VERSION
  spec.authors       = ["phaya708"]
  spec.email         = ["ui0079el@gmail.com"]

  spec.summary       = %q{Score program files automatically.}
  spec.description   = %q{Score program files automatically.}
  spec.homepage      = "https://github.com/phaya708/prog_scorer"
  spec.license       = "MIT"
  spec.required_ruby_version = Gem::Requirement.new(">= 2.3.0")

  spec.metadata["allowed_push_host"] = spec.homepage

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = spec.homepage
  spec.metadata["changelog_uri"] = spec.homepage

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files         = Dir.chdir(File.expand_path('..', __FILE__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]
end
