require_relative "../test_helper.rb"
describe "Full Text Parser" do



  let(:p) {Parsers::BaseParser.new}


  it "generically works" do    
    results = p.parse_with_debug("John Doe, Boise, ID; David Newbury.", reporter: Parslet::ErrorReporter::Contextual.new)
    # puts JSON.pretty_generate results
  end
end