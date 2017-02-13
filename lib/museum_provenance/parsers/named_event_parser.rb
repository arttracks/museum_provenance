require_relative "parser_helpers"
require_relative "actor_parser"

module MuseumProvenance
  module Parsers
      # 
      # This parser will parse a Named Event entity block, for example:
      # > John Doe? [1910?-1995?], Boise, ID
      # 
      # If it parses, it can return:
      #
      # * :stock_number           # The text of the stock number phrase
      #
      # @author [@workergnome]
      # 
    class NamedEventParser < Parslet::Parser

      include ParserHelpers
      include Parslet
      root(:named_event)

      rule(:event) {(str("\"") >> ((word_phrase.as(:string) | token.as(:token)) >> certainty).as(:event) >> str("\""))}
      rule(:sellers_agent) {ActorParser.new.as(:sellers_agent)}
      
      rule(:both) {event >> comma >> sellers_agent}

      rule (:named_event) do
        (str("at") >> space >> (both | event | sellers_agent)) |
        (str("through") >> space >> sellers_agent >> ( (space | comma) >> str("at") >> space >> event).maybe)
      end
      
    
    end
  end
end