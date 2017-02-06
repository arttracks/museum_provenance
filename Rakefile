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

task :acq do
  require "graphviz"
  require "./lib/museum_provenance.rb"
  require "fileutils"
  FileUtils.mkdir_p("./docs")
  MuseumProvenance::Utilities::AcquisitionMethodDocumentation.create_documentation("./docs")
end

task :acq_svg do
  require "graphviz"
  require "./lib/museum_provenance.rb"
  require "fileutils"
  FileUtils.mkdir_p("./docs")
  MuseumProvenance::Utilities::AcquisitionMethodDocumentation.create_documentation("./docs", :svg)
end

task :acq_skos do
  require "./lib/museum_provenance.rb"
  require "fileutils"
  FileUtils.mkdir_p("./docs")
  MuseumProvenance::Utilities::AcquisitionMethodDocumentation.create_skos("./docs")
end

desc "Clear the screen"
task :cls do
  puts "Clearing the Screen \033c"
end

task :default => [:cls, :test, :yard]