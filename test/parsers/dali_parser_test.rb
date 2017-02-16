require_relative "../test_helper.rb"
describe "The Dali Provenance" do
  let(:str) do
    <<~EOF
      Created by Salvador Dali [1904-1989], the artist, 1934. Purchased by Cyrus L. Sulzberger [1912-1993], Pittsburgh, PA, at "International Exhibition of Paintings", Carnegie Institute, in Pittsburgh, PA, November 5, 1934 (for $350) [1][a]; purchased by unnamed dealer, sometime in 1938? [b]; purchased by Thomas J. Watson [1874-1956] for IBM, sometime before May 1939 [2][c]; purchased by Cyrus L. Sulzberger, 1942 until at least 1969 [3][d]. Purchased by Nesuhi Ertegun and Selma Ertegun, New York, NY, sometime before June 1999 [e]; purchased by unknown private collection? [f]; purchased by Fundació Gala-Salvador Dalí, sometime before May 2011 (for $11M) [g].

      Notes:

      [1]: Cyrus L. Sulzberger, a 24-year-old Harvard graduate who had recently started work as a reporter at The Pittsburgh Press, first bought the painting from the exhibition for $350. A Carnegie Institute staffer informed Sulzberger that although multiple offers had been received for the picture, including one above the asking price, Dali had accepted his reduced offer ‘on the basis of immediate payment’ because ‘he will be on his way to this country very shortly and needs the money to defray part of his expenses.’  Sulzberger still evidently struggled to pay for the work, towards which he took out a loan repaid at the rate of $12.50 a week. ‘For many weeks I lived on half-salary,’ he recalled in his 1969 autobiography. ‘But, first in the YMCA where it rested on the foot of my bed, and then on the wall of my boardinghouse, I had the enormous pleasure of looking at one of Dali’s finest works.’ Sulzberger thought that the ‘enigmatic forms’ in the picture looked like ‘two large liver sausages’, and (further emphasizing its resemblance to meat), expressed his wish that Dali might ‘come to Pittsburgh as he might find some new lights under which to paint wife plus lambchop.’ When Sulzberger moved to Europe in 1938 to report on the war, he left the picture with a friend in Washington DC. In need of money later that year, he asked her to sell the work, and wire the money to him in Sofia, Bulgaria. 
      [2]: By 1939, the work had entered the corporate collection of the International Business Machines Corporation. IBM exhibited the picture at the New York World’s Fair exhibition Contemporary Art of Seventy-Nine Countries, serving to represent the art of Spain in this corporate demonstration of international interests.
      [3]: Upon Sulzberger's return to the United States in 1942, he traced the whereabouts of the picture to IBM president Thomas J. Watson, and asked if he could purchase the work back. ‘He wished to know why and I explained that I was temporarily destitute,’ Sulzberger recalls. Watson said that he too ‘had been forced to sell his first purchase,’ and in sympathy agreed to sell the painting back for the price he had paid, minus the dealer’s percentage. In 1969, when Sulzberger documented this history in his autobiography, the work was hanging in his Paris home. He estimated its value at this time to be $50,000.

      Authorities:

      Salvador Dali:                          http://vocab.getty.edu/ulan/500009365
      Cyrus L. Sulzberger:                    http://viaf.org/viaf/68936177
      Pittsburgh, PA:                         https://whosonfirst.mapzen.com/data/101/718/805/101718805.geojson
      International Exhibition of Paintings:  no record found.
      Carnegie Institute:                     http://vocab.getty.edu/ulan/500311352
      unnamed dealer:                         no record found.
      Thomas J. Watson:                       http://viaf.org/viaf/8189962
      IBM:                                    http://vocab.getty.edu/ulan/500217526
      Nesuhi Ertegun and Selma Ertegun:       http://viaf.org/viaf/46943188
      New York, NY:                           https://whosonfirst.mapzen.com/data/859/775/39/85977539.geojson
      unknown private collection:             no record found.
      Fundació Gala-Salvador Dalí:            http://viaf.org/viaf/155673422

      Citations:

      [a]: C.L. Sulzberger, Letter to John O’Connor, Carnegie Institute Museum of Art Records, 1883-1962, Box 231, Folder 10, Purchasers, 1934, p.77.
      [b]: C.L. Sulzberger, A Long Row of Candles, Macmillan, 1969, p. 8.
      [c]: Edward Alden Jewell, ‘Three Countries and Seventy-Nine’, New York Times, 28 May 1939, p. X7.
      [d]: C.L. Sulzberger, A Long Row of Candles, Macmillan, 1969, p. 8.
      [e]: Surrealism: Two private eyes, the Nesuhi Ertegun and Daniel Filipacchi collections, exhibition catalogue, June 4-September 12, Solomon R. Guggenheim Museum, 1999, p. 105.
      [f]: See http://www.salvador-dali.org/cataleg_raonat, cat. 376.
      [g]: See https://www.salvador-dali.org/serveis/premsa/news/198/the-most-expensive-painting-ever-purchased-by-the-foundation. Accessed January 19, 2017.
    EOF
  end

  before do 
    Transformers::AuthorityTransform.reset_counter
    @p = Parser.new(str)
  end
  
  it "creates four sections" do
    @p.authorities.wont_be_nil
    @p.citations.wont_be_nil
    @p.paragraph.wont_be_nil
    @p.notes.wont_be_nil
    # puts @p.to_json
  end


  describe "Notes and Citations" do
    it "processes notes" do
      # puts JSON.pretty_generate @p.notes
      @p.notes.first[:string].must_match "Cyrus L. Sulzberger, a 24-year-old Harvard graduate"
      @p.notes.first[:key].must_equal "1"
    end

    it "processes citations" do
      # puts JSON.pretty_generate @p.citations
      @p.citations.first[:string].must_match "C.L. Sulzberger, Letter to John O’Connor,"
      @p.citations.first[:key].must_equal "a"
    end

    it "inserts notes" do
       @p[1][:footnote].must_match "Cyrus L. Sulzberger, a 24-year-old Harvard graduate"
    end
    it "inserts citations" do
       @p[1][:citations].first.must_match "C.L. Sulzberger, Letter to John O’Connor,"
    end
  end

  describe "Authority Section" do
    it "processes authorities" do
      @p.authorities.first[:string].must_equal "Salvador Dali"
      @p.authorities.first[:token].must_include "$AUTHORITY_TOKEN_1"
      @p.authorities.first[:uri].must_equal "http://vocab.getty.edu/ulan/500009365"
    end

    it "sets authorities to nil if they're missing" do
      @p.authorities[10][:string].must_equal "unknown private collection"
      @p.authorities[10][:token].must_include "$AUTHORITY_TOKEN_11"
      @p.authorities[10][:uri].must_be_nil
    end

    it "replaces names with tokens" do
      @p.first[:owner][:name][:token].must_equal "$AUTHORITY_TOKEN_1"
    end

    it "appends names back to tokens as strings" do
      @p.first[:owner][:name][:string].must_equal "Salvador Dali"
    end
  end
  
end