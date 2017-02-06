require_relative "parser_helpers"

module MuseumProvenance
  module Parsers
    module DateParser
      include ParserHelpers
      include Parslet

      rule(:ordinal_suffix) { str("th") | str("st") | str("nd") | str("rd")}
      rule(:era)            { (str("CE") | str("BCE") | str("AD") | str("BC") | str("ad") | str('bc') | str("ce") | str("bce")).as("era")}
      rule(:the)            { match['tT'] >> str("he") >> space}
      rule(:century_word)   { match['cC'] >> str("entury")  >> space?}
      rule(:century_number) { match['0-9'].repeat(1,2).as("century_number") >> ordinal_suffix.maybe >> space}
      rule(:decade_year)    { (match["0-9"].repeat(1,3) >> str("0")).as("decade_number") >> str("s") >> space?}
      rule(:year_year)      { (match["0-9"].repeat(1,4).as("year_number")  >> space?)}
 
      rule(:month_names_tc)    {str("January") | str("february") | str("March") | str("April") | str("May") | str("June") | str("July") | str("August") | str("September") | str("October") | str("November") | str("December") }
      rule(:month_names_lc) {str("january") | str("february") | str("march") | str("april") | str("may") | str("june") | str("july") | str("august") | str("september") | str("october") | str("november") | str("december") }
      rule(:month_abb_tc)      {str("Jan") | str("Feb") | str("Mar") | str("Apr") | str("Jun") | str("Jul") | str("Aug") | str("Sept")| str("Sep") | str("Oct") | str("Nov") | str("Dec") }
      rule(:month_abb_lc)   {str("jan") | str("feb") | str("mar") | str("apr") | str("jun") | str("jul") | str("aug") | str("sept")| str("sep") | str("oct") | str("nov") | str("dec") }
      rule(:month_spelling) {str("febuary")}
      rule(:month_name)    {(month_names_tc| month_names_lc | month_abb_tc | month_abb_lc | month_spelling).as("month_name") >> (period | comma | space | str("., "))}

      rule(:day_number)     { match['0-9'].repeat(1,2).as("day_number")}
      rule(:month_number)   { (match['0-1'].maybe >> match["0-9"]).as("month_number")}


      rule(:century) { (the.maybe >> century_number >> century_word >> era.maybe >> certainty).as("century")}
      rule(:decade)  { (the.maybe >> decade_year >> era.maybe >> certainty).as("decade")}
      rule(:year)    { (year_year >> era.maybe >> certainty).as('year')}
      rule(:month)   { (month_name  >> year_year >> era.maybe >> certainty).as('month')}
      rule(:day)     { (month_name >> day_number >> (comma | space) >> year_year >> era.maybe >> certainty).as('day')}
      rule(:euroday) { (day_number >> space >> month_name >> year_year >> era.maybe >> certainty).as('day')}
      rule(:numdate) { (day_number >> str("/") >> month_number >> str("/") >> year_year >> era.maybe >> certainty ).as("day")}
      rule(:isodate) { (year_year >> str("-") >> month_number >> str("-") >> day_number >> era.maybe >> certainty ).as("day")}

      rule(:date) {
          (century | 
          decade  |
          year    |
          month   |
          day     |
          euroday |
          numdate |
          isodate).as("date")
      }

      # root(:date)

    end
  end
end