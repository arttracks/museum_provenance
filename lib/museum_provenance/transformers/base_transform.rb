Dir["#{File.dirname(__FILE__)}/*.rb"].sort.each { |f| require_relative(f)}

module MuseumProvenance
  module Transformers
    class BaseTransform
      def self.transform(obj)
        obj = TransferModeTransform.new.apply(obj)
        obj = CertaintyTransform.new.apply(obj)
        obj = CitationTransform.new.apply(obj)
        return obj
      end
    end
  end
end