require_relative "../test_helper.rb"
describe Parsers::PlaceParser do

  let(:p) {Parsers::PlaceParser.new}

  it "generically works" do
    begin
      results = p.parse("Boise, ID")
      puts "\nPLACE STRUCTURE:\n#{JSON.pretty_generate results}" if ENV["DEBUG"]
    rescue Parslet::ParseFailed => failure
      puts failure.cause.ascii_tree
    end
  end
  it "works with a comma" do
    results = p.parse("Boise, ID")
    results[:place][:string].must_equal "Boise, ID"
  end 

  it "does not consume following comma" do
    proc { p.parse("Boise, ID,") }.must_raise(Parslet::ParseFailed)
    # results[:place][:string].must_equal "Boise, ID"
  end 

  it "does not consume following period" do
    proc { p.parse("Boise, ID.") }.must_raise(Parslet::ParseFailed)
    # results[:place][:string].must_equal "Boise, ID"
  end 

    it "does not consume following 'for'" do
    proc { p.parse("Boise, ID, for") }.must_raise(Parslet::ParseFailed)
    # results[:place][:string].must_equal "Boise, ID"
  end 

  it "works without a comma" do
    results = p.parse("France")
    results[:place][:string].must_equal "France"
  end 
  it "works with three clauses" do
    results = p.parse("Westminster Abbey, London, England")
    results[:place][:string].must_equal "Westminster Abbey, London, England"
  end 
  it "works with uncertainty" do
    results = p.parse("London, England?")
    results[:place][:string].must_equal "London, England"
    results[:place][:certainty].must_equal "?"
  end 

  it "works with a token" do
    results = p.parse("$AUTHORITY_TOKEN_123456")
    results[:place][:token].must_equal "$AUTHORITY_TOKEN_123456"
  end 

end