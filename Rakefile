require "rake"
require 'rake/gempackagetask'
require 'rake/contrib/rubyforgepublisher'
require 'rake/clean'
require 'rake/testtask'
require 'rake/rdoctask'
require 'bundler'

desc "Runs the Rspec suite"
task(:default) do
  run_suite
end

desc "Runs the Rspec suite"
task(:spec) do
  run_suite
end

desc "Tag the release and push"
task :release do
  tag_name = "v#{PKG_VERSION}"
  system("git tag #{tag_name} && git push origin #{tag_name}")
end

def run_suite
  dir = File.dirname(__FILE__)
  system("ruby #{dir}/spec/spec_suite.rb") || raise("Example Suite failed")
end

PKG_NAME = "js-test-server"
PKG_VERSION = "0.2.5"
PKG_FILES = FileList[
  '[A-Z]*',
  '*.rb',
  'lib/**/**',
  'public/**/**',
  'bin/**/**',
  'spec/**/*.rb',
  'vendor/**/*.rb'
]

spec = Gem::Specification.new do |s|
  s.name = PKG_NAME
  s.version = PKG_VERSION
  s.summary = "The JsTestServer library is the core javascript test server library used by several JS Test server libraries."
  s.test_files = "spec/spec_suite.rb"
  s.description = s.summary

  s.files = PKG_FILES.to_a
  s.require_path = 'lib'

  s.has_rdoc = true

  s.test_files = Dir.glob('spec/*_spec.rb')
  s.executables = Dir.glob('bin/*').map do |file|
    File.basename(file)
  end
  s.require_path = 'lib'
  s.author = "Brian Takita"
  s.email = "brian.takita@gmail.com"
  s.homepage = "http://pivotallabs.com"
  s.rubyforge_project = "pivotalrb"
  Bundler::Definition.from_gemfile("#{File.dirname(__FILE__)}/Gemfile").dependencies.select do |dependency|
    dependency.groups.include?(:gem)
  end.each do |dependency|
    s.add_dependency(dependency.name, dependency.version_requirements)
  end
end

Rake::GemPackageTask.new(spec) do |pkg|
  pkg.need_zip = true
  pkg.need_tar = true
end
