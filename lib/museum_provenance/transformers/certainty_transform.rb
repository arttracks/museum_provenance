
module MuseumProvenance
  module Transformers
    class CertaintyTransform < Parslet::Transform
      rule(:certainty_value => simple(:x)) { x != "?"}
      rule(:period_certainty_value => simple(:x)) { x.length == 0}
    end
  end
end