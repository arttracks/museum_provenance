Dir["#{File.dirname(__FILE__)}/*.rb"].sort.each { |f| require(f) }

module MuseumProvenance
  module Parsers
    class BaseParser < Parslet::Parser
    include Parslet

    include AcquisitionMethodParser

    def initialize(opts = {})
      @acquisition_methods = opts[:acquisition_methods] || AcquisitionMethod.valid_methods
    end

    def stri(str)
        key_chars = str.split(//)
        key_chars.
          collect! { |char| match["#{char.upcase}#{char.downcase}"] }.
          reduce(:>>)
      end

    rule(:period) {(period_certainty >> acquisition >> custody >> owner >> ownership_period >> period_end).as(:period) }
    rule(:provenance) {period.repeat(1)}
    root :provenance
      include Parslet

      # Whitespace Rules     
      rule(:space)            { match('\s').repeat(1) }
      rule(:space?)           { space.maybe }
      rule(:eof)              { any.absent? }
          
      # Word rules    
      rule(:word)             { match["A-Za-z"].repeat(1) }
      rule(:words)            { (word |space >> word ).repeat(1)}
      rule(:word_phrase)      { word >> phrase_end }
        
      # Punctuation
      rule(:comma)            { str(",") >> space }
      rule(:period_end)       { (str(".") | str(";")) >> (space | eof) }
      rule(:phrase_end)       { (comma | space) }
      rule(:certainty)        { (str("?") | str("")).as(:certainty)}

      # Date Stuff
      rule (:year)            { str("-").maybe >> match["0-9"].repeat(1,4) }
      rule (:date_string) {
        (year |
        (str("in") >> space >> year)) >> space?
      }


      rule (:life_dates) do
        space >>
        str("[") >> 
        year.maybe.as(:birth) >> 
        certainty.as(:birth_certainty) >>
        (str("-") | str(" - ")) >>
        year.maybe.as(:death) >>
        certainty.as(:death_certainty) >>
        str("]") >>
        space?
      end

      # Location Stuff  
      rule(:location) do
        ( custody_start.absent? >>
          ownership_start.absent? >> 
          date_string.absent? >> word_phrase
        ).repeat(1).as(:location)
      end
      
      # Name Stuff
      rule(:proper_name) {words.as(:name) >> certainty.as(:name_certainty) >> life_dates.maybe >>  comma}

      # Provenance Sections

      rule (:period_certainty)  { ((stri("Possibly")  >> space) | str("")).as(:period_certainty_value).as(:period_certain)}

      rule (:ownership_period) {date_string.as(:date).maybe}

      rule(:period) {(period_certainty >> party_metadata >> ownership_period >> period_end).as(:period) }
      rule(:provenance) {period.repeat(1)}
 
      root :provenance
    end
  end
end