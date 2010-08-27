require 'rubygems'
require File.join(File.dirname(__FILE__), 'lib', 'json_builder', 'version')

begin
  require 'jeweler'
  Jeweler::Tasks.new do |s|
    root_files = FileList["README.md", "MIT-LICENSE"]
    s.name = 'json_builder'
    s.version = JSONBuilder::VERSION.dup
    s.summary = 'JSON Builder'
    s.email = 'me@garrettbjerkhoel.com'
    s.homepage = 'http://github.com/dewski/json_builder'
    s.description = 'JSON Builder for Rails'
    s.authors = ['Garrett Bjerkhoel']
    s.files =  root_files + FileList['{lib}/**/*']
    s.extra_rdoc_files = root_files
    s.add_dependency('activesupport', '~> 3.0.0')
    s.add_dependency('actionpack', '~> 3.0.0')
    s.add_dependency('json')
  end

  Jeweler::GemcutterTasks.new
rescue LoadError
  puts "Jeweler, or one of its dependencies, is not available. Install it with: gem install jeweler"
end

def gemspec
  @gemspec ||= begin
    gemspec_file = File.expand_path('../json_builder.gemspec', __FILE__)
    gemspec = eval(File.read(gemspec_file), binding, gemspec_file)
  end
end

desc 'Removes trailing whitespace'
task :whitespace do
  sh %{find . -name '*.rb' -exec sed -i '' 's/ *$//g' {} \\;}
end

namespace :release do
  task :tag do
    release_tag = "v#{gemspec.version}"
    sh "git tag -a #{release_tag} -m 'Tagging #{release_tag}'"
    sh "git push origin #{release_tag}"
  end

  task :gem => :build do
    sh "gem push pkg/#{gemspec.file_name}"
  end
end

desc "Release the current branch to GitHub and Gemcutter"
task :release => %w(release:tag release:gem)

namespace :gemspec do
  desc 'Validate the gemspec'
  task :validate do
    gemspec.validate
  end
end