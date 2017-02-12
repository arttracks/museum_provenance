require_relative "../test_helper.rb"
describe Parsers::PlaceParser do

  let(:p) {Parsers::NamedEventParser.new}

  it "generically works" do
    begin
      results = p.parse(%{at "Sale of Pleasant Goods", Christie's, London})
      puts "\nNAMED EVENT STRUCTURE:\n#{JSON.pretty_generate results}" if ENV["DEBUG"]
    rescue Parslet::ParseFailed => failure
      puts failure.cause.ascii_tree
    end
  end
  it "works with a comma" do
    results = p.parse(%{at "Sale of Pleasant, Lovely Goods", Christie's})
    results[:event][:string].must_equal "Sale of Pleasant, Lovely Goods"
  end 

  it "works with a token" do
    results = p.parse(%{at "$AUTHORITY_TOKEN_123456"})
    results[:event][:token].must_equal "$AUTHORITY_TOKEN_123456"
  end 

  it "works without a party" do
    results = p.parse(%{at "Sale of Pleasant, Lovely Goods"})
    results[:event][:string].must_equal "Sale of Pleasant, Lovely Goods"
  end 
end