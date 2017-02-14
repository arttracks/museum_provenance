
module MuseumProvenance
  module Transformers
    class TransferModeTransform < Parslet::Transform
        rule(:transfer_punctuation => simple(:x)) { x == ";"}
    end
  end
end