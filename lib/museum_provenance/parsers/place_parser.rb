require_relative "parser_helpers"

module MuseumProvenance
  module Parsers
      # 
      # This parser will parse a Actor entity block, for example:
      # > John Doe? [1910?-1995?], Boise, ID
      # 
      # If it parses, it can return:
      #
      # * :stock_number           # The text of the stock number phrase
      #
      # @author [@workergnome]
      # 
    class PlaceParser < Parslet::Parser

      include ParserHelpers
      include Parslet
      root(:place)

      rule(:place) do
        ((capitalized_word_phrase.as(:string) | token.as(:token)) >> certainty).as(:place)
      end
      
    
    end
  end
end