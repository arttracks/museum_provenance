require "parslet"
require_relative "lib/museum_provenance/parsers/date_parser.rb"
require_relative "lib/museum_provenance/parsers/date_string_parser.rb"

include MuseumProvenance::Parsers

strings = [
  "",
  "1995 until 1996",
  "1995 until at least 1996",
  "1995 until sometime before 1996",
  "1995 until sometime between 1996 and 1997",
  "1995",
  "after 1995 until 1996",
  "after 1995 until at least 1996",
  "after 1995 until sometime before 1996",
  "after 1995 until sometime between 1996 and 1997",
  "after 1995",
  "by 1995 until 1996",
  "by 1995 until at least 1996",
  "by 1995 until sometime before 1996",
  "by 1995 until sometime between 1996 and 1997",
  "by 1995",
  "in 1995 until sometime before 1995",
  "in 1995",
  "no date",
  "sometime between 1995 and 1996 until 1997",
  "sometime between 1995 and 1996 until at least 1996",
  "sometime between 1995 and 1996 until at least 1997",
  "sometime between 1995 and 1996 until sometime before 1997",
  "sometime between 1995 and 1996 until sometime between 1997 and 1998",
  "sometime between 1995 and 1996",
  "until 1996",
  "until at least 1996",
  "until sometime before 1996",
  "until sometime between 1995 and 1996",
]



(strings).each do |str|
    results = DateStringParser.new.parse(str)
    if results.to_s.include?("trash") || true
      puts "\n---------------------------------\n"
      puts "parsing \"#{str}\":"
      puts results.inspect
  end
end
  
#     puts "\n---------------------------------\n"
#     puts "parsing \"#{str}\":"
#     puts results.inspect
#   "10 ad", "1 BC", "6000 BCE", "800","1990", "900 CE", "800 BCE",
#   "1990?", "900 CE?", "800 BCE?",
#   "19th century", "20th Century ad", "19 Century", "4th century BC",
#   "June 11 1995", "Oct. 17, 1980", "june 15, 90 BCE", "9 June 1932", "9 June, 1932", "10/17/1980","1980-10-17"
#   "June 11, 1995", "June 11, 880 CE", "June 11, 880 BCE", "June 11, 1990?",
#   "June 2000 CE", "March 880", "January 80", "aug. 1995", 'August, 1995', 'Aug., 1995',
#   "October 1990", "October 990 CE", "October 1990?",
#   "the 1990s", "the 1990s?", "1990s", "1990s CE", "the 1990s AD",
#   "the 19th century", "the 1st century CE", "the 2nd century BCE",
#   "the 19th century?", "the 8th century BCE?",
#   end
#   if results["date"].include?("trash") || false
#   results = DateParser.new.parse(str)
# (strings).each do |str|
# ]
# end
# strings = [


