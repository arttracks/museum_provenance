require_relative "parser_helpers"

module MuseumProvenance
  module Parsers
      # 
      # This parser will parse a Citation or Note block, for example:
      # > [b]: C.L. Sulzberger, A Long Row of Candles, Macmillan, 1969, p. 8.
      # or
      # > [1]: Purchased for his daughter's birthday.

      # 
      # If it parses, it will return an array of :notes
      #
      # * :note_id           # The index letter or number 
      # * :note_text         # The text of the note
      #
      # @author [@workergnome]
      # 
    class NoteSectionParser < Parslet::Parser

      include ParserHelpers
      include Parslet
     
      rule(:mark) {str("[") >> match["A-Za-z0-9"].repeat(1).as(:key) >> str("]:")}
      rule(:text) {(str("\n").absent? >> any).repeat(1).as(:string) }
      rule(:note) {str("\n").repeat >> mark >> space >> text}
      rule(:notes) {note.repeat.as(:notes) >> str("\n").repeat}
      root(:notes)
  
    end
  end
end