# frozen_string_literal: true

lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

Gem::Specification.new do |spec|
  spec.name          = 'Landmark'
  spec.version       = '1.4'
  spec.authors       = ['Mighty']
  spec.email         = ['me@nile.ninja']

  spec.summary       = 'Landmark emitter for RabbitMQ.'
  spec.homepage      = 'https://github.com/nukah/landmark'

  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_development_dependency 'bundler'
  spec.add_development_dependency 'pry'
  spec.add_development_dependency 'rake'
  spec.add_development_dependency 'rspec'

  spec.add_dependency 'bunny'
  spec.add_dependency 'celluloid'
end
