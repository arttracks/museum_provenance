require_relative "test_helper.rb"

describe PeriodOutput do
  let (:prov_text) {"Possibly purchased by David? [1950-2014?], Belgrade, by October 1990 until at least January 5, 2000, stock no. 1"}
  let (:prov) {Provenance.extract prov_text}
  let (:output) {prov[0].generate_output}
  let (:sample_data) { {:period_certainty=>false, 
                  :acquisition_method=>"Sale", 
                  :party=>"David",
                  :party_certainty=>false, 
                  :birth=>Date.new(1950),
                  :birth_certainty=>true, 
                  :death=>Date.new(2014).latest,
                  :death_certainty=>false, 
                  :location=>"Belgrade", 
                  :location_certainty=>true, 
                  :botb=>nil, 
                  :botb_certainty=>nil, 
                  :botb_precision=>0, 
                  :eotb=>Date.new(1990,10), 
                  :eotb_certainty=>true, 
                  :eotb_precision=>2, 
                  :bote=>Date.new(2000,1,5), 
                  :bote_certainty=>true, 
                  :bote_precision=>3, 
                  :eote=>nil, 
                  :eote_certainty=>nil, 
                  :eote_precision=>0, 
                  :original_text=> prov_text, 
                  :provenance=> prov_text, 
                  :parsable=>true, 
                  :direct_transfer=>nil, 
                  :stock_number=>"stock no. 1", 
                  :footnote=>"",
                  :primary_owner=>true,
                  :earliest_possible=>nil,
                  :earliest_definite=>nil,
                  :latest_definite=>nil,
                  :latest_possible=>nil
                } 
              }

  describe "as a class" do
    it "lists members" do
      PeriodOutput.members.must_be_instance_of Array
      PeriodOutput.members.must_equal sample_data.collect{|key,val| key}
    end
  end

  it "exists" do
    output.must_be_instance_of PeriodOutput

  end

  it "converts to an array" do
    output.to_a.must_be_instance_of Array
    output.to_a.must_equal sample_data.collect{|key,val| val}
  end

  it "converts to a hash" do
    output.to_h.must_be_instance_of Hash
    output.to_h.must_equal sample_data
  end
end