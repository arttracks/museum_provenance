require 'json'

describe "Provenance Files" do
  
  it "handles all existing files" do
    skip "Provenances need to be updated with the new acquisition methods"
    f = File.open( "#{File.dirname(__FILE__)}/sample_data/prov.txt", "r" )
    f.each_line.with_index do |line,i|
      next if i % 2 == 0 
      provenance = line
      prov = MuseumProvenance::Provenance.extract(provenance)
      prov.provenance.strip.must_equal provenance.strip
      prov.each do |line|
        line.parsable?.must_equal true        
      end
    end
  end
end