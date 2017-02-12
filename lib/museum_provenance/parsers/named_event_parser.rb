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

      rule (:named_event) do
       str("at") >> space >> str("\"") >>
       ((word_phrase.as(:string) | token.as(:token)) >> certainty).as(:event) >>
        str("\"") >> 
        (comma >> ActorParser.new.as(:event_actor)).maybe
      end
      
    
    end
  end
end