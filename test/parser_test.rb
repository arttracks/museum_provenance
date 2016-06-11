require_relative "test_helper.rb"

describe Parser do
  let(:p) {Parser.new}
  let(:t) {"purchased in London, England by David Newbury?, Pittsburgh, PA for Graham Smith, Paris, France, in 1950."}

  it "doesn't crash" do
    expect{p.parse(t)}.not_to raise_error
  end
  it "doesn't crash with a to" do
    expect{p.parse("bequest in New York, New York, to John Beck [1500-1580?], 1955.")}.not_to raise_error
  end
  it "doesn't crash with on 'Purchased in London, England, 1850'" do
    expect{p.parse("Purchased in London, England, 1850.")}.not_to raise_error
  end

  it "doesn't crash with on 'Bewuest for Marvin Beck [1500-1580], 1955.'" do
    expect{p.parse("Bequest for Marvin Beck [1500-1580], 1955.")}.not_to raise_error
  end

  it "works on 'Possibly purchased, 1900;'"  do
    expect{p.parse("Possibly purchased, 1900;")}.not_to raise_error
  end

  it "works on 'John Smith, 2000.'" do
    expect{p.parse("John Smith, 2000;")}.not_to raise_error
  end

  it "handles the default tests" do
    input = "Purchased, 1900; 
         Purchased for John Beck, 1955.
         Purchased for John Beck?, 1955.
         purchased by John Beck, Berlin, Germany, 1945;
         purchased in London, England by David Newbury?, Pittsburgh, PA for Graham Smith, Paris, France, in 1950.
         "
    expect{p.parse(input)}.not_to raise_error
  end


end