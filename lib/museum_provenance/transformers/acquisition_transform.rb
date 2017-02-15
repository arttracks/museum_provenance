require_relative "../acquisition_method"
require_relative "../acquisition_method_list"
module MuseumProvenance
  module Transformers
    class AcquisitionTransform < Parslet::Transform
        rule(:acquisition_method_string => simple(:x)) do
          str = AcquisitionMethod.find(x.to_s)&.id
          str ? "acq:#{str}" : nil
        end
    end
  end
end