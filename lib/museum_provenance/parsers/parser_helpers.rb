require 'cultural_dates'

module MuseumProvenance
  module Parsers
    module ParserHelpers 
      include Parslet
      include CulturalDates::DateWordHelpers

      def str_i(str)
          key_chars = str.split(//)
          key_chars.
            collect! { |char| match["#{char.upcase}#{char.downcase}"] }.
            reduce(:>>)
      end

      rule(:space)    { match('\s').repeat(1) }
      rule(:space?)   { space.maybe }
      rule(:eof)      { any.absent? }

      rule(:stop_words) {str("for") | str("in") | str("at") | month_names_tc}

      # Word rules    
      rule(:word)             { (match["[[:alpha:]]'-"]).repeat(1)  }
      rule(:initial)          { match["[[:upper:]]"] >> period }
      rule(:captal_word)      { initial | match["[[:upper:]]"] >> word  }
      rule(:words)            { (word | space >> word).repeat(1)}
      rule(:capitalized_words){ ((initial | captal_word) | space >> stop_words.absent? >> (initial | word) ).repeat(1)}
      rule(:word_phrase)      { (word | space >> word | comma >> stop_words.absent? >> word).repeat(1)}
      rule(:capitalized_word_phrase)  { (captal_word | space >> stop_words.absent? >> word | comma >> stop_words.absent? >>  captal_word).repeat(1)}
      rule(:text)             { (word | match["0-9."] | currency_symbol).repeat(1) }
      rule(:texts)            { (text | space >> text).repeat(1)}
      rule(:numeric)          { match(["0-9.,M"]).repeat(1) }
      rule(:currency_symbol)  {match(["$ƒ£€¢¥₱"])}

      # Token Rules
      rule(:token) {str("$AUTHORITY_TOKEN_") >> match["0-9"].repeat(1)}
      
      # Punctuation
      rule(:comma)            { str(",") >> space }
      rule(:period)           { str(".") >> space }
      rule(:period_end)       { (str(".") | str(";")).as(:transfer_punctuation) >> space.maybe }
      rule(:certainty)        { (str("?") | str("")).as(:certainty_value).as(:certainty)}
      rule(:lparen)           { str("(")}
      rule(:rparen)           { str(")")}      

    end
  end
end