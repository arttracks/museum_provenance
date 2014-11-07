module MuseumProvenance
    # A class for holding all the information about a period, used for export and import.
    # Converted from a struct.
    class PeriodOutput
      @@attributes = [:period_certainty,
                    :acquisition_method,
                    :party,
                    :party_certainty,
                    :birth,
                    :birth_certainty,
                    :death,
                    :death_certainty,
                    :location,
                    :location_certainty,
                    :botb,
                    :botb_certainty,
                    :botb_precision,
                    :eotb,
                    :eotb_certainty,
                    :eotb_precision,
                    :bote,
                    :bote_certainty,
                    :bote_precision,
                    :eote,
                    :eote_certainty,
                    :eote_precision,
                    :original_text,
                    :provenance,
                    :parsable,
                    :direct_transfer,
                    :stock_number,
                    :footnote,
                    :primary_owner]
                    
      attr_accessor *@@attributes
    
    def PeriodOutput.members
      @@attributes
    end

    def to_a
      @@attributes.collect {|attr| self.send(attr)}
    end
    
    def to_h
      hash = {}
      @@attributes.each {|attr| hash[attr] = self.send(attr)}
      hash
    end
  end
end