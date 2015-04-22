require "appraisal"
require "bundler"
require "rspec/core/rake_task"
require "rubocop/rake_task"

Bundler::GemHelper.install_tasks

RSpec::Core::RakeTask.new(:spec)

RuboCop::RakeTask.new(:rubocop)

if !ENV["APPRAISAL_INITIALIZED"] && !ENV["TRAVIS"]
  task :default do
    sh "appraisal install && rake appraisal spec rubocop"
  end
else
  task default: [:spec, :rubocop]
end
