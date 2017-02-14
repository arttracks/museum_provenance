require_relative "../test_helper.rb"
describe Transformers::BaseTransform do

    let(:p) {Parsers::BaseParser.new}

    def parse_and_tranform(str)
      results = p.parse_with_debug(str, reporter: Parslet::ErrorReporter::Contextual.new)
      #puts JSON.pretty_generate results
      results = Transformers::BaseTransform.transform(results)
    end

    it "doesn't crash" do
      str = "David Newbury[a][b]."
      results = p.parse_with_debug(str, reporter: Parslet::ErrorReporter::Contextual.new)
      puts JSON.pretty_generate results if ENV["DEBUG"]
      results = Transformers::BaseTransform.transform(results)
      puts "-----\n"if ENV["DEBUG"]
      puts JSON.pretty_generate results if ENV["DEBUG"]

    end

    it "fixes transfer punctuation" do
      results = parse_and_tranform("David Newbury.")
      results[0][:direct_transfer].must_equal false

      results = parse_and_tranform("David Newbury;")
      results[0][:direct_transfer].must_equal true
    end

    it "fixes period certainty" do
      results = parse_and_tranform("Possibly David Newbury.")
      results[0][:period_certainty].must_equal false

      results = parse_and_tranform("David Newbury.")
      results[0][:period_certainty].must_equal true
    end

    it "fixes entity certainty" do
      results = parse_and_tranform("David Newbury.")
      results[0][:owner][:name][:certainty].must_equal true

      results = parse_and_tranform("David Newbury?.")
      results[0][:owner][:name][:certainty].must_equal false
    end

    it "fixes citation notes" do
      results = parse_and_tranform("David Newbury[a].")
      results[0][:citations].must_equal ["a"]

      results = parse_and_tranform("David Newbury[a][b].")
      results[0][:citations].must_equal ["a","b"]

      results = parse_and_tranform("David Newbury.")
      results[0][:citations].must_be_nil
    end

    it "regularizes dates" do
      results = parse_and_tranform("David Newbury, the 1990s?.")
      results[0][:timespan].wont_be_nil
    end

end