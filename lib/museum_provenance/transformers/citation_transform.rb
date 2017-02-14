
module MuseumProvenance
  module Transformers
    class CitationTransform < Parslet::Transform
        rule(:citation_value => simple(:x)) {x}
    end
  end
end