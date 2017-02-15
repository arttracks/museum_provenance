require "parslet"

module MuseumProvenance
  module Parsers
    module DateWordHelpers 
      include Parslet

      rule(:ordinal_suffix) { str("th") | str("st") | str("nd") | str("rd")}
      rule(:era)            { (str("CE") | str("ce") | str("BCE") | str("bce") | str("AD")  | str("ad") | str("BC") | str('bc') | str("")).as(:era)}
      rule(:the)            { match['tT'] >> str("he") >> space}
      rule(:century_word)   { match['cC'] >> str("entury")  >> space?}
      rule(:century_number) { match['0-9'].repeat(1,2).as(:century) >> ordinal_suffix.maybe >> space}
      rule(:decade_year)    { (match["0-9"].repeat(1,3) >> str("0")).as(:decade) >> str("s") >> space?}
      rule(:year_year)      { (match["0-9"].repeat(1,4).as(:year)  >> space?)}
      
      rule(:month_names_tc) {str("January") | str("February") | str("March") | str("April") | str("May") | str("June") | str("July") | str("August") | str("September") | str("October") | str("November") | str("December") }
      rule(:month_names_lc) {str("january") | str("february") | str("march") | str("april") | str("may") | str("june") | str("july") | str("august") | str("september") | str("october") | str("november") | str("december") }
      rule(:month_abb_tc)   {str("Jan") | str("Feb") | str("Mar") | str("Apr") | str("Jun") | str("Jul") | str("Aug") | str("Sept")| str("Sep") | str("Oct") | str("Nov") | str("Dec") }
      rule(:month_abb_lc)   {str("jan") | str("feb") | str("mar") | str("apr") | str("jun") | str("jul") | str("aug") | str("sept")| str("sep") | str("oct") | str("nov") | str("dec") }
      rule(:month_spelling) {str("febuary")}
      rule(:month_name)     {(month_names_tc| month_names_lc | month_abb_tc | month_abb_lc | month_spelling).as(:month) >> (period | comma | space | str("., "))}

      rule(:day_number)     { match['0-9'].repeat(1,2).as(:day) >> ordinal_suffix.maybe}
      rule(:month_number)   { (match['0-1'].maybe >> match["0-9"]).as(:month)}

      rule(:timezone)       {str("Z").as(:timezone) | (match["-+"] >> match["01"] >> match["0-9"] >> str(":") >> match["0-9"].repeat(2,2)).as(:timezone)}
      
    end
  end
end
