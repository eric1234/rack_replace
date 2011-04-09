require "bundler/setup"
Bundler::GemHelper.install_tasks

require 'rake/testtask'
Rake::TestTask.new do |t|
  t.libs << 'lib'
  t.test_files = FileList['test/*_test.rb']
end
task :default => :test

require 'rake/rdoctask'
Rake::RDocTask.new do |rd|
  rd.main = "README.rdoc"
  rd.rdoc_files.include("README.rdoc", "lib/**/*.rb")
end
