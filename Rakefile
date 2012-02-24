# encoding: UTF-8
require 'rubygems'
require 'rake/testtask'
begin
  require 'bundler/setup'
  Bundler::GemHelper.install_tasks
rescue LoadError
  puts 'You must `gem install bundler` and `bundle install` to run rake tasks'
end

desc 'Default: run tests'
task :default => :test

desc 'Run JSONBuilder tests.'
Rake::TestTask.new(:test) do |t|
  t.libs << 'lib'
  t.libs << 'test'
  t.test_files = FileList['test/*_test.rb']
  t.verbose = true
end
