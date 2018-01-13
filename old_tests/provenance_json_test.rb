require_relative "test_helper.rb"

describe "Provenance Records from JSON" do
  
  it "incepts" do
    @record_text = "Possibly purchased by David? [1950-2014?], Belgrade, by October 1990 until at least January 5, 2000, stock no. 1"
    @prov_text = "#{@record_text} [1]; another record.  1. I am a footnote."
    @timeline = Provenance.extract @prov_text
    @json = @timeline.to_json
    @computed_timeline = Provenance.from_json(@json)
    @computed_timeline.provenance.must_equal @timeline.provenance
  end
  it "handles the sample records" do
    f = File.open( "#{File.dirname(__FILE__)}/sample_data/prov.txt", "r" )
    f.each_line.with_index do |line,i|
      next if i % 2 == 0 
      provenance = line
      prov = MuseumProvenance::Provenance.extract(provenance)
      # puts ""
      # puts prov.to_json
      # puts ""
      reprov =  Provenance.from_json(prov.to_json)
      prov.provenance.must_equal reprov.provenance
    end
  end
end