require_relative "test_helper.rb"

describe Provenance do
  
  it "extracts text into an Timeline" do
    Provenance.extract("sample text").must_be_kind_of Timeline
  end

  it "handles crlfs" do
    text = "sample text
    second line"
    p = Provenance.extract(text)
    p.must_be_kind_of Timeline
    p.count.must_equal 1
  end

  describe "stock numbers" do
    it "finds stock numbers" do
      timeline = Provenance.extract("Sold to David Newbury, stock no. 55512")
      timeline[0].to_h[:stock_number].must_equal "stock no. 55512"
    end

    it "finds numbers" do
      timeline = Provenance.extract("Sold to David Newbury no. 55512")
      timeline[0].to_h[:stock_number].must_equal "no. 55512"
    end
  end

  describe "acq. method extraction" do

    it "does not remove anything if it's not a method" do
      timeline = Provenance.extract "David Newbury, 1995"
      timeline[0].acquisition_method.must_be_nil
    end

    it "removes standard prefixes" do
      timeline = Provenance.extract "Sold to David Newbury"
      timeline[0].acquisition_method.must_be_instance_of AcquisitionMethod
      timeline[0].acquisition_method.must_equal AcquisitionMethod::SALE

      timeline[0].to_h[:party].must_equal "David Newbury"

    end

    it "removes standard suffixes" do
      timeline = Provenance.extract "David Newbury, by exchange"
      timeline[0].acquisition_method.must_be_instance_of AcquisitionMethod
      timeline[0].acquisition_method.must_equal AcquisitionMethod::EXCHANGE
      timeline[0].to_h[:party].must_equal "David Newbury"
    end

    it "doesn't bork on donation" do
      timeline = Provenance.extract "Donated to David Newbury"
      timeline[0].acquisition_method.must_equal AcquisitionMethod::GIFT
      timeline[0].parsable?.must_equal true
    end

    it "doesn't bork on sold at auction" do
      timeline = Provenance.extract "sold at auction to David Newbury"
      timeline[0].acquisition_method.must_equal AcquisitionMethod::FOR_SALE
      timeline[0].parsable?.must_equal true
    end

    it "doesn't bork on sold at" do
      timeline = Provenance.extract "sold at David Newbury"
      timeline[0].acquisition_method.must_equal AcquisitionMethod::FOR_SALE
      timeline[0].parsable?.must_equal true
    end

    it "doesn't bork on by descent" do
      timeline = Provenance.extract "David Newbury, by descent"
      timeline[0].acquisition_method.must_equal AcquisitionMethod::BY_DESCENT
      timeline[0].parsable?.must_equal true
    end

    it "doesn't bork on by descent prefixed" do
      timeline = Provenance.extract "by descent to David Newbury"
      timeline[0].acquisition_method.must_equal AcquisitionMethod::BY_DESCENT
      timeline[0].parsable?.must_equal true
    end

  end

  describe "Record Certainty" do
    it "works with probably" do
      timeline = Provenance.extract  "Probably maybe."
      timeline[0].certain?.must_equal false
    end
    it "doesn't change text" do
      timeline = Provenance.extract  "I am certain."
      timeline[0].certain?.must_equal true
    end
  end


  describe "Extraction" do
    let (:no_note) {"I do not have a note"}
    let (:note) {"I have a footnote [1]. 1. I am the note."}
    let (:other_note) {"I have a footnote [1]. NOTES: 1. I am the note."}
 
    it "does not find notes if they don't exist" do
      timeline = Provenance.extract (no_note)
      timeline[0].to_h[:provenance].must_equal no_note
      timeline[0].to_h[:footnote].must_be_empty
    end

    it "will find notes with periods" do
      timeline = Provenance.extract (note)
      timeline[0].to_h[:provenance].must_equal 'I have a footnote'
      timeline[0].to_h[:footnote].must_include 'I am the note.'
    end
    
    it "will find notes in note blocks" do
      timeline = Provenance.extract (other_note)
      timeline[0].to_h[:provenance].must_equal 'I have a footnote'
      timeline[0].to_h[:footnote].must_include 'I am the note.'
    end
  end

  describe "Period Substitution" do
    it "does not substitute periods for records" do
      timeline = Provenance.extract "I am a sentence.  I am another sentence."
      timeline.count.must_equal 2
    end

    it "does not assume that abbreviations are sentences" do
      timeline = Provenance.extract "Mr. David was here.  I am another sentence."
      timeline.count.must_equal 2
    end

    it "handles Initials" do
      timeline = Provenance.extract("Mr. David N. was here.  I am another sentence.")
      timeline.count.must_equal 2
    end

    it "handles initial Initials" do
      timeline = Provenance.extract("G. David was here.  I am another sentence.")
      timeline.count.must_equal 2
    end
  end

  describe "Birth and Death Extraction" do
    it "doesn't find dates where there aren't any" do
      timeline = Provenance.extract("David, Pittsburgh, PA")
      timeline[0].to_h[:birth].must_be_nil
      timeline[0].to_h[:death].must_be_nil
      timeline[0].to_h[:party].must_equal "David"
      timeline[0].to_h[:location].must_equal "Pittsburgh, PA"  
    end

    it "finds dates" do
      timeline = Provenance.extract("David [1880-1980], Pittsburgh, PA")
      timeline[0].to_h[:birth].must_equal Date.new 1880
      timeline[0].to_h[:birth_certainty].must_equal true
      timeline[0].to_h[:death].must_equal  Date.new(1980).latest
      timeline[0].to_h[:death_certainty].must_equal true
      timeline[0].to_h[:party].must_equal "David"
      timeline[0].to_h[:location].must_equal "Pittsburgh, PA"  
    end
    it "finds death dates" do
      timeline = Provenance.extract("David (d. 1980), Pittsburgh, PA")
      timeline[0].to_h[:death].must_equal  Date.new(1980).latest
      timeline[0].to_h[:death_certainty].must_equal true
      timeline[0].to_h[:birth].must_be_nil
      timeline[0].to_h[:party].must_equal "David"
      timeline[0].to_h[:location].must_equal "Pittsburgh, PA" 
      timeline.count.must_equal 1
    end
    it "finds uncertain death dates" do
      timeline = Provenance.extract("David (d. 1980?), Pittsburgh, PA")
      timeline[0].to_h[:death].must_equal  Date.new(1980).latest
      timeline[0].to_h[:death_certainty].must_equal false
    end
    it "finds birth dates" do
      timeline = Provenance.extract("David (b. 1980), Pittsburgh, PA")
      timeline[0].to_h[:birth].must_equal  Date.new 1980
      timeline[0].to_h[:birth_certainty].must_equal true
      timeline[0].to_h[:death].must_be_nil
      timeline[0].to_h[:party].must_equal "David"
      timeline[0].to_h[:location].must_equal "Pittsburgh, PA" 
      timeline.count.must_equal 1
    end
    it "finds births with people who haven't died" do
      timeline = Provenance.extract("David (1980-), Pittsburgh, PA")
      timeline[0].to_h[:birth].must_equal  Date.new 1980
      timeline[0].to_h[:birth_certainty].must_equal true
      timeline[0].to_h[:death].must_be_nil
      timeline[0].to_h[:party].must_equal "David"
      timeline[0].to_h[:location].must_equal "Pittsburgh, PA"  
    end
    it "finds deaths with people who don't have birthdates" do
      timeline = Provenance.extract("David (-1980), Pittsburgh, PA")
      timeline[0].to_h[:birth].must_be_nil
      timeline[0].to_h[:death].must_equal Date.new(1980).latest
      timeline[0].to_h[:death_certainty].must_equal true
      timeline[0].to_h[:party].must_equal "David"
      timeline[0].to_h[:location].must_equal "Pittsburgh, PA"  
    end

    it "handles questionable birth dates" do
      timeline = Provenance.extract("David [1880?-1980?], Pittsburgh, PA")
      timeline[0].to_h[:birth].must_equal Date.new 1880
      timeline[0].to_h[:birth_certainty].must_equal false
      timeline[0].to_h[:death].must_equal Date.new(1980).latest
      timeline[0].to_h[:death_certainty].must_equal false
      timeline[0].to_h[:party].must_equal "David"
      timeline[0].to_h[:location].must_equal "Pittsburgh, PA"  
    end
  end

  describe "Name and location" do
    it "splits name and location" do
      timeline = Provenance.extract("David, Pittsburgh")
      timeline[0].to_h[:party].must_equal "David"
      timeline[0].to_h[:location].must_equal "Pittsburgh"
    end
    it "assigns multiple commas to location" do
      timeline = Provenance.extract("David, Pittsburgh, PA")
      timeline[0].to_h[:party].must_equal "David"
      timeline[0].to_h[:location].must_equal "Pittsburgh, PA"
    end
    it "handles no location" do
      timeline = Provenance.extract("David Newbury")
      timeline[0].to_h[:party].must_equal "David Newbury"
      timeline[0].to_h[:location].must_be_nil
    end
    it "handles Jrs" do
      timeline = Provenance.extract("David, Jr., Pittsburgh")
      timeline[0].to_h[:party].must_equal "David, Jr."
      timeline[0].to_h[:location].must_equal "Pittsburgh"
    end  
    it "handles Countesses" do
      timeline = Provenance.extract("David, Countess of Northbrook, Pittsburgh")
      timeline[0].to_h[:party].must_equal "David, Countess of Northbrook"
      timeline[0].to_h[:location].must_equal "Pittsburgh"
    end 
    it "handles Srs" do
      timeline = Provenance.extract("David, Sr., Pittsburgh")
      timeline[0].to_h[:party].must_equal "David, Sr."
      timeline[0].to_h[:location].must_equal "Pittsburgh"
    end
    it "handles Sgt." do
      timeline = Provenance.extract("Sgt. David, Pittsburgh")
      timeline[0].to_h[:party].must_equal "Sgt. David"
      timeline[0].to_h[:location].must_equal "Pittsburgh"
    end   
    it "handles Col." do
      timeline = Provenance.extract("Col. David Newbury, Pittsburgh")
      timeline[0].to_h[:party].must_equal "Col. David Newbury"
      timeline[0].to_h[:location].must_equal "Pittsburgh"
    end      
  end
 
  describe "Line Splitting" do
    it "splits sentences" do
      Provenance.extract("I am a sentence.  I am another sentence.").count.must_equal 2
    end
    it "splits sentences with semicolons" do
      Provenance.extract("I am a sentence; I am another sentence.").count.must_equal 2
    end
    it "splits sentences with abbrev." do
      Provenance.extract("Dr. Mario says I am a sentence. I am another sentence.").count.must_equal 2
    end
  end

end