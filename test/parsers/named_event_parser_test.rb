require_relative "../test_helper.rb"
describe Parsers::PlaceParser do

  let(:p) {Parsers::NamedEventParser.new}

  it "generically works" do
    begin
      results = p.parse(%{from "Sale of Pleasant Goods", Christie's, London})
      puts "\nNAMED EVENT STRUCTURE:\n#{JSON.pretty_generate results}" if ENV["DEBUG"]
    rescue Parslet::ParseFailed => failure
      puts failure.cause.ascii_tree
    end
  end
  it "works with a comma" do
    results = p.parse(%{from "Sale of Pleasant, Lovely Goods", Christie's})
    results[:event][:string].must_equal "Sale of Pleasant, Lovely Goods"
    results[:sellers_agent][:name][:string].must_equal "Christie's"
  end 

  it "works with a token" do
    results = p.parse(%{from "$AUTHORITY_TOKEN_123456"})
    results[:event][:token].must_equal "$AUTHORITY_TOKEN_123456"
  end 

  it "works without a party" do
    results = p.parse(%{from "Sale of Pleasant, Lovely Goods"})
    results[:event][:string].must_equal "Sale of Pleasant, Lovely Goods"
  end 

  it "works without an event" do
    results = p.parse(%{from Paul PurchasingAgent})
    results[:sellers_agent][:name][:string].must_equal "Paul PurchasingAgent"
  end

  it "works with a through" do
    results = p.parse(%{through Paul PurchasingAgent})
    results[:sellers_agent][:name][:string].must_equal "Paul PurchasingAgent"
  end

  it "works with a through and an at" do
    results = p.parse(%{through Paul PurchasingAgent from "Sale of Pleasant, Lovely Goods"})
    results[:sellers_agent][:name][:string].must_equal "Paul PurchasingAgent"
    results[:event][:string].must_equal "Sale of Pleasant, Lovely Goods"
  end
  it "works with a through and an from w/location " do
    results = p.parse_with_debug(%{through Paul PurchasingAgent, London, England, from "Sale of Pleasant, Lovely Goods"})
    results[:sellers_agent][:name][:string].must_equal "Paul PurchasingAgent"
    results[:sellers_agent][:place][:string].must_equal "London, England"
    results[:event][:string].must_equal "Sale of Pleasant, Lovely Goods"
  end
  it "works with a through and an from w/location without a comma " do
    results = p.parse_with_debug(%{through Paul PurchasingAgent, London, England from "Sale of Pleasant, Lovely Goods"})
    results[:sellers_agent][:name][:string].must_equal "Paul PurchasingAgent"
    results[:sellers_agent][:place][:string].must_equal "London, England"
    results[:event][:string].must_equal "Sale of Pleasant, Lovely Goods"
  end

end