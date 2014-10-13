# Extensions to the base Date class to support certainty and ranges
class Date
  prepend MuseumProvenance::Certainty

  unless method_defined?(:earliest)
    # The earliest date for an inprecise date.
    # The returned date will have DateTimePrecision::DAY
    # @example
    #    date = Date.new(1990)
    #    date.earliest == Date.new(1990,1,1)
    #    
    #    date = Date.new(1990,10)
    #    date.earliest == Date.new(1990,10,1)
    # @return [Date] A new Date containing the date of the first day in an date.
    def earliest
      earliest = case precision
        when DateTimePrecision::CENTURY then Date.new(year,1,1)
        when DateTimePrecision::DECADE then Date.new(year,1,1)
        when DateTimePrecision::YEAR then Date.new(year,1,1)
        when DateTimePrecision::MONTH then Date.new(year,month,1)
        else self.clone
      end
      earliest.certainty = self.certainty
      earliest
    end
  end
  
  unless method_defined?(:latest)
    # The latest date for an inprecise date.
    # The returned date will have DateTimePrecision::DAY. 
    # @example
    #    date = Date.new(1990)
    #    date.latest == Date.new(1990,12,31)
    #    
    #    date = Date.new(1990,10)
    #    date.latest == Date.new(1990,10,31)
    # @return [Date] A new Date containing the date of the last day in an date.
    def latest
      latest = case precision
        when DateTimePrecision::CENTURY then Date.new(year+99,-1,-1) 
        when DateTimePrecision::DECADE then Date.new(year+9,-1,-1) 
        when DateTimePrecision::YEAR then Date.new(year,-1,-1)
        when DateTimePrecision::MONTH then Date.new(year,month,-1)
        else self.clone
      end
      latest.certainty = self.certainty
      latest
    end 
  end
end