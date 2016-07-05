# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'octo_merge/version'

Gem::Specification.new do |spec|
  spec.name          = "octo-merge"
  spec.version       = OctoMerge::VERSION
  spec.authors       = ["Patrick Helm"]
  spec.email         = ["me@patrick-helm.de"]

  spec.summary       = %q{Merge GitHub pull requests.}
  spec.description   = %q{
  octo_merge is a simple command line tool to merge GitHub pull requests using different strategies
  }
  spec.homepage      = "https://github.com/Deradon/octo-merge"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency "octokit", "~> 4.0"
  spec.add_dependency "inquirer", "~> 0.2.1"

  spec.add_development_dependency "bundler", "~> 1.11"
  spec.add_development_dependency "pry"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.0"
  spec.add_development_dependency "rspec-its"
  spec.add_development_dependency "simplecov"
  spec.add_development_dependency "webmock"
end
