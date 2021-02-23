# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require File.expand_path("../lib/#{File.basename(__FILE__, '.gemspec')}/version", __FILE__)

Gem::Specification.new do |spec|
  spec.name          = "golden"
  spec.version       = Golden::VERSION
  spec.authors       = ["Greg Mikeska"]
  spec.email         = ["gmikeska07@gmail.com"]

  spec.summary       = %q{Golden is a development tool that makes it easier to wrap Go libraries for use in Ruby.}
  spec.description   = %q{Golden is a development tool that makes it easier to wrap Go libraries for use in Ruby.
    Features
  * Usage similar to the every day package manager
  * Converts .go files to .so shared libraries
  * Manages library exported function metadata in convenient JSON format}
  spec.homepage      = "https://github.com/gmikeska/golden"

  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the 'allowed_push_host'
  # to allow pushing to a single host or delete this section to allow pushing to any host.

  spec.files = Dir['lib/*.rb'] + Dir['bin/*']
  # spec.files         = `git ls-files -z`.split("\x0").reject do |f|
  #   f.match(%r{^(test|spec|features)/})
  # end
  spec.bindir        = "exe"
  spec.executables   << "golden"
  spec.require_paths = ["lib"]

  spec.add_runtime_dependency  "ffi", "~> 1.14"

  spec.add_development_dependency "pry", "~> 0.14.0"
  spec.add_development_dependency "bundler", "~> 1.13"
  spec.add_development_dependency "rake", "~> 12.3.3"
  spec.add_development_dependency "rspec", "~> 3.0"
end
