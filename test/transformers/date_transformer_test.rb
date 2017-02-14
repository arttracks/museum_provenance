require_relative "../test_helper.rb"
describe Transformers::DateTransform do
  let(:t) {Transformers::DateTransform}
  let(:p) {Parsers::DateParser.new}

  it "regularizes" do
      results = p.parse("October 17th, 1990")
      obj = t.regularize(results[:date])

      obj[:month].must_equal 10
      obj[:day].must_equal 17
      obj[:year].must_equal 1990    
      obj[:era].must_equal "CE"  
  end
  it "regularizes BC dates" do
      results = p.parse("1990 BC")
      obj = t.regularize(results[:date])
      obj[:month].must_be_nil
      obj[:day].must_be_nil
      obj[:year].must_equal -1990  
      obj[:era].must_equal "BCE"
  end

  it "regularizes centuries" do
      results = p.parse("18th Century")
      obj = t.regularize(results[:date])
      obj[:month].must_be_nil
      obj[:day].must_be_nil
      obj[:year].must_be_nil
      obj[:century].must_equal 17
      obj[:era].must_equal "CE"
  end

  it "regularizes centuries BCE" do
    results = p.parse_with_debug("3rd century bce")
    obj = t.regularize(results[:date])
    obj[:month].must_be_nil
    obj[:day].must_be_nil
    obj[:year].must_be_nil
    obj[:century].must_equal -2
    obj[:era].must_equal "BCE"
  end
end