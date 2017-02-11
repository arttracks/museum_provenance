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
    class ActorParser < Parslet::Parser

      include ParserHelpers
      include Parslet
      root(:actor)


       # Location Stuff  
      rule(:location) do
        comma >> (word_phrase.repeat(1).as(:string)  >> certainty).as(:location) >> phrase_end
      end
      
      rule (:era)  {(space >> str("CE").as(:era) | space >> str("BCE").as(:era) | str("").as(:era))}
      rule (:year) {(match["1-9"] >> match["0-9"].repeat(0,3)).as(:year) >> era }

      rule (:life_dates) do
        space >>
        str("[") >> 
        (year.maybe >> certainty).as(:birth) >>
        (str("-") | str(" - ")) >>
        (year.maybe >> certainty).as(:death) >>
        str("]") >>
        space?
      end

      # Descriptive Clause stuff
      rule (:relationship) do
        str("brother")       |
        str("sister")        |
        str("mother")        |
        str("father")        |
        str("son")           |
        str("daughter")      |
        str("grandson")      |
        str("granddaughter") |
        str("nephew")        |
        str("niece")         |
        str("uncle")         |
        str("aunt")          |
        str("relative")
      end
      rule (:gendered_clause)       {str("his") | str("her") | str("their")}
      rule (:familial_relationship) {gendered_clause >> space >> relationship | relationship  >> space  >>  str( "of previous")}
      rule (:the_artist)   {str("the artist")}
      rule (:actor_clause) {comma >> (the_artist | familial_relationship).as(:clause)}

      # Name Stuff
      rule(:token) {str("$AUTHORITY_TOKEN_") >> match["0-9"].repeat(6,6)}
      rule(:proper_name) {((words.as(:string) | token.as(:token)) >> certainty).as(:name) >> life_dates.maybe}
      rule(:actor)       {proper_name >> actor_clause.maybe >> location.maybe}

    end
  end
end