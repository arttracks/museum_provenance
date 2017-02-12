require_relative "../test_helper.rb"
describe "Full Text Parser" do



  let(:p) {Parsers::BaseParser.new}


  it "generically works" do    
    results = p.parse_with_debug("John Doe, Boise, ID; David Newbury.", reporter: Parslet::ErrorReporter::Contextual.new)
    # puts JSON.pretty_generate results
  end
  it "works with sale info" do    
    results = p.parse_with_debug("John Doe, Boise, ID, (for $100).", reporter: Parslet::ErrorReporter::Contextual.new)
    # puts JSON.pretty_generate results
    results[0][:owner][:name][:string].must_equal "John Doe"
    results[0][:owner][:place][:string].must_equal "Boise, ID"
    results[0][:purchase][:value].must_equal("100")
  end
end