require_relative "parser_helpers"

module MuseumProvenance
  module Parsers
    module ParserHelpers 
      include Parslet

      rule(:space)    { match('\s').repeat(1) }
      rule(:space?)   { space.maybe }
      rule(:eof)      { any.absent? }

      # Word rules    
      rule(:word)             { match["A-Za-z"].repeat(1) }
      rule(:words)            { (word |space >> word ).repeat(1)}
      rule(:word_phrase)      { word >> phrase_end }
      rule(:text)             { (word | match["0-9."] | currency_symbol).repeat(1) }
      rule(:texts)            { (text |space >> text).repeat(1)}
      rule(:numeric)          { match(["0-9.,"]).repeat(1) }
      rule(:currency_symbol)  {match(['$ƒ£€¢¥₱'])}


      
      # Punctuation
      rule(:comma)            { str(",") >> space }
      rule(:period)           { str(".") >> space }
      rule(:period_end)       { (str(".") | str(";")) >> (space | eof) }
      rule(:phrase_end)       { (comma | space) }
      rule(:certainty)        { (str("?") | str("")).as(:certainty)}
      rule(:lparen)           { str("(")}
      rule(:rparen)           { str(")")}


      rule(:fallback) { any.repeat.maybe.as("trash") }
      

    end
  end
end