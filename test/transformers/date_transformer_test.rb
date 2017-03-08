require_relative "../test_helper.rb"
describe Transformers::DateTransform do
  let(:t) {Transformers::DateTransform}
  let(:p) {Parsers::DateParser.new}


  def parse_and_tranform(str)
      results = p.parse_with_debug(str, reporter: Parslet::ErrorReporter::Contextual.new)
      results = t.new.apply(results)
    end

  describe "EDTF conversion" do
    it "creates EDTF for day precision" do
      results = parse_and_tranform("October 17th, 1990")
      results[:edtf].must_equal "1990-10-17"
    end
    it "creates EDTF for day precision with uncertainty" do
      results = parse_and_tranform("October 17th, 1990?")
      results[:edtf].must_equal "1990-10-17?"
    end

    it "creates EDTF for month precision" do
      results = parse_and_tranform("October 1990")
      results[:edtf].must_equal "1990-10-uu"
    end
    it "creates EDTF for month precision with uncertainty" do
      results = parse_and_tranform("October 1990?")
      results[:edtf].must_equal "1990-10-uu?"
    end

    it "creates EDTF for year precision" do
      results = parse_and_tranform("1990")
      results[:edtf].must_equal "1990-uu-uu"
    end

    it "creates EDTF for year precision BCE" do
      results = parse_and_tranform("1990 BCE")
      results[:edtf].must_equal "-1990-uu-uu"
    end
    it "creates EDTF for year precision BCE with uncertainty" do
      results = parse_and_tranform("1990 BCE?")
      results[:edtf].must_equal "-1990-uu-uu?"
    end

    it "creates EDTF for year precision with uncertainty" do
      results = parse_and_tranform("1990?")
      results[:edtf].must_equal "1990-uu-uu?"
    end

    it "creates EDTF for centuries" do
      results = parse_and_tranform("the 21st Century")
      results[:edtf].must_equal "20uu-uu-uu"
    end

    it "creates EDTF for centuries BCE" do
      results = parse_and_tranform("the 3rd century BCE")
      results[:edtf].must_equal "-03uu-uu-uu"
    end

    it "creates EDTF for uncertain centuries" do
      results = parse_and_tranform("the 21st Century?")
      results[:edtf].must_equal "20uu-uu-uu?"
    end
    it "creates EDTF for decades" do
      results = parse_and_tranform("the 1990s")
      results[:edtf].must_equal "199u-uu-uu"
    end

    it "creates EDTF for uncertain decades" do
      results = parse_and_tranform("the 1990s?")
      results[:edtf].must_equal "199u-uu-uu?"
    end
  end

  describe "Regularization of fields" do
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
end