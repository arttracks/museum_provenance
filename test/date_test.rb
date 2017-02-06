require_relative "test_helper.rb"

include MuseumProvenance

describe "Date has been modified and " do
  let(:y) {Date.new(2014)}
  let(:m) {Date.new(2014,10)}
  let(:d) {Date.new(2014,10,17)}

  it "measures precision properly" do
    y.precision.must_equal DateTimePrecision::YEAR
    m.precision.must_equal DateTimePrecision::MONTH
    d.precision.must_equal DateTimePrecision::DAY
  end

  it "calculates earliest date" do
    y.earliest.must_equal Date.new(2014,1,1)
    y.earliest.precision.must_equal DateTimePrecision::DAY
    m.earliest.must_equal Date.new(2014,10,1)
    m.earliest.precision.must_equal DateTimePrecision::DAY
    d.earliest.must_equal Date.new(2014,10,17)
    d.earliest.precision.must_equal DateTimePrecision::DAY
  end

  it "calculates latest date" do
    y.latest.must_equal Date.new(2014,12,31)
    y.latest.precision.must_equal DateTimePrecision::DAY
    m.latest.must_equal Date.new(2014,10,31)
    m.latest.precision.must_equal DateTimePrecision::DAY
    d.latest.must_equal Date.new(2014,10,17)
    d.latest.precision.must_equal DateTimePrecision::DAY
  end

  describe "certainty" do
    before do
      m.certain = false
    end
    it "defaults certainty to true" do
      y.certain?.must_equal true
    end

    it "allows certainty to be set" do
      m.certain?.must_equal false
    end

    it "certainty is set for earliest and latest" do
      m.earliest.certain?.must_equal false
      m.latest.certain?.must_equal false
    end

    it "modifies date to_s if they're uncertain" do
      orig_string = y.to_s 
      y.certainty = false
      y.to_s.must_equal "#{orig_string}?"
    end

    it "generates appropriate certainty strings" do
      y.certain_string.must_equal ""
      m.certain_string.must_equal "?"
    end
  end
end