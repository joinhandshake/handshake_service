# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'handshake_service/version'

Gem::Specification.new do |spec|
  spec.name          = "handshake_service"
  spec.version       = HandshakeService::VERSION
  spec.authors       = ["Scott Ringwelski"]
  spec.email         = ["scott@joinhandshake.com"]

  spec.summary       = %q{A collection of modules, rake tasks and more for common Handshake services.}
  spec.description   = %q{A collection of modules, rake tasks and more for common Handshake services.}
  spec.homepage      = "https://github.com/strydercorp/handshake_service"
  spec.license       = "MIT"

  # Prevent pushing this gem to RubyGems.org by setting 'allowed_push_host', or
  # delete this section to allow pushing this gem to any host.
  if spec.respond_to?(:metadata)
    spec.metadata['allowed_push_host'] = "https://rubygems.org"
  else
    raise "RubyGems 2.0 or newer is required to protect against public gem pushes."
  end

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib", "lib/handshake_service"]

  spec.add_runtime_dependency "bugsnag", '6.6.0'
  spec.add_runtime_dependency "librato-rails"

  spec.add_development_dependency "bundler"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rspec"
end
