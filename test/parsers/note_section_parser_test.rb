require_relative "../test_helper.rb"
describe Parsers::NoteSectionParser do

  let(:p) {Parsers::NoteSectionParser.new}

  it "generically works" do
    begin
      results = p.parse("[b]. C.L. Sulzberger, A Long Row of Candles, Macmillan, 1969, p. 8.")
      puts "\nNOTE STRUCTURE:\n#{JSON.pretty_generate results}" if ENV["DEBUG"]
    rescue Parslet::ParseFailed => failure
      puts failure.cause.ascii_tree
      raise failure
    end
  end

  it "works with a single citation" do
    str = "[b]. Note Content."
    results = p.parse(str)
    results[:notes].first[:key].must_equal "b"
    results[:notes].first[:string].must_equal "Note Content."
  end

  it "works with a single footnote" do
    str = "[1]. Note Content."
    results = p.parse(str)
    results[:notes].first[:key].must_equal "1"
    results[:notes].first[:string].must_equal "Note Content."
  end

  it "works with a leading lines" do
    str = "\n\n[1]. Note Content."
    results = p.parse(str)
    results[:notes].first[:key].must_equal "1"
    results[:notes].first[:string].must_equal "Note Content."
  end

  it "works with a trailing lines" do
    str = "[1]. Note Content.\n\n"
    results = p.parse(str)
    results[:notes].first[:key].must_equal "1"
    results[:notes].first[:string].must_equal "Note Content."
  end

  it "works with a two footnotes" do
    str = "[1]. Note Content 1.\n[2]. Note Content 2."
    results = p.parse(str)
    results[:notes].first[:key].must_equal "1"
    results[:notes].first[:string].must_equal "Note Content 1."
    results[:notes].last[:key].must_equal "2"
    results[:notes].last[:string].must_equal "Note Content 2."
  end

  it "works with a two citations" do
    str = "[a]. Note Content 1.\n[b]. Note Content 2."
    results = p.parse(str)
    results[:notes].first[:key].must_equal "a"
    results[:notes].first[:string].must_equal "Note Content 1."
    results[:notes].last[:key].must_equal "b"
    results[:notes].last[:string].must_equal "Note Content 2."
  end

  it "works with extra lines between footnotes" do
    str = "[1]. Note Content 1.\n\n[2]. Note Content 2."
    results = p.parse(str)
    results[:notes].count.must_equal 2
    results[:notes].first[:key].must_equal "1"
    results[:notes].first[:string].must_equal "Note Content 1."
    results[:notes].last[:key].must_equal "2"
    results[:notes].last[:string].must_equal "Note Content 2."
  end

end