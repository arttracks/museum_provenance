require_relative "parser_helpers"
require_relative "place_parser"
require 'cultural_dates'

module MuseumProvenance
  module Parsers
    # 
    # This parser will parse a Actor entity block, for example:
    # > John Doe? [1910?-1995?], Boise, ID
    # 
    # If it parses, it can return:
    #
    # * :birth          # The birthdate of the actor (as a :date)
    # * :death          # The deathdate of the actor (as a :date)
    # * :clause         # a qualifiers for the actor; familial or artist
    # * :name           # The name of the artist, either a :string or a :token
    # * :place          # The location associated with the artist as a :place, 
    #                   #     containing neither a :string or a :token
    #
    # (Valid clauses are either "the artist" or "his/her/their <relationship>",
    # for example "his brother".  It will also accept them as 
    # "<relationship> of previous", for example "sister of previous."  This is
    # perhaps a better form, since it does not assign a gender to the previous
    # entity, and does a better job of conveying the semantic meaning of the
    # clause.)
    # 
    # @author [@workergnome]
    # 
    class ActorParser < Parslet::Parser

      include ParserHelpers
      include Parslet

      RELATIONSHIP_WORDS = %w{brother sister sibling mother father parent son daughter child grandchild grandparent nephew niece uncle aunt husband wife spouse relative}

      root(:actor)

      rule (:life_dates) do
        space >>
        str("[") >> 
        (CulturalDates::DateParser.new.maybe).as(:birth) >>
        (str("-") | str(" - ")) >>
        (CulturalDates::DateParser.new.maybe).as(:death) >>
        str("]")
      end

      # Descriptive Clause stuff
      rule (:relationship) do
        RELATIONSHIP_WORDS.collect{ |word| str("#{word}") }.reduce(:|)
      end

      rule (:gendered_clause)       {str("his") | str("her") | str("their")}
      rule (:familial_relationship) {proper_name >> str("'s") >> space >> relationship.as(:type) >> comma}
      rule (:the_artist)   {str("the artist")}
      rule (:actor_clause) {comma >> (the_artist).as(:clause)}

      rule(:unpossesive_word)              { ((str("'s") >> space >> relationship).absent? >> word_parts).repeat(1) }
      rule(:unpossessive_captal_word)      { initial | match["[[:upper:]]"] >> unpossesive_word |  match["[[:upper:]]"] }
      rule(:unpossesive_words)             { (unpossesive_word | space >> unpossesive_word).repeat(1)}
      rule(:unpossesive_capitalized_words) { ((initial | unpossessive_captal_word) | space >> stop_words.absent? >> (initial | unpossessive_captal_word) ).repeat(1)}


      # Name Stuff
      rule(:proper_name) {(((unpossesive_capitalized_words | unpossesive_words).as(:string) | token.as(:token)) >> certainty).as(:name) >> life_dates.maybe}
      rule(:actor)       {familial_relationship.as(:relationship).maybe >> proper_name >> actor_clause.maybe >> (comma >> PlaceParser.new).maybe}

    end
  end
end