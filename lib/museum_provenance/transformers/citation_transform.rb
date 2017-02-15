
module MuseumProvenance
  module Transformers
    class CitationTransform < Parslet::Transform
        rule(:citation_value => simple(:x)) {x.to_s}
    end
  end
end