require_relative "test_helper.rb"

describe "Provenance Export" do
  
  before do
    @record_text = "Possibly purchased by David? [1950-2014?], Belgrade, by October 1990 until at least January 5, 2000, stock no. 1"
    @prov_text = "#{@record_text} [1]; another record.  1. I am a footnote."
    @timeline = Provenance.extract @prov_text
    @output = @timeline[0].generate_output
  end

  it "generates a PeriodOutput" do
    @output.must_be_instance_of PeriodOutput
  end

  it "generate provenance" do
    @output.provenance.must_equal @record_text
  end

  it "captures parsability" do
    @output.parsable.must_equal true
  end

  it "captures botb" do
    @output.botb.must_be_nil
  end
  it "captures botb precision" do
    @output.botb_precision.must_equal DateTimePrecision::NONE
  end
  it "captures botb certainty" do
    @output.botb_certainty.must_be_nil
  end

  it "captures eotb" do
    @output.eotb.must_equal Date.new(1990,10)
  end
  it "captures eotb precision" do
    @output.eotb_precision.must_equal DateTimePrecision::MONTH
  end
  it "captures eotb certainty" do
    @output.eotb_certainty.must_equal true
  end

  it "captures eote" do
    @output.eote.must_be_nil
  end
  it "captures eote precision" do
    @output.eote_precision.must_equal DateTimePrecision::NONE
  end
  it "captures eote certainty" do
    @output.eote_certainty.must_be_nil
  end

  it "captures bote" do
    @output.bote.must_equal Date.new(2000,1,5)
  end
  it "captures bote precision" do
    @output.bote_precision.must_equal DateTimePrecision::DAY
  end
  it "captures bote certainty" do
    @output.bote_certainty.must_equal true
  end

  it "captures certainty" do
    @output.period_certainty.must_equal false 
  end
  it "captures party" do
    @output.party.must_equal "David"
  end
  it "captures party certainty" do
    @output.party_certainty.must_equal false
  end
  it "captures location" do
    @output.location.must_equal "Belgrade"
  end
  it "captures location certainty" do
    @output.location_certainty.must_equal true
  end
  it "captures acquisition method" do
    @output.acquisition_method.must_equal "Purchase"
  end
  it "captures direct transfer" do
    @output.direct_transfer.must_equal true
  end
  it "captures footnotes" do
    @output.footnote.must_equal "I am a footnote."
  end
  it "captures original text" do
    @output.original_text.must_equal @record_text
  end
  it "captures birth date" do
    @output.birth.must_equal Date.new(1950)
  end
  it "captures birth certainty" do
    @output.birth_certainty.must_equal true
  end
  it "captures death date" do
    @output.death.must_equal Date.new(2014)
  end
  it "captures death certainty" do
    @output.death_certainty.must_equal false
  end
  it "captures stock number" do
    @output.stock_number.must_equal "stock no. 1"
  end

end