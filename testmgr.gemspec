# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'testmgr/version'

Gem::Specification.new do |spec|
  spec.name          = "testmgr"
  spec.version       = Testmgr::VERSION
  spec.authors       = ["h20dragon"]
  spec.email         = ["h20dragon@outlook.com"]

  spec.summary       = %q{General purpose test manager.}
  spec.description   = %q{Manager test requirements, assertions, and results to create test reports.}
  spec.homepage      = "http://rubygems.org/testmgr"
  spec.license       = "MIT"

  # Prevent pushing this gem to RubyGems.org by setting 'allowed_push_host', or
  # delete this section to allow pushing this gem to any host.
#  if spec.respond_to?(:metadata)
#    spec.metadata['allowed_push_host'] = "http://github.com/h20dragon/testmgr"
#  else
#    raise "RubyGems 2.0 or newer is required to protect against public gem pushes."
#  end

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rspec"
  spec.add_development_dependency "json"
  spec.add_development_dependency "nokogiri"
end
