require 'simplecov'
SimpleCov.start

require 'minitest/spec'
require 'minitest/autorun'
require "minitest/pride"
require "minitest/reporters"

#Minitest::Reporters.use! Minitest::Reporters::SpecReporter.new

require_relative '../lib/museum_provenance'

include MuseumProvenance
