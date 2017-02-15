require_relative "../test_helper.rb"
describe Transformers::ParagraphTransform do

    let(:p) {Parsers::ParagraphParser.new}

    def parse_and_tranform(str)
      results = p.parse_with_debug(str, reporter: Parslet::ErrorReporter::Contextual.new)
      #puts JSON.pretty_generate results
      results = Transformers::ParagraphTransform.new.apply(results)
    end

    it "doesn't crash" do
      str = "David Newbury[a][b]."
      parse_and_tranform(str)
      results = p.parse_with_debug(str, reporter: Parslet::ErrorReporter::Contextual.new)
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

    it "regularizes dates" do
      results = parse_and_tranform("David Newbury, the 1990s?.")
      results[0][:timespan].wont_be_nil
    end

end