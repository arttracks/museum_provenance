require_relative "parser_helpers"
require_relative "place_parser"
require_relative "date_parser"

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


      #rule (:era)  {(space >> str("CE").as(:era) | space >> str("BCE").as(:era) | str("").as(:era))}
      #rule (:year) {(match["1-9"] >> match["0-9"].repeat(0,3)).as(:year) >> era }

      rule (:life_dates) do
        space >>
        str("[") >> 
        (DateParser.new.maybe).as(:birth) >>
        (str("-") | str(" - ")) >>
        (DateParser.new.maybe).as(:death) >>
        str("]")
      end

      # Descriptive Clause stuff
      rule (:relationship) do
        str("brother")       |
        str("sister")        |
        str("mother")        |
        str("father")        |
        str("son")           |
        str("daughter")      |
        str("grandchild")    |
        str("grandparent")   |
        str("nephew")        |
        str("niece")         |
        str("uncle")         |
        str("aunt")          |
        str("husband")       |
        str("wife")          |
        str("relative")
      end
      rule (:gendered_clause)       {str("his") | str("her") | str("their")}
      rule (:familial_relationship) {gendered_clause >> space >> relationship | relationship  >> space  >>  str( "of previous")}
      rule (:the_artist)   {str("the artist")}
      rule (:actor_clause) {comma >> (the_artist | familial_relationship).as(:clause)}

      # Name Stuff
      rule(:proper_name) {(((capitalized_words | words).as(:string) | token.as(:token)) >> certainty).as(:name) >> life_dates.maybe}
      rule(:actor)       {proper_name >> actor_clause.maybe >> (comma >> PlaceParser.new).maybe}

    end
  end
end