require_relative "../test_helper.rb"
describe "Full Text Parser" do



  let(:p) {Parsers::BaseParser.new}
  let(:text) {
    <<~EOF
      Possibly purchased at auction by John Doe? [1910?-1995?], Boise, ID, for Sally Moe, Baroness of Leeds [1940-], Pittsburgh, PA?, at "Sale of Pleasant Goods", Christie's, in London, England, sometime after November 5, 1975 (stock no. 10, for $1000) [1][a][b].

      Notes:

      [1].  Purchased on the occasion of her birthday.

      Authorities:

      John Doe:                      see http://vocabs.getty.com/authorities/123455
      Boise, ID:                     see http://geonames.com/123456
      Sally Moe, Baroness of Leeds:  see http://viaf.org/123456
      Pittsburgh, PA:                see http://tgn.getty.org/123456
      London, England:               see http://geonames.com/555121
      Christie's:                    no record found.

      Citations:

      [a].  http://www.worldcat.org/oclc/873114
      [b].  See curatorial file, Carnegie Museum of Art.
    EOF
  }

  it "generically works" do
    skip
    
    begin
      results = p.parse(text)
      puts results
    rescue Parslet::ParseFailed => failure
      puts failure.cause.ascii_tree
    end
  end
end