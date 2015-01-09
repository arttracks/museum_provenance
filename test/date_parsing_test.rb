require_relative "test_helper.rb"
describe DateExtractor do
  it "looks for centuries" do
    date = DateExtractor.find_dates_in_string("20th century")
    date.length.must_equal 1
    date.first.earliest.must_equal Date.new(1901,1,1).earliest
    date.first.latest.must_equal Date.new(2000,12,31).latest
    date = DateExtractor.find_dates_in_string("1st Century AD")
    date.length.must_equal 1
    date.first.earliest.must_equal Date.new(1).earliest
    date.first.latest.must_equal Date.new(100).latest
  end
  it "handles centuries BCE" do
    date = DateExtractor.find_dates_in_string("1st century BCE")
    date.length.must_equal 1

    date.first.earliest.must_equal Date.new(-100).earliest
    date.first.latest.must_equal Date.new(-1).latest
    date = DateExtractor.find_dates_in_string("4 century BC")

    date.length.must_equal 1
    date.first.earliest.must_equal Date.new(-400).earliest
    date.first.latest.must_equal Date.new(-301).latest
  end
  it "handles uncertain centuries" do
    date = DateExtractor.find_dates_in_string("1st century BCE?")
    date.length.must_equal 1
    date.first.earliest.must_equal Date.new(-100).earliest
    date.first.latest.must_equal Date.new(-1).latest
    date.first.certainty.must_equal false
  end

  it "handles decades" do
    date = DateExtractor.find_dates_in_string("The 1990s")
    date.length.must_equal 1
    date = date.first
    date.earliest.must_equal Date.new(1990).earliest
    date.latest.must_equal Date.new(1999).latest
    date = DateExtractor.find_dates_in_string("The 1500s") 
    date.length.must_equal 1
    date = date.first
    date.earliest.must_equal Date.new(1500).earliest
    date.latest.must_equal Date.new(1509).latest
  end
   it "handles uncertain decades" do
    date = DateExtractor.find_dates_in_string("The 1990s?")
    date.length.must_equal 1
    date = date.first
    date.earliest.must_equal Date.new(1990).earliest
    date.latest.must_equal Date.new(1999).latest
    date.certainty.must_equal false
  end
  it "handles years" do
    date = DateExtractor.find_dates_in_string("sometime in 1990")
    date.length.must_equal 1
    date = date.first
    date.earliest.must_equal Date.new(1990).earliest
    date.latest.must_equal Date.new(1990).latest
  end 
  it "handles years BCE" do
    date = DateExtractor.find_dates_in_string("800 BCE")
    date.length.must_equal 1
    date = date.first
    date.earliest.must_equal Date.new(-800).earliest
    date.latest.must_equal Date.new(-800).latest
  end 
  it "handles uncertain years" do
    date = DateExtractor.find_dates_in_string("sometime in 1990?")
    date.length.must_equal 1
    date = date.first
    date.must_equal Date.new(1990)
    date.certainty.must_equal false
  end 
  it "handles multiple years" do
    date = DateExtractor.find_dates_in_string("Between 400 BCE and 800 AD")
    date.length.must_equal 2
    date1 = date.first
    date1.earliest.must_equal Date.new(-400).earliest
    date1.latest.must_equal Date.new(-400).latest
    date2 = date.last
    date2.earliest.must_equal Date.new(800).earliest
    date2.latest.must_equal Date.new(800).latest
  end
  it "handles months" do
    date = DateExtractor.find_dates_in_string("January 1995")
    date.length.must_equal 1
    date = date.first
    date.earliest.must_equal Date.new(1995,1).earliest
    date.latest.must_equal Date.new(1995,1).latest
  end
  it "handles uncertain months" do
    date = DateExtractor.find_dates_in_string("January 1995?")
    date.length.must_equal 1
    date = date.first
    date.earliest.must_equal Date.new(1995,1).earliest
    date.latest.must_equal Date.new(1995,1).latest
    date.certainty.must_equal false
  end
  it "handles abbrev months" do
    date = DateExtractor.find_dates_in_string("Oct. 885")
    date.length.must_equal 1
    date = date.first
    date.earliest.must_equal Date.new(885,10).earliest
    date.latest.must_equal Date.new(885,10).latest
  end
  it "handles abbrev months without the period" do
    date = DateExtractor.find_dates_in_string("Oct 885")
    date.length.must_equal 1
    date = date.first
    date.earliest.must_equal Date.new(885,10).earliest
    date.latest.must_equal Date.new(885,10).latest
  end
  it "handles days" do
    date = DateExtractor.find_dates_in_string("October 17, 1980")
    date.length.must_equal 1
    date = date.first
    date.must_equal Date.new(1980,10,17)
  end
  it "handles uncertain days" do
    date = DateExtractor.find_dates_in_string("October 17, 1980?")
    date.length.must_equal 1
    date = date.first
    date.must_equal Date.new(1980,10,17)
    date.certainty.must_equal false
  end
  it "handles days with ordinals" do
    date = DateExtractor.find_dates_in_string("October 17th, 1980")
    date.length.must_equal 1
    date = date.first
    date.must_equal Date.new(1980,10,17)
    date = DateExtractor.find_dates_in_string("October 17th 1980")
    date.length.must_equal 1
    date = date.first
    date.must_equal Date.new(1980,10,17)
  end

  it "handles days with odd formatting" do
    date = DateExtractor.find_dates_in_string("Jan 17 1980")
    date.length.must_equal 1
    date = date.first
    date.must_equal Date.new(1980,1,17)
  end

   it "handles traditional dates" do
     date = DateExtractor.find_dates_in_string("1/17/1980")
     date.length.must_equal 1
     date = date.first
     date.must_equal Date.new(1980,1,17)
   end

   it "handles xml dates" do
     date = DateExtractor.find_dates_in_string("1980-1-17")
     date.length.must_equal 1
     date = date.first
     date.must_equal Date.new(1980,1,17)
   end
end

describe "Date removal" do
  it "handles dates" do
    str = DateExtractor.remove_dates_in_string("Sold January 1, 1980")
    str.must_equal "Sold "
  end
end

describe "Date Parsing Rules" do
  let(:p) {Period.new("Test Period")}

  it "handles straight dates" do
    p.parse_time_string "January 15, 2004"
    p.beginning.must_be_instance_of TimeSpan
    p.beginning.earliest.must_equal Date.new(2004,1,15).earliest
    p.beginning.latest.must_equal Date.new(2004,1,15).latest
    p.beginning.precise?.must_equal true
    p.ending.must_be_nil
  end

  it "handles 'on' in a string" do
    p.parse_time_string "on January 15, 2004"
    p.beginning.must_be_instance_of TimeSpan
    p.beginning.earliest.must_equal Date.new(2004,1,15).earliest
    p.beginning.latest.must_equal Date.new(2004,1,15).latest
    p.beginning.precise?.must_equal true
    p.ending.earliest.must_equal Date.new(2004,1,15).earliest
    p.ending.latest.must_equal Date.new(2004,1,15).latest
    p.ending.precise?.must_equal true
  end
  
  it "handles imprecise 'on' in a string" do
    p.parse_time_string "on January 2004"
    p.beginning.must_be_instance_of TimeSpan
    p.beginning.earliest.must_equal Date.new(2004,1).earliest
    p.beginning.latest.must_equal Date.new(2004,1).latest
    p.ending.must_be_nil
  end

  it "handles before in a string" do
    p.parse_time_string "before the 5th Century"
    p.beginning.must_be_instance_of TimeSpan
    p.beginning.earliest.must_be_nil 
    p.beginning.latest.must_equal Date.new(500).latest
    p.beginning.precise?.must_equal false
    p.ending.must_be_nil 
  end

  it "handles by in a string" do
    p.parse_time_string "by 1954"
    p.beginning.must_be_instance_of TimeSpan
    p.beginning.earliest.must_be_nil 
    p.beginning.latest.must_equal Date.new(1954).latest
    p.beginning.precise?.must_equal false
    p.ending.must_be_nil 
  end

  it "handles 'as of' in a string" do
    p.parse_time_string "as of 1954"
    p.beginning.must_be_instance_of TimeSpan
    p.beginning.earliest.must_be_nil 
    p.beginning.latest.must_equal Date.new(1954).latest
    p.beginning.precise?.must_equal false
    p.ending.must_be_nil
  end

  it "handles after in a string" do
    p.parse_time_string "after January 2, 1954"
    p.beginning.must_be_instance_of TimeSpan
    p.beginning.earliest.must_equal Date.new(1954,1,2).earliest
    p.beginning.latest.must_be_nil 
    p.beginning.precise?.must_equal false
    p.ending.must_be_nil  
  end

  it "handles two dates" do
    string = p.parse_time_string "Harry Graf von Kessler, Berlin and Weimar by 1901 until at least 1929"
    p.beginning.must_be_instance_of TimeSpan
    string.must_equal "Harry Graf von Kessler, Berlin and Weimar"
    p.beginning.earliest.must_be_nil 
    p.beginning.latest.must_equal Date.new(1901).latest
    p.beginning.precise?.must_equal false
    p.ending.must_be_instance_of TimeSpan  
    p.ending.earliest.must_equal Date.new(1929).earliest
    p.ending.latest.must_be_nil
    p.ending.same?.must_equal false  
  end

  it "handles until" do
    string = p.parse_time_string "Janet Fleisher Gallery, Philadelphia, until 1967"
    string.must_equal "Janet Fleisher Gallery, Philadelphia"
    p.beginning.must_be_nil
    p.ending.must_be_instance_of TimeSpan  
    p.ending.latest.must_equal Date.new(1967).latest
    p.ending.earliest.must_equal Date.new(1967).earliest
    p.ending.same?.must_equal true  
  end
  it "handles 'until sometime after' in a string" do
    p.parse_time_string "until sometime after January 1954"
    p.beginning.must_be_nil 
    p.ending.must_be_instance_of TimeSpan  
    p.ending.earliest.must_equal Date.new(1954,1).earliest
    p.ending.latest.must_be_nil
    p.ending.same?.must_equal false
  end

  it "handles 'until at least' in a string" do
    p.parse_time_string "until at least the 1980s"
    p.beginning.must_be_nil 
    p.ending.must_be_instance_of TimeSpan  
    p.ending.earliest.must_equal Date.new(1980).earliest
    p.ending.latest.must_be_nil
    p.ending.same?.must_equal false
  end

  it "handles 'until sometime before' in a string" do
    
    p.parse_time_string "david, until sometime before 1954"
    p.beginning.must_be_nil 
    p.ending.must_be_instance_of TimeSpan  
    p.ending.earliest.must_be_nil
    p.ending.latest.must_equal Date.new(1954).latest
    p.ending.same?.must_equal false
  end

  it "handles 'in' in a string" do
    
    p.parse_time_string "in 1954"
    p.beginning.must_be_instance_of TimeSpan
    p.beginning.earliest.must_be_nil
    p.beginning.latest.must_equal Date.new(1954).latest
    p.beginning.same?.must_equal false    
    p.ending.must_be_instance_of TimeSpan  
    p.ending.earliest.must_equal Date.new(1954).earliest
    p.ending.latest.must_be_nil
    p.ending.same?.must_equal false
  end

  it "handles between in a string" do
    p.parse_time_string "between 1954 and 1955"
    p.beginning.must_be_instance_of TimeSpan
    p.beginning.earliest.must_equal Date.new(1954).earliest
    p.beginning.latest.must_equal Date.new(1954).latest
    p.beginning.same?.must_equal true    
    p.ending.must_be_instance_of TimeSpan  
    p.ending.earliest.must_equal Date.new(1955).earliest
    p.ending.latest.must_equal Date.new(1955).latest
    p.ending.same?.must_equal true
  end

  it "handles until centuries" do
    p.parse_time_string "until the 7th Century"
    p.beginning.must_be_nil
    p.ending.must_be_instance_of TimeSpan  
    p.ending.earliest.must_equal Date.new(601).earliest
    p.ending.latest.must_equal Date.new(700).latest
  end

  it "handles ca. dates" do
    p.parse_time_string "ca. 1955"
    p.ending.must_be_nil
    p.beginning.must_be_instance_of TimeSpan  
    p.beginning.earliest.must_equal Date.new(1955).earliest
    p.beginning.latest.must_equal Date.new(1955).latest
    p.botb.certain.must_equal false
  end

  it "handles no time" do
    lambda { p.parse_time_string "Michael Snow, c/o The Isaacs Gallery, Toronto, ON"}.must_raise MuseumProvenance::DateError
    p.ending.must_be_nil
    p.beginning.must_be_nil
  end

  it "handles until December 1969" do
    p.parse_time_string "until December 1969"
  end

  it "handles decades without a the" do
    p.parse_time_string "Estate sale, Cleveland, Ohio, the 1950s"
    p.ending.must_be_nil
    p.beginning.must_be_instance_of TimeSpan
    p.beginning.earliest.must_equal Date.new(1950).earliest
    p.beginning.latest.must_equal Date.new(1959).latest
    p.beginning.to_s.must_equal "the 1950s"
  end
  it "does not notice the spurious 'in' and think it's part of the date" do
     p.parse_time_string  "Estate sale in Cleveland, Ohio, 1950s"
     p.time_string.must_equal "the 1950s"
     p.ending.must_be_nil
     p.beginning.must_be_instance_of TimeSpan
     p.beginning.earliest.must_equal Date.new(1950).earliest
     p.beginning.latest.must_equal Date.new(1959).latest
  end

  it "handles year ranges without century" do
    p.parse_time_string "1954-55"
    p.beginning.must_be_instance_of TimeSpan
    p.beginning.earliest.must_equal Date.new(1954).earliest
    p.beginning.latest.must_equal Date.new(1954).latest
    p.beginning.same?.must_equal true    
    p.ending.must_be_instance_of TimeSpan  
    p.ending.earliest.must_equal Date.new(1955).earliest
    p.ending.latest.must_equal Date.new(1955).latest
    p.ending.same?.must_equal true
  end
end

describe "Date rules" do
  let(:p) {Period.new("Date Test Period")}
  let(:p?) {Period.new("Uncertain Date Test Period")}
  let(:pbce) {Period.new("BCE Date Test Period")}

  it "handles standard centuries" do
    time_strings = ["the 19th century", "19th century", "19 century", "the 19 century", "19th Century", "19th Century AD", "19th Century ad", "the 19th Century CE"]
    time_strings.each do |ts|
      p.parse_time_string ts
      p.beginning.earliest.year.must_equal 1801
      p.beginning.latest.year.must_equal 1900
      p.beginning.earliest_raw.precision.must_equal DateTimePrecision::CENTURY
      p.time_string.must_equal "the 19th century"
      p?.parse_time_string "#{ts}?"
      p?.time_string.must_equal "the 19th century?"

    end
  end
  it "handles early CE centuries" do
    time_strings = ["the 8th century", "8th century", "8 century", "the 8 century", "8th Century", "8th Century AD", "8th Century ad", "the 8th Century CE"]
    time_strings.each do |ts|
      p.parse_time_string ts
      p.beginning.earliest.year.must_equal 701
      p.beginning.latest.year.must_equal 800  
      p.beginning.earliest_raw.precision.must_equal DateTimePrecision::CENTURY
      p.time_string.must_equal "the 8th century CE"
      p?.parse_time_string "#{ts}?"
      p?.time_string.must_equal "the 8th century CE?"
    end
  end
  it "handles BCE centuries" do
    time_strings = ["the 8th century BCE", "8th century BCE", "8 century BCE", "the 8 century BCE", "8th Century BCE", "8th Century BC"]
    time_strings.each do |ts|
      p.parse_time_string ts
      p.beginning.earliest.year.must_equal -800
      p.beginning.latest.year.must_equal -701
      p.beginning.earliest_raw.precision.must_equal DateTimePrecision::CENTURY
      p.time_string.must_equal "the 8th century BCE"
      p?.parse_time_string "#{ts}?"
      p?.time_string.must_equal "the 8th century BCE?"
    end
  end
  it "handles decades" do
    time_strings = ["the 1880s", "1880s", "1880s CE", "the 1880s ad"]
    time_strings.each do |ts|
      p.parse_time_string ts
      p.beginning.earliest.year.must_equal 1880
      p.beginning.latest.year.must_equal 1889
      p.beginning.earliest_raw.precision.must_equal DateTimePrecision::DECADE
      p.time_string.must_equal "the 1880s"
      p?.parse_time_string "#{ts}?"
      p?.time_string.must_equal "the 1880s?"

    end
  end
  it "does not handle invalid decades" do
    time_strings = ["the 80s", "880s BCE", "1880s BCE"]
    time_strings.each do |ts|
      lambda{p.parse_time_string ts}.must_raise MuseumProvenance::DateError
      p.time_string.must_be_nil
      p.beginning.must_be_nil
    end
  end
  it "handles years" do
     time_strings = ["1880", "1880 ad", "1880 AD", "1880 CE", "1880 ce"]
    time_strings.each do |ts|
      p.parse_time_string ts
      p.beginning.earliest.year.must_equal 1880
      p.beginning.latest.year.must_equal 1880
      p.beginning.earliest_raw.precision.must_equal DateTimePrecision::YEAR
      p.time_string.must_equal "1880"
      p?.parse_time_string "#{ts}?"
      p?.time_string.must_equal "1880?"
      
    end
  end
  it "handles years BCE" do
     time_strings = ["1880 bc", "1880 bce", "1880 BC", "1880 BCE"]
    time_strings.each do |ts|
      p.parse_time_string ts
      p.beginning.earliest.year.must_equal -1880
      p.beginning.latest.year.must_equal -1880
      p.beginning.earliest_raw.precision.must_equal DateTimePrecision::YEAR
      p.time_string.must_equal "1880 BCE"
      p?.parse_time_string "#{ts}?"
      p?.time_string.must_equal "1880 BCE?"

    end
  end
  it "handles  early years CE" do
    time_strings = ["880 ce", "880 ad", "880 CE"]
    time_strings.each do |ts|
      p.parse_time_string ts
      p.beginning.earliest.year.must_equal 880
      p.beginning.latest.year.must_equal 880
      p.beginning.earliest_raw.precision.must_equal DateTimePrecision::YEAR
      p.time_string.must_equal "880 CE"
      p?.parse_time_string "#{ts}?"
      p?.time_string.must_equal "880 CE?"
    end
  end
  it "does not handle raw early years CE" do
    lambda{p.parse_time_string "880"}.must_raise MuseumProvenance::DateError
  end
  it "handles months" do
    time_strings = ["October 1990", "October 1990 CE", "Oct. 1990", " oct 1990 CE", "oct. 1990", "october 1990", "October, 1990", "Oct., 1990"]
    time_strings.each do |ts|
      p.parse_time_string ts
      "#{ts} becomes #{p.time_string}".must_equal "#{ts} becomes October 1990"
      p.beginning.earliest.year.must_equal 1990
      p.beginning.latest.year.must_equal 1990
      p.beginning.earliest.month.must_equal 10
      p.beginning.earliest.month.must_equal 10
      p.beginning.earliest_raw.precision.must_equal DateTimePrecision::MONTH
      p?.parse_time_string "#{ts}?"
      p?.time_string.must_equal "October 1990?"
    end
  end
  it "handles early months" do
    time_strings = ["October 990", "October 990 CE", "Oct. 990", " oct 990 CE", "oct. 990", "october 990"]
    time_strings.each do |ts|
      p.parse_time_string ts
      p.time_string.must_equal "October 990 CE"
      p.beginning.earliest.year.must_equal 990
      p.beginning.latest.year.must_equal 990
      p.beginning.earliest.month.must_equal 10
      p.beginning.earliest.month.must_equal 10
      p.beginning.earliest_raw.precision.must_equal DateTimePrecision::MONTH
      p?.parse_time_string "#{ts}?"
      p?.time_string.must_equal "October 990 CE?"
    end
  end
  it "handles days" do
    time_strings = ["October 17, 1990", "October 17, 1990 CE","October 17, 1990 AD", "Oct. 17, 1990", 
                    "oct 17, 1990 CE", "oct. 17, 1990", "october 17, 1990", 
                    "October 17 1990", "Oct 17, 1990", 
                    "17 October 1990", "17 October, 1990", "17 Oct. 1990", "17 Oct., 1990",
                    "10/17/1990", "1990-10-17"]
    time_strings.each do |ts|
      p.parse_time_string ts
      "#{ts} becomes #{p.time_string}".must_equal "#{ts} becomes October 17, 1990"
      p.beginning.earliest.year.must_equal 1990
      p.beginning.latest.year.must_equal 1990
      p.beginning.earliest.month.must_equal 10
      p.beginning.earliest.month.must_equal 10
      p.beginning.earliest.day.must_equal 17
      p.beginning.latest.day.must_equal 17
      p.beginning.earliest_raw.precision.must_equal DateTimePrecision::DAY
      ts2 = "#{ts.gsub(" CE","").gsub(" AD","")} BCE"
      unless ts == "1990-10-17"
        pbce.parse_time_string ts2
        "#{ts2} becomes #{pbce.time_string}".must_equal "#{ts2} becomes October 17, 1990 BCE"
        pbce.beginning.earliest.year.must_equal -1990
        pbce.beginning.latest.year.must_equal -1990
        pbce.beginning.earliest.month.must_equal 10
        pbce.beginning.earliest.month.must_equal 10
        pbce.beginning.earliest.day.must_equal 17
        pbce.beginning.latest.day.must_equal 17
      end
      p?.parse_time_string "#{ts}?"
      p?.time_string.must_equal "October 17, 1990?"
    end
  end
end