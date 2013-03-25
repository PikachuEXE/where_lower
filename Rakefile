require 'appraisal'
require 'rubygems'
require 'bundler/setup'
require 'bundler/gem_tasks'
require 'rspec/core/rake_task'

task :default do
  sh "rake appraisal:install && rake appraisal spec"
end

RSpec::Core::RakeTask.new(:spec)
