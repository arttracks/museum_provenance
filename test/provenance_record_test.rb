require_relative "test_helper.rb"

describe "Provenance Records" do
  describe "Giverny Winter" do
    let (:prov_text) {"Gaston and Clarisse Baudy, Giverny, France;
                      by descent through the Baudy Family, until 1993; 
                      sold at auction, Laurin, Guilloux, Buffetaux, Paris, June 14, 1993, lot B2;
                      Jordan-Volpe Gallery, New York, NY;
                      John and Mary McGuigan, Texas;
                      Debra Force Fine Art, Inc., New York, NY; purchased by Museum, October 2000."}
    let(:prov) {Provenance.extract prov_text}
    

    it "was auctioned" do
      prov[2].acquisition_method.wont_be_nil
      prov[2].acquisition_method.must_equal AcquisitionMethod.find_by_id(:purchase_at_auction)
    end
  
    it "matches the original text to the generated text" do
      prov.each do |line|
        line.parsable?.must_equal true
      end
    end                  
  end


  describe  "Girl in Lavender, Seated at a Desk (original)" do
    let (:prov_text) {"Michel Monet, Giverny, France;
                       Janet Fleisher Gallery, Philadelphia, until 1967;
                        Dr. Albert Kaplan, (Philadelphia sale, Samuel T. Freeman and Company, Philadelphia, April 20, 1978);
                        Dr. And Mrs. John J. McDonough, Youngstown, Ohio, 1978;
                        Gift of Dr. And Mrs. John J. McDonough, 1982.
                      "}
    let(:prov) {Provenance.extract prov_text}
  
    it "test" do
#      puts prov.to_csv
    end
  
    it "has 5 records " do
      prov.count.must_equal 5
    end

    it "captures the date of 1967" do
      prov[1].ending.latest.must_equal Date.new(1967).latest
      prov[1].ending.same?.must_equal true
    end

    it "can parse record 4" do
      prov[4].original_text.must_equal prov[4].provenance
      prov[4].parsable?.must_equal true
    end

    it "it incepts" do
      Provenance.extract(prov.provenance).provenance.must_equal prov.provenance
    end
  end

  describe  "Girl in Lavender, Seated at a Desk (modified)" do
    let (:prov_text) {"Michel Monet, Giverny, France; Janet Fleisher Gallery, Philadelphia, until 1967; consigned to Samuel T. Freeman and Company, Philadelphia, April 20, 1978; Dr. And Mrs. John J. McDonough, Youngstown, Ohio, 1978; gift to the museum, 1982."}
    let(:prov) {Provenance.extract prov_text}
  
    it "regenerates itself" do   
      prov.provenance.must_equal prov_text
    end

    it "it incepts" do
      Provenance.extract(prov.provenance).provenance.must_equal prov.provenance
    end
  end

  describe "Wheat Fields after the Rain (original)" do
    let (:prov_text) {"?Mme. J. van Gogh-Bonger, Amsterdam; Possibly Mme. Maria Slavona, Paris; Possibly Paul Cassirer Art Gallery, Berlin;  Harry Graf von Kessler, Berlin and Weimar (by 1901, probably 1897 to at least 1929, likely Fall 1931); Reid and Lefevre Art Gallery, London, (referenced in 1939 and 1941); E. Bignou Art Gallery, New York, NY; Mr. and Mrs. Marshall Field, New York, NY (by 1939, referenced several times between 1939 and 1958); Galerie Beyeler, Basel, Switzerland; purchased by Museum, October 1968."
    }
    let(:prov) {Provenance.extract prov_text}

    it "has Mme. J. van Gogh-Bonger as the first name" do
      prov[0].party.to_s.must_equal "Mme. J. van Gogh-Bonger"
    end

    it "can parse about record 6" do
      prov[7].original_text.must_equal prov[7].provenance
      prov[7].parsable?.must_equal true
    end
    it "can't parse record 4" do
      prov[3].original_text.wont_equal prov[3].provenance
      prov[3].parsable?.must_equal false
    end

  end

  describe "Wheat Fields after the Rain (modified)" do
    let (:prov_text) {"Mme. J. van Gogh-Bonger?, Amsterdam; Possibly Mme. Maria Slavona, Paris; Possibly Paul Cassirer Art Gallery, Berlin; Harry Graf von Kessler, Berlin and Weimar, by 1901 until at least 1929 [1]; Reid and Lefevre Art Gallery, London, by 1939 until at least 1941; E. Bignou Art Gallery, New York, NY; Mr. and Mrs. Marshall Field, New York, NY, by 1939 until at least 1958 [2]; Galerie Beyeler, Basel, Switzerland; purchased by Museum, October 1968. NOTES: [1] probably 1897 to Fall 1931. [2] referenced several times between 1939 and 1958."
    }
    let(:prov) {Provenance.extract prov_text}


    it "has 9 records" do
      prov.count.must_equal 9
    end

    it "matches the original text to the generated text" do
      prov.each do |line|
        line.original_text.must_equal line.provenance
      end
    end

    it "is uncertain about the first name" do
      prov.first.party.certain?.must_equal false
    end

    it "properly outputs the first name" do
      prov[0].party.to_s.must_equal "Mme. J. van Gogh-Bonger?"
    end

    it "does not have dates for the first record" do
      prov[0].beginning.must_be_nil
      prov[0].ending.must_be_nil
    end

    it "knows the first location" do
      prov[0].location.to_s.must_equal "Amsterdam"
    end

    it "is certain about the first location" do
      prov[0].location.certain?.must_equal true
    end

    it "is certain about the second name" do
      prov[1].party.certain?.must_equal true
    end

    it "is uncertain about the second record" do
      prov[1].certainty.must_equal false
    end
    it "knows the second name" do
      prov[1].party.name.must_equal "Mme. Maria Slavona"
    end

    it "does not have dates for the second record" do
      prov[1].beginning.must_be_nil
      prov[1].ending.must_be_nil
    end

    it "knows the second location" do
      prov[1].location.must_equal Location.new "Paris"
    end

    #(by 1901, probably 1897 to at least 1929, likely Fall 1931)
    # by 1901 until at least 1929
    it "knows the earliest of the fourth record's acquisition" do
      prov[3].beginning.latest.must_equal Date.new(1901).latest
    end

    it "knows the latest of the fourth record's acquisition" do
      prov[3].ending.earliest.must_equal Date.new(1929).earliest
    end

    it "was purchased by the museum at a specific date" do
      prov.last.beginning.earliest.must_equal Date.new(1968,10)
    end

    it "regenerates itself" do   
      prov.provenance.must_equal prov_text
    end

    it "inception!!!!!!!" do
      Provenance.extract(prov.provenance).provenance.must_equal prov.provenance
    end
  end

  describe "Young Woman Picking Fruit" do
    let(:prov_text) {"Galeries Durand-Ruel, Paris [1]; Durand-Ruel Galleries, New York, NY, 1895; purchased by Museum, October 1922. NOTES: [1] recorded in stock books, August 1892."}
    let(:prov) {Provenance.extract prov_text}




    it "has three periods" do
      prov.count.must_equal 3
    end
    it "is a timeline" do
      prov.must_be_instance_of Timeline
    end

    it "matches the original text to the generated text" do
      prov.each do |line|
        line.original_text.must_equal line.provenance
      end
    end

    it "directly transfers between the first two records" do
      prov[0].direct_transfer.must_equal true
    end
    it "directly transfers between the second two records" do
      prov[1].direct_transfer.must_equal true
    end
    it "the last record is not direct" do
      prov.last.direct_transfer.must_be_nil
    end
    it "doesn't know about the first acquisition method" do
      prov.first.acquisition_method.must_be_nil
    end
    it "knows the last record is a purchase" do
      prov.last.acquisition_method.name.must_equal "Sale"
    end
    it "does not have a date for the first record" do
      prov.first.beginning.must_be_nil
      #prov.first.ending.earliest.must_equal Date.new(1895).earliest
    end
    it "has knows the date for the second record" do
      prov[1].beginning.earliest.must_equal Date.new(1895).earliest
      #prov[1].ending.latest.must_equal Date.new(1922,10).latest
    end
    it "does not have an end date for the last record" do
      prov.last.beginning.earliest.must_equal Date.new(1922,10).earliest
      prov.last.ending.must_be_nil
    end
    
    it "knows who the first record is " do
      prov[0].party.must_equal Party.new "Galeries Durand-Ruel"
    end
    it "knows where the first record is" do
      prov[0].location.must_equal Location.new "Paris"
    end
    
    it "knows that the middle record is " do
      prov[1].party.must_equal Party.new "Durand-Ruel Galleries"
    end
    it "knows where the second record is" do
      prov[1].location.must_equal Location.new "New York, NY"
    end
    it "knows the museum is the last record" do
      prov.last.party.must_equal Party.new "Museum"
    end
    it "knows doesn't know where the second record is" do
      prov[2].location.must_be_nil
    end
    it "has a footnote for the first record" do
      prov.first.note.must_include "recorded in stock books, August 1892."
    end
    it "regenerates itself" do
      prov.provenance.must_equal prov_text
    end
    it "inception!!!!!!!" do
      Provenance.extract(prov.provenance).provenance.must_equal prov_text
    end
  end
end