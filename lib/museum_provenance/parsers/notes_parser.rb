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
    class NotesParser < Parslet::Parser
      include ParserHelpers
      include Parslet

      root(:notes)

      rule(:footnote) {str("[") >> (match["1-9"] >> match["0-9"].repeat(0)).as(:footnote) >> str("]")}
      rule(:citation) {str("[") >> match(["a-zA-Z"]).repeat(1).as(:value) >> str("]")}
      rule(:notes) do
         (citation.repeat(0,nil).as(:citations) >> footnote.maybe |
         footnote.maybe >> citation.repeat(0,nil).as(:citations))
      end

    end
  end
end