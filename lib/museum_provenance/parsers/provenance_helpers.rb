module MuseumProvenance
  module Parsers
    module ProvenanceHelpers 
      include Parslet

      rule (:ownership_start)      { str("for") >> space }
      rule (:event_location_start) { str("in")  >> space }
    end
  end
end
