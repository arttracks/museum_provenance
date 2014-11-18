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
    
    p.parse_time_string "until sometime before 1954"
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
  
end