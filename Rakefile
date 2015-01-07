require "bundler/gem_tasks"
require 'rake/testtask'
require 'yard'


Rake::TestTask.new do |t|
  t.libs.push "lib"
  t.test_files = FileList['test/*_test.rb']
end


YARD::Rake::YardocTask.new do |t|
  t.files   = ['lib/**/*.rb']   # optional
  t.stats_options = ['--list-undoc']         # optional
end


desc "Clear the screen"
task :cls do
  puts "Clearing the Screen \033c"
end

task :default => [:cls, :test, :yard]