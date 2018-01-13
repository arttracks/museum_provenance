require 'minitest/spec'
require 'minitest/autorun'
require "minitest/pride"
require "rake/testtask"

$VERBOSE=nil

require_relative '../lib/museum_provenance'

include MuseumProvenance

  Rake::TestTask.new do |t|
    t.libs << "test"
    t.test_files = FileList['test/*_test.rb']
    t.verbose = false
    t.warning = false
  end