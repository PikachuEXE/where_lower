# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)

author_name = 'PikachuEXE'
gem_name = 'where_lower'

require "#{gem_name}/version"

Gem::Specification.new do |s|
  s.platform      = Gem::Platform::RUBY
  s.name          = gem_name
  s.version       = WhereLower::VERSION
  s.summary       = 'Provide an easy way to use case insensitive `where` in ActiveRecord.'
  s.description   = 'ActiveRecord provides no method for case insensitive version of `where` method. So here is one. No longer need to use SQL fragment yeah!'

  s.license       = 'MIT'

  s.authors       = [author_name]
  s.email         = ['pikachuexe@gmail.com']
  s.homepage      = "http://github.com/#{author_name}/#{gem_name}"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ['lib']

  s.add_dependency 'activerecord', '>= 3.0.0', '< 5.0.0'
end
