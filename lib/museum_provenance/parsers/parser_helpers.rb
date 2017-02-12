module MuseumProvenance
  module Parsers
    module ParserHelpers 
      include Parslet

      def str_i(str)
          key_chars = str.split(//)
          key_chars.
            collect! { |char| match["#{char.upcase}#{char.downcase}"] }.
            reduce(:>>)
      end

      rule(:space)    { match('\s').repeat(1) }
      rule(:space?)   { space.maybe }
      rule(:eof)      { any.absent? }

      rule(:stop_words) {str("for") | str("in") | str("at")}

      # Word rules    
      rule(:word)             { (match["A-Za-z"] | str("\'")).repeat(1) }
      rule(:captal_word)      { match["A-Z"] >> match["A-Za-z'"].repeat(1) }
      rule(:words)            { (word | space >> word ).repeat(1)}
      rule(:word_phrase)      { (word | space >> word | comma >> stop_words.absent? >> word).repeat(1)}
      rule(:capitalized_word_phrase)  { (word | space >> word | comma >> captal_word).repeat(1)}
      rule(:text)             { (word | match["0-9."] | currency_symbol).repeat(1) }
      rule(:texts)            { (text | space >> text).repeat(1)}
      rule(:numeric)          { match(["0-9.,"]).repeat(1) }
      rule(:currency_symbol)  {match(["$ƒ£€¢¥₱"])}

      # Token Rules
      rule(:token) {str("$AUTHORITY_TOKEN_") >> match["0-9"].repeat(6,6)}
      
      # Punctuation
      rule(:comma)            { str(",") >> space }
      rule(:period)           { str(".") >> space }
      rule(:period_end)       { (str(".") | str(";")) >> space.maybe }
      rule(:certainty)        { (str("?") | str("")).as(:certainty)}
      rule(:lparen)           { str("(")}
      rule(:rparen)           { str(")")}


      rule(:fallback) { any.repeat.maybe.as("trash") }
      

    end
  end
end