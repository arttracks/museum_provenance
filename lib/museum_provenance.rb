require "museum_provenance/version"

# Load dependent files
require 'date'
require 'parslet'
require 'parslet/convenience'

require 'active_support/core_ext/integer/inflections'


require_relative "museum_provenance/certainty.rb"
dev_only_dependencies = ["acquisition_method_documentation.rb"]

Dir["#{File.dirname(__FILE__)}/museum_provenance/**/*.rb"].sort.each { |f| require(f) unless dev_only_dependencies.include?(File.basename(f))}

# MuseumProvenance is a general-purpose library for cultural institutions 
# @todo Write this, please.
module MuseumProvenance
end
