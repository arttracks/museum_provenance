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

      rule(:footnote) {str("[") >> (match["1-9"] >> match["0-9"].repeat).as(:footnote_key).as(:footnote) >> str("]")}

      rule(:citation) {(str("[") >> match["1-9"]).absent? >> str("[") >>  match["A-Za-z"].repeat(1).as(:citation_key) >> str("]")}
     
      rule(:notes) do
         (footnote >> citation.repeat(1).as(:citations)) |
         (citation.repeat(1).as(:citations) >> footnote) |
         footnote |
         citation.repeat(1).as(:citations)
      end

    end
  end
end