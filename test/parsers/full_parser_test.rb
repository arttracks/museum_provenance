require_relative "../test_helper.rb"
describe "Full Text Parser" do



  let(:p) {Parsers::BaseParser.new}


  it "generically works" do 
    str  = "Possibly "
    str += "purchased at auction by "
    str += "John Doe? [1910?-1995?], "
    str += "Boise, ID, "
    str += "for Sally Moe, "
    str += "wife of previous, "
    str += %{at "Sale of Pleasant Goods", Christie's, London}
    str += "in London, England, "
    str += "sometime after November 5, 1975 "
    str += "(stock no. 10, for $1000)"
    str += " [1][a][b]"
    str += "; "
    str += "David Newbury."
     # puts "\n"
     # puts str
     # puts (0..20).collect{|n| "#{n}0".ljust(10)}.join("")
    results = p.parse_with_debug(str, reporter: Parslet::ErrorReporter::Deepest.new)
    puts JSON.pretty_generate results if ENV["DEBUG"]
  end

  it "works with sale info" do    
    results = p.parse_with_debug("John Doe, Boise, ID (for $100).", reporter: Parslet::ErrorReporter::Contextual.new)
    results[0][:owner][:name][:string].must_equal "John Doe"
    results[0][:owner][:place][:string].must_equal "Boise, ID"
    results[0][:purchase][:value].must_equal("100")
    results[0][:purchase][:currency_symbol].must_equal("$")
  end

  it "works with both types of agents" do
    str = "Paul PurchaserAgent for Owen Owner at Sally SellerAgent."
    results = p.parse_with_debug(str, reporter: Parslet::ErrorReporter::Deepest.new)
    results[0][:owner][:name][:string].must_equal "Owen Owner"
    results[0][:purchasing_agent][:name][:string].must_equal "Paul PurchaserAgent"
    results[0][:sellers_agent][:name][:string].must_equal "Sally SellerAgent"
  end

  it "doesn't eat dates as part of places" do
    str = "Carnegie Institute, in Pittsburgh, PA, November 5, 1934;"
    results = p.parse_with_debug(str, reporter: Parslet::ErrorReporter::Contextual.new)
    results[0][:owner][:name][:string].must_equal "Carnegie Institute"
    results[0][:transfer_location][:place][:string].must_equal "Pittsburgh, PA"
  
  end
  it "works with acquisition info" do    
    results = p.parse_with_debug("Purchased by John Doe.", reporter: Parslet::ErrorReporter::Contextual.new)
    results[0][:owner][:name][:string].must_equal "John Doe"
    results[0][:acquisition_method].must_equal "Purchased by"
  end

  it "works with acquisition info as lowercase" do    
    results = p.parse_with_debug("via marriage, to John Doe.", reporter: Parslet::ErrorReporter::Contextual.new)
    results[0][:owner][:name][:string].must_equal "John Doe"
    results[0][:acquisition_method].must_equal "via marriage, to"
  end

  it "works with dali test" do
    str = %{Created by Salvador Dali [1904-1989], the artist, 1934. Purchased by Cyrus L. Sulzberger [1912-1993], Pittsburgh, PA, at "International Exhibition of Paintings", Carnegie Institute, in Pittsburgh, PA, November 5, 1934 (for $350) [1][a]; purchased by unnamed dealer, sometime in 1938? [b]; purchased by Thomas J. Watson [1874-1956] for IBM, sometime before May 1939 [2][c]; purchased by Cyrus L. Sulzberger, 1942 until at least 1969 [3][d]. Purchased by Nesuhi Ertegun and Selma Ertegun, New York, NY, sometime before June 1999 [e]; purchased by unknown private collection? [f]; purchased by Fundació Gala-Salvador Dalí, sometime before May 2011 (for $11M) [g].}
    results = p.parse_with_debug(str, reporter: Parslet::ErrorReporter::Contextual.new)
  end
end