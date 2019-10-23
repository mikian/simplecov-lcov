
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "simplecov-workspace-lcov/version"

Gem::Specification.new do |spec|
  spec.name          = "simplecov-workspace-lcov"
  spec.version       = SimpleCov::Formatter::WorkspaceLcovFormatter::VERSION
  spec.authors       = ["Mikko Kokkonen"]
  spec.email         = ["mikko@mikian.com"]

  spec.summary       = %q{SimpleCov formatter to generate a lcov style coverage for workspaces.}
  spec.description   = %q{SimpleCov formatter to generate a lcov style coverage reports with full
    workspace support. Allows to run multiple seperate coverage runs inside different directories
    (engines) while keeping file names relative to workspace root.}
  spec.homepage      = "https://github.com/mikian/simplecov-workspace-lcov"
  spec.license       = "MIT"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files         = Dir.chdir(File.expand_path('..', __FILE__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.17"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "minitest", "~> 5.0"
end
