$:.push File.expand_path('../lib', __FILE__)
require 'json_builder/version'

Gem::Specification.new do |s|
  s.name = 'json_builder'
  s.version = JSONBuilder::VERSION
  s.summary = 'Rails provides an excellent XML Builder by default to build RSS and ATOM feeds, but nothing to help you build complex and custom JSON data structures. The standard to_json works well, but can get very verbose when you need full control of what is generated. JSON Builder hopes to solve that problem.'
  s.description = 'Rails provides an excellent XML Builder by default to build RSS and ATOM feeds, but nothing to help you build complex and custom JSON data structures. The standard to_json works well, but can get very verbose when you need full control of what is generated. JSON Builder hopes to solve that problem.'
  s.authors     = ['Garrett Bjerkhoel']
  s.email       = ['me@garrettbjerkhoel.com']
  s.platform    = Gem::Platform::RUBY

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ['lib']

  s.add_dependency 'activesupport', '>= 2.0.0'
  s.add_dependency 'json'
  s.add_development_dependency 'tzinfo'
end
