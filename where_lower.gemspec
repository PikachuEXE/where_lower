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
  s.executables   = `git ls-files -- bin/*`.split("\n").map do |f|
    File.basename(f)
  end

  s.require_paths = ["lib"]

  s.add_dependency "activerecord", ">= 7.0.0", "< 9.0.0"

  s.add_development_dependency "bundler", ">= 1.0.0"
  s.add_development_dependency "rake", ">= 10.0", "<= 14.0"
  s.add_development_dependency "appraisal", "~> 2.0", ">= 2.5.0"
  s.add_development_dependency "rspec", "~> 3.0"
  s.add_development_dependency "rspec-its", "~> 2.0"
  s.add_development_dependency "sqlite3", ">= 1.3"
  s.add_development_dependency "database_cleaner", ">= 1.0"
  s.add_development_dependency "simplecov", ">= 0.21"
  s.add_development_dependency "simplecov-lcov", ">= 0.8"
  s.add_development_dependency "gem-release", ">= 0.7"
  s.add_development_dependency "inch", "~> 0.5", ">= 0.5.10"

  s.required_ruby_version = ">= 3.0.0"

  s.required_rubygems_version = ">= 1.4.0"
end
