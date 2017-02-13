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
    str += ";"
    str += "David Newbury."
     # puts "\n"
     # puts str
     # puts (0..20).collect{|n| "#{n}0".ljust(10)}.join("")
    results = p.parse_with_debug(str, reporter: Parslet::ErrorReporter::Contextual.new)
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
end