Dir["#{File.dirname(__FILE__)}/*.rb"].sort.each { |f| require_relative(f)}
require "cultural_dates"

module MuseumProvenance
  module Transformers
    class ParagraphTransform
      def apply(obj)
        obj = TransferModeTransform.new.apply(obj)
        obj = CertaintyTransform.new.apply(obj)
        obj = CulturalDates::DateTransform.new.apply(obj)
        obj = AcquisitionTransform.new.apply(obj)
        obj = PurchaseTransform.new.apply(obj)

        return obj
      end
    end
  end
end