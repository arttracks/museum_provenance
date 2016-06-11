require 'parslet'
require 'parslet/convenience'
require 'parslet/graphviz'

require_relative 'parsers/base_parser'

module MuseumProvenance
  
  class Parser
    include MuseumProvenance::Parsers

    def initialize(opts={})
      # opts[:acquisition_methods] ||= AcquisitionMethod.valid_methods

      @peg = BaseParser.new(opts)
      @transform = CertaintyTransform.new()

      # BaseParser.graph(pdf: 'grammar.pdf')

    end

    def parse(str)
      result = @peg.parse_with_debug(str, reporter: Parslet::ErrorReporter::Deepest.new)
      if result
        transformed_result = @transform.apply(result)
       puts JSON.pretty_generate(JSON.parse(transformed_result.to_json)) 
      end
    end


  end
end