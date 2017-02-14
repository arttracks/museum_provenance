require_relative "../test_helper.rb"
describe Parsers::ActorParser do

  let(:p) {Parsers::ActorParser.new}

  it "generically works" do
    begin
      results = p.parse("John Doe? [1910?-1995?], the artist, Boise, ID")
      puts "\nACTOR STRUCTURE:\n#{JSON.pretty_generate results}" if ENV["DEBUG"]
    rescue Parslet::ParseFailed => failure
      puts failure.cause.ascii_tree
    end
  end

  it "works with just a name" do
    results = p.parse("John Doe")
    results[:name][:string].must_equal "John Doe"
  end 

  it "works with all lowercase names" do
    str = "an unnamed dealer"
    results = p.parse(str)
    results[:name][:string].must_equal str
  end

  it "works with a name with a single letter" do
    str = "John G Doe"
     results = p.parse(str)
    results[:name][:string].must_equal str
  end

  it "works with a name with an initial" do
    str = "John G. Doe"
     results = p.parse_with_debug(str)
    results[:name][:string].must_equal str
  end

  it "works with unicode names" do
    str =  "Fundació Gala-Salvador Dalí"
    results = p.parse_with_debug(str)
    results[:name][:string].must_equal str
  end

  it "works with a all caps name" do
    str = "IBM"
    results = p.parse_with_debug(str)
    results[:name][:string].must_equal str
  end

  

  it "works with a name and a relationship" do
    results = p.parse("John Doe, his son")
    results[:name][:string].must_equal "John Doe"
    results[:clause].must_equal "his son"
  end 


  it "works with a name and a previous relationship" do
    results = p.parse("John Doe, son of previous")
    results[:name][:string].must_equal "John Doe"
    results[:clause].must_equal "son of previous"
  end 


  it "works for artists" do
    results = p.parse("John Doe, the artist")
    results[:name][:string].must_equal "John Doe"
    results[:clause].must_equal "the artist"
  end 

  it "works with a name token" do
    results = p.parse("$AUTHORITY_TOKEN_123456")
    results[:name][:token].must_equal "$AUTHORITY_TOKEN_123456"
  end 


  it "works with a name and life dates" do
    results = p.parse("John Doe [1990-1991]")
    results[:name][:string].must_equal "John Doe"
    results[:birth][:date][:year].must_equal "1990"
    results[:death][:date][:year].must_equal "1991"
    results[:birth][:date][:certainty][:certainty_value].must_equal ""
    results[:death][:date][:certainty][:certainty_value].must_equal ""
  end

  it "works with just birth dates" do
    results = p.parse("John Doe [1990-]")
    results[:name][:string].must_equal "John Doe"
    results[:birth][:date][:year].must_equal "1990"
    results[:birth][:date][:certainty][:certainty_value].must_equal ""
    results[:death].must_be_nil
  end

  it "works with just death dates" do
    results = p.parse("John Doe [-1990]")
    results[:name][:string].must_equal "John Doe"
    results[:death][:date][:year].must_equal "1990"
    results[:death][:date][:certainty][:certainty_value].must_equal ""
    results[:birth].must_be_nil
  end

  it "works with BCE years" do
    results = p.parse("John Doe [-1990 BCE]")

    results[:name][:string].must_equal "John Doe"
    results[:death][:date][:year].must_equal "1990"
    results[:death][:date][:era].must_equal "BCE"
    results[:birth].must_be_nil
    results[:death][:date][:certainty][:certainty_value].must_equal ""
  end

  it "works with CE years" do
    results = p.parse("John Doe [-1990 CE]")
    results[:name][:string].must_equal "John Doe"
    results[:death][:date][:year].must_equal "1990"
    results[:death][:date][:era].must_equal "CE"
    results[:death][:date][:certainty][:certainty_value].must_equal ""
    results[:birth].must_be_nil
  end
end