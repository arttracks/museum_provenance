require "bundler/gem_tasks"
require 'rake/testtask'


Rake::TestTask.new do |t|
  t.libs.push "lib"
  t.test_files = FileList['test/*_test.rb']
end

desc "Clear the screen"
task :cls do
  puts "Clearing the Screen \033c"
end

task :default => [:cls, :test]