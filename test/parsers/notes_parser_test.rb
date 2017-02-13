require_relative "../test_helper.rb"
describe Parsers::NotesParser do

  let(:p) {Parsers::NotesParser.new}

  it "generically works" do
    begin
      results = p.parse("[1][a][b]")
      puts "\nNOTE STRUCTURE:\n#{JSON.pretty_generate results}" if ENV["DEBUG"]
    rescue Parslet::ParseFailed => failure
      puts failure.cause.ascii_tree
    end
  end

  it "works with just a citation" do
    results = p.parse("[a]")
    results[:citations].first[:value].must_equal "a"
  end 

  it "works with capitalized citations" do
    results = p.parse("[A]")
    results[:citations].first[:value].must_equal "A"
  end 

  it "works with multiletter citations" do
    results = p.parse("[AA]")
    results[:citations].first[:value].must_equal "AA"
  end 

  it "works with only a footnote" do
    results = p.parse("[1]")
    results[:footnote].must_equal "1"
  end 

  it "works with footnotes greater than 9" do
    results = p.parse("[100]")
    results[:footnote].must_equal "100"
  end 

  it "works with a footnote preceding a citation" do
    results = p.parse("[1][a]")
    results[:footnote].must_equal "1"
    results[:citations].first[:value].must_equal "a"
  end

  it "works with a citation preceding a footnote" do
    results = p.parse("[a][1]")
    results[:footnote].must_equal "1"
    results[:citations].first[:value].must_equal "a"
  end 

  it "works with N citations preceding a footnote" do
    results = p.parse("[a][b][1]")
    results[:footnote].must_equal "1"
    results[:citations].first[:value].must_equal "a"
    results[:citations].last[:value].must_equal "b"
  end

  it "works with a footnote preceding two citations" do
    results = p.parse("[1][a][b]")
    results[:footnote].must_equal "1"
    results[:citations].first[:value].must_equal "a"
    results[:citations].last[:value].must_equal "b"
  end  

  it "fails with more than one footnote" do
    proc{results = p.parse("[1][2]")}.must_raise Parslet::ParseFailed
  end  

  it "cannot handle citations on both sides of a footnote" do
    proc{results = p.parse("[a][1][b]")}.must_raise Parslet::ParseFailed
  end  

  it "cannot handle footnote 0" do
    proc{results = p.parse("[0]")}.must_raise Parslet::ParseFailed
  end  

  it "cannot handle footnotes with leading 0" do
    proc{results = p.parse("[01]")}.must_raise Parslet::ParseFailed
  end  


end