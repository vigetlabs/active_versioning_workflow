# coding: utf-8
lib = File.expand_path('../lib', __FILE__)

$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

require 'active_versioning/workflow/version'

Gem::Specification.new do |spec|
  spec.name          = "active_versioning_workflow"
  spec.version       = ActiveVersioning::Workflow::VERSION
  spec.authors       = ["Ryan Stenberg"]
  spec.email         = ["ryan.stenberg@viget.com"]

  spec.summary       = "An ActiveVersioning Extension for Version Workflow in ActiveAdmin"
  spec.description   = "ActiveVersioning Workflow provides the tools necessary for version workflow in ActiveAdmin."
  spec.homepage      = "https://github.com/vigetlabs/active_versioning_workflow"
  spec.license       = "BSD"

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_path  = ['lib']

  spec.add_dependency "active_versioning", "~> 1.0.1"

  spec.add_development_dependency "bundler", ">= 1.10"
  spec.add_development_dependency "rake", ">= 10.0"
  spec.add_development_dependency "rspec"
  spec.add_development_dependency "pry"
  spec.add_development_dependency "generator_spec"
end
