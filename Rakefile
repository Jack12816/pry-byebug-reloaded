# frozen_string_literal: true

require "bundler/gem_tasks"
require "rake/testtask"
require "rubocop/rake_task"

desc "Run tests"
Rake::TestTask.new(:test) do |t|
  t.libs << "test"
  t.warning = false
  t.verbose = true
  t.pattern = "test/**/*_test.rb"
end

RuboCop::RakeTask.new

desc "Checks markdown code style with Markdownlint"
task :mdl do
  puts "Running mdl..."

  abort unless system("mdl", *Dir.glob("*.md"))
end

task default: %i[test rubocop mdl]
