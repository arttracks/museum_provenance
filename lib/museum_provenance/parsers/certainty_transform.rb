
module MuseumProvenance
  module Parsers
    class CertaintyTransform < Parslet::Transform
      rule(:certainty => simple(:x)) { x != "?"}
      rule(:period_certainty_value => simple(:x)) { x.length == 0}
      rule(:location => simple(:x)) { x.to_s.strip.gsub(/,$/,"")}
      AcquisitionMethod.valid_methods.each do |m|
        rule("acquisition_method_#{m.id}" => simple(:x)) {m}
      end
      # rule(:acquisition_method => simple(:x)) {x.key.to_s.strip}
    end
  end
end