require_relative "parser_helpers"
require_relative "date_parser"

module MuseumProvenance
  module Parsers
    class DateStringParser < Parslet::Parser

      include ParserHelpers
      date = DateParser.new


      # KEYWORDS      
      rule(:no_date)              { (str("no date").as("nodate") | str("").as("nodate"))}
      rule(:begin_end_separator)  { space.maybe >> str("until") >> space }
      rule(:after)                { str("after")                >> space }
      rule(:by)                   { str("by")                   >> space }
      rule(:at_least)             { str("at least")             >> space }
      rule(:before)               { str("sometime before")      >> space }
      rule(:between)              { str("sometime between")     >> space }
      rule(:in_kw)                { str("in")                   >> space }
      rule(:and_kw)               { space? >> str("and")        >> space? }

      # DATE GRAMMAR (Needs rewritten)
      # rule(:date) {any.repeat(4,4)}

      # CLAUSES
      rule(:begin_date)    { after    >> date.as("botb") | 
                             by       >> date.as("eotb") }
      rule(:end_date)      { at_least >> date.as("bote") | 
                             before   >> date.as("eote") }
      rule(:in_date)       { in_kw    >> date.as("in") }
      rule(:between_begin) { between  >> date.as("botb") >> and_kw >> date.as("eotb")}
      rule(:between_end)   { between  >> date.as("bote") >> and_kw >> date.as("eote")}
     
      rule (:start_clause) {(in_date | between_begin | begin_date | date.as("begin"))}
      rule (:end_clause)   {(begin_end_separator >> (between_end | end_date | date.as("end")))}
     
      # SENTENCE GRAMMARS
      rule(:one_date)  {
                         start_clause >> end_clause.maybe |
                         end_clause
                       }
      

      rule(:date_string) { one_date | no_date }
      root(:date_string)

    end
  end
end
