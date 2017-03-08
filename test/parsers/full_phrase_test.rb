require_relative "../test_helper.rb"
describe "A full provenance period" do
  let(:str) do
    <<~EOF
      Possibly purchased by Bob Buyer? [1910-1980], Pittsburgh, PA for Owen Owner [1920-1990?], son of previous, Boise, ID, at "Sale of Sales", Gallery G, New York, NY?, in Miami, FL, sometime between Jan 5, 1982 and February 1982 until between 1999? and the 21st Century (lot no. 1, for $100,000)[a][1].
      
      Notes:

      [1]: Note a note.
      

      Authorities:

      Bob Buyer:       http://example.org/bob
      Owen Owner:      http://example.org/owen
      Pittsburgh, PA:  http://example.org/pgh
      Boise, ID:       http://example.org/boise
      Sale of Sales:   http://example.org/sale
      Gallery G:       http://example.org/gallery
      New York, NY:    http://example.org/nyc
      Miami, FL:       http://example.org/miami
      

      Citations:

      [a]: Book of Books

    EOF
  end

  before do 
    Transformers::AuthorityTransform.reset_counter
    @p = Parser.new(str)
  end

  it "creates a json" do
    # puts @p.to_json # for debugging purposes
    JSON.parse(@p.to_json)
  end

  describe "Period-level Content" do
    it "has text" do
      @p.first[:text].must_equal 'Possibly purchased by Bob Buyer? [1910-1980], Pittsburgh, PA for Owen Owner [1920-1990?], son of previous, Boise, ID, at "Sale of Sales", Gallery G, New York, NY?, in Miami, FL, sometime between Jan 5, 1982 and February 1982 until between 1999? and the 21st Century (lot no. 1, for $100,000)[a][1].'
    end
    it "is uncertain" do
      @p.first[:period_certainty].must_equal false
    end
    it "has a footnote" do
      @p.first[:footnote].must_equal "Note a note."
    end
    it "has a citation" do
      @p.first[:citations].first.must_equal "Book of Books"
    end
    it "is an indirect transfer" do
      @p.first[:direct_transfer].must_equal false
    end
    it "has a stock number" do
      @p.first[:stock_number].must_equal "lot no. 1"
    end
  end

  describe "Price" do
    it "has a symbol" do
      @p.first[:purchase][:currency_symbol].must_equal "$"
    end
    it "has a value" do
      @p.first[:purchase][:value].must_equal "100000"
    end
  end

  describe "Transfer Location" do
    it "has a location" do
      @p.first[:transfer_location][:place][:string].must_equal "Miami, FL"
      @p.first[:transfer_location][:place][:uri].must_equal "http://example.org/miami"
      @p.first[:transfer_location][:place][:certainty].must_equal true
    end
  end

  describe "Dates" do
    it "has a botb" do
      @p.first[:timespan][:botb].must_equal "1982-01-05"
      # @p.first[:timespan][:botb][:earliest].must_equal Date.new(1982,1,05)
      # @p.first[:timespan][:botb][:latest].must_equal  Date.new(1982,1,05)
      # @p.first[:timespan][:botb][:string].must_equal "January 5, 1982"
      # @p.first[:timespan][:botb][:certainty].must_equal true
    end
    it "has a eotb" do
      @p.first[:timespan][:eotb].must_equal "1982-02-uu"
      # @p.first[:timespan][:eotb][:earliest].must_equal  Date.new(1982,2,1)
      # @p.first[:timespan][:eotb][:latest].must_equal  Date.new(1982,2,28)
      # @p.first[:timespan][:eotb][:string].must_equal "February 1982"
      # @p.first[:timespan][:eotb][:certainty].must_equal true
    end
    it "has a bote" do
      @p.first[:timespan][:bote].must_equal "1999-uu-uu?"
      # @p.first[:timespan][:bote][:earliest].must_equal Date.new(1999,1,1)
      # @p.first[:timespan][:bote][:latest].must_equal Date.new(1999,12,31)
      # @p.first[:timespan][:bote][:string].must_equal "1999?"
      # @p.first[:timespan][:bote][:certainty].must_equal false
    end
    it "has a eote" do
      @p.first[:timespan][:eote].must_equal "20uu-uu-uu"
      # @p.first[:timespan][:eote][:earliest].must_equal Date.new(2000,1,1)
      # @p.first[:timespan][:eote][:latest].must_equal Date.new(2099,12,31)
      # @p.first[:timespan][:eote][:string].must_equal "the 21st century"
      # @p.first[:timespan][:eote][:certainty].must_equal true
    end
  end

  describe "Notes and Citations" do
    it "processes notes" do
      # puts JSON.pretty_generate @p.notes
      @p.notes.first[:string].must_equal "Note a note."
      @p.notes.first[:key].must_equal "1"
      @p.first[:footnote].must_match "Note a note."

    end

    it "processes citations" do
      # puts JSON.pretty_generate @p.citations
      @p.citations.first[:string].must_equal "Book of Books"
      @p.citations.first[:key].must_equal "a"
      @p.first[:citations].first.must_match "Book of Books"
    end
  end

  describe "People" do
    it "handles Sellers Agents" do
      @p.first[:sellers_agent][:name][:string].must_equal "Gallery G"
      @p.first[:sellers_agent][:name][:uri].must_equal "http://example.org/gallery"
      @p.first[:sellers_agent][:name][:certainty].must_equal true
      @p.first[:sellers_agent][:place][:string].must_equal "New York, NY"
      @p.first[:sellers_agent][:place][:uri].must_equal "http://example.org/nyc"
      @p.first[:sellers_agent][:place][:certainty].must_equal false
    end

    it "handles Purchasing Agents" do
      @p.first[:purchasing_agent][:name][:string].must_equal "Bob Buyer"
      @p.first[:purchasing_agent][:name][:uri].must_equal "http://example.org/bob"
      @p.first[:purchasing_agent][:name][:certainty].must_equal false
      @p.first[:purchasing_agent][:place][:string].must_equal "Pittsburgh, PA"
      @p.first[:purchasing_agent][:place][:uri].must_equal "http://example.org/pgh"
      @p.first[:purchasing_agent][:place][:certainty].must_equal true
      @p.first[:purchasing_agent][:birth].must_equal "1910-uu-uu"
      @p.first[:purchasing_agent][:death].must_equal "1980-uu-uu"
    end

    it "handles Owners" do
      @p.first[:owner][:name][:string].must_equal "Owen Owner"
      @p.first[:owner][:name][:uri].must_equal "http://example.org/owen"
      @p.first[:owner][:name][:certainty].must_equal true
      @p.first[:owner][:place][:string].must_equal "Boise, ID"
      @p.first[:owner][:place][:uri].must_equal "http://example.org/boise"
      @p.first[:owner][:place][:certainty].must_equal true
      @p.first[:owner][:birth].must_equal "1920-uu-uu"
      @p.first[:owner][:death].must_equal "1990-uu-uu?"
      @p.first[:owner][:clause].must_equal "son of previous"
    end

  end
end