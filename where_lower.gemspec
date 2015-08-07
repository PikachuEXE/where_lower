# -*- encoding: utf-8 -*-
$LOAD_PATH.push File.expand_path("../lib", __FILE__)

author_name = "PikachuEXE"
gem_name = "where_lower"

require "#{gem_name}/version"

Gem::Specification.new do |s|
  s.platform      = Gem::Platform::RUBY
  s.name          = gem_name
  s.version       = WhereLower::VERSION
  s.summary       = <<-DOC
    Provide an easy way to use case insensitive `where` in ActiveRecord.
  DOC
  s.description = <<-DOC
    ActiveRecord provides no method for
    case insensitive version of `where` method.
    So here is one.
    No longer need to use SQL fragment yeah!
  DOC

  s.license       = "MIT"

  s.authors       = [author_name]
  s.email         = ["pikachuexe@gmail.com"]
  s.homepage      = "http://github.com/#{author_name}/#{gem_name}"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.
    split("\n").map { |f| File.basename(f) }

  s.require_paths = ["lib"]

  s.add_dependency "activerecord", ">= 3.1.0", "< 5.0.0"

  s.add_development_dependency "bundler", ">= 1.0.0"
  s.add_development_dependency "rake", ">= 0.9.2"
  s.add_development_dependency "appraisal", "~> 1.0"
  s.add_development_dependency "rspec", "~> 3.0"
  s.add_development_dependency "rspec-its", "~> 1.0"
  s.add_development_dependency "sqlite3", ">= 1.3"
  s.add_development_dependency "database_cleaner", ">= 1.0"
  s.add_development_dependency "coveralls", ">= 0.7"
  s.add_development_dependency "gem-release", ">= 0.7"
  s.add_development_dependency "rubocop", "~> 0.33"
  s.add_development_dependency "inch", "~> 0.5", ">= 0.5.10"

  s.required_ruby_version = ">= 1.9.2"

  s.required_rubygems_version = ">= 1.4.0"
end
