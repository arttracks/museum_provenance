require_relative "../test_helper.rb"
describe Parsers::DateParser do

  let(:p) {Parsers::DateParser.new}

  it "generically works" do
    begin
      results = p.parse("1990")
      puts "\nDATE STRUCTURE:\n#{JSON.pretty_generate results}" if ENV["DEBUG"]
    rescue Parslet::ParseFailed => failure
      puts failure.cause.ascii_tree
    end
  end

  it "works with centuries" do
    results = p.parse("the 19th Century")
    results[:date][:century].must_equal "19"
    results[:date][:era].must_equal ""
  end

  it "works with decades" do
    results = p.parse("the 1990s")
    results[:date][:decade].must_equal "1990"
    results[:date][:era].must_equal ""
  end

  it "works with years" do
    results = p.parse("1990")
    results[:date][:year].must_equal "1990"
    results[:date][:era].must_equal ""
  end 

  it "works with months" do
    results = p.parse("October, 1990")
    results[:date][:year].must_equal "1990"
    results[:date][:month].must_equal "October"
    results[:date][:era].must_equal ""
  end

  it "works with days" do
    results = p.parse("October 17, 1990")
    results[:date][:year].must_equal "1990"
    results[:date][:month].must_equal "October"
    results[:date][:day].must_equal "17"
    results[:date][:era].must_equal ""
  end

  it "works with days with suffixes" do
    results = p.parse("October 17th, 1990")
    results[:date][:year].must_equal "1990"
    results[:date][:month].must_equal "October"
    results[:date][:day].must_equal "17"
    results[:date][:era].must_equal ""
  end

  it "works with days without commas" do
    results = p.parse("October 17 1990")
    results[:date][:year].must_equal "1990"
    results[:date][:month].must_equal "October"
    results[:date][:day].must_equal "17"
    results[:date][:era].must_equal ""
  end

  it "works with euro-dates" do
    results = p.parse("17 October 1990")
    results[:date][:year].must_equal "1990"
    results[:date][:month].must_equal "October"
    results[:date][:day].must_equal "17"
    results[:date][:era].must_equal ""
  end

  it "works with stupid dates"  do
    results = p.parse("10/17/1990")
    results[:date][:year].must_equal "1990"
    results[:date][:month].must_equal "10"
    results[:date][:day].must_equal "17"
    results[:date][:era].must_equal ""
  end

  it "works with ISO dates"  do
    results = p.parse("1990-10-17")
    results[:date][:year].must_equal "1990"
    results[:date][:month].must_equal "10"
    results[:date][:day].must_equal "17"
    results[:date][:era].must_equal ""
  end

  it "works with ISO UTC dates"  do
    results = p.parse("1990-10-17Z")
    results[:date][:year].must_equal "1990"
    results[:date][:month].must_equal "10"
    results[:date][:day].must_equal "17"
    results[:date][:timezone].must_equal "Z"
    results[:date][:era].must_equal ""
  end

  it "works with ISO dates with negative timezone"  do
    results = p.parse("1990-10-17-03:00")
    results[:date][:year].must_equal "1990"
    results[:date][:month].must_equal "10"
    results[:date][:day].must_equal "17"
    results[:date][:timezone].must_equal "-03:00"
    results[:date][:era].must_equal ""
  end


  it "works with ISO dates with positive timezone"  do
    results = p.parse("1990-10-17+03:45")
    results[:date][:year].must_equal "1990"
    results[:date][:month].must_equal "10"
    results[:date][:day].must_equal "17"
    results[:date][:timezone].must_equal "+03:45"
    results[:date][:era].must_equal ""
  end

  it "works with years BCE" do
    results = p.parse("1990 BCE")
    results[:date][:year].must_equal "1990"
    results[:date][:era].must_equal "BCE"
  end 

  it "works with years ad" do
    results = p.parse("1990 ad")
    results[:date][:year].must_equal "1990"
    results[:date][:era].must_equal "ad"
  end 
  



end