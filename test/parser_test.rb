require_relative "test_helper.rb"

describe Parser do

  let(:p) {Parser.new}
  let(:t) {"purchased in London, England by David Newbury?, Pittsburgh, PA for Graham Smith, Paris, France, in 1950."}

  it "doesn't crash" do
    p.parse(t).must_be_instance_of Array
  end

  it "doesn't crash with a to" do
    p.parse("bequest in New York, New York, to John Beck [1500-1580?], 1955.").must_be_instance_of Array
  end
  it "doesn't crash with on 'Purchased in London, England, 1850'" do
    p.parse("Purchased in London, England, 1850.").must_be_instance_of Array
  end

  it "doesn't crash with on 'Bewuest for Marvin Beck [1500-1580], 1955.'" do
    p.parse("Bequest for Marvin Beck [1500-1580], 1955.").must_be_instance_of Array
  end

  it "works on 'Possibly purchased, 1900;'"  do
    p.parse("Possibly purchased, 1900;").must_be_instance_of Array
  end

  it "works on 'John Smith, 2000.'" do
    p.parse("John Smith, 2000;").must_be_instance_of Array
  end

  it "handles the default tests" do
    input = "Purchased, 1900; 
         Purchased for John Beck, 1955.
         Purchased for John Beck?, 1955.
         purchased by John Beck, Berlin, Germany, 1945;
         purchased in London, England by David Newbury?, Pittsburgh, PA for Graham Smith, Paris, France, in 1950.
         "
    p.parse(input).must_be_instance_of Array
  end


end