require_relative "../test_helper.rb"
describe Parsers::AuthorityParser do

  let(:p) {Parsers::AuthorityParser.new}

  it "generically works" do
    begin
      str = <<~EOF
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
      EOF

      results = p.parse(str)
      puts "\mAUTHORITY STRUCTURE:\n#{JSON.pretty_generate results}" if ENV["DEBUG"]
    rescue Parslet::ParseFailed => failure
      puts failure.cause.ascii_tree
    end
  end

  it "works with leading newlines" do
    results = p.parse("\n\nJohn Doe: uri")
    results[:authorities].first[:string].must_equal "John Doe"
    results[:authorities].first[:uri].must_equal "uri"
  end 

  it "works with trailing newlines" do
    results = p.parse("John Doe: uri\n\n")
    results[:authorities].first[:string].must_equal "John Doe"
    results[:authorities].first[:uri].must_equal "uri"
  end 
end