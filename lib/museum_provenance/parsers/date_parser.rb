require_relative "parser_helpers"
require_relative "date_word_helpers"

module MuseumProvenance
  module Parsers

    #
    # * :era
    # * :century
    # * :decade
    # * :year
    # * :month
    # * :day
    # * :timezone
    #
    class DateParser  < Parslet::Parser
      include ParserHelpers
      include DateWordHelpers
      include Parslet

      
      rule(:century) { (the.maybe >> century_number >> century_word) >> era.maybe >> certainty}
      rule(:decade)  { (the.maybe >> decade_year) >> era.maybe >> certainty}
      rule(:year)    { year_year >> era.maybe >> certainty}
      rule(:month)   { month_name  >> year_year >> era.maybe >> certainty}
      rule(:day)     { month_name >> day_number >> (comma | space) >> year_year >> era.maybe >> certainty}
      rule(:euroday) { day_number >> space >> month_name >> year_year >> era.maybe >> certainty}
      rule(:numdate) { month_number >> str("/") >> day_number >> str("/") >> year_year >> era.maybe >> certainty }
      rule(:isodate) { year_year >> str("-") >> month_number >> str("-") >> day_number >> timezone.maybe >> era.maybe >> certainty }

      rule(:date) {
          (century | 
          decade  |
          day     |
          year    |
          month   |
          euroday |
          numdate |
          isodate).as(:date)
      }

      root(:date)

    end
  end
end