require_relative "../test_helper.rb"
describe Parsers::DateStringParser do

  let(:p) {Parsers::DateStringParser.new}

  it "generically works" do
    begin
      results = p.parse("sometime between January 1, 1994 and October 1995 until between 1996 and the 21st Century")
      puts "\nDATE String STRUCTURE:\n#{JSON.pretty_generate results}" if ENV["DEBUG"]
    rescue Parslet::ParseFailed => failure
      puts failure.cause.ascii_tree
    end
  end

  it "works with just a year" do
    results = p.parse("1990")
    results[:begin][:date][:year].must_equal "1990"
  end 
  
  it "works with two years" do
    results = p.parse("1990 until 1999")
    results[:begin][:date][:year].must_equal "1990"
    results[:end][:date][:year].must_equal "1999"
  end 



end