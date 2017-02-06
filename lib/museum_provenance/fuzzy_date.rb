# Extensions to the base Date class to support certainty and ranges
class Date
  prepend MuseumProvenance::Certainty

  def smart_to_s(*args)
    str = ""
    if self.precision > DateTimePrecision::MONTH
      str = self.strftime("%B %e, ")
     if year >=1
       year_str = self.year.to_s
       year_str += " CE" if year < 1000
     elsif year == 0
       year_str = "1 BCE"
     else
       year_str = "#{-year} BCE"
     end

      str += year_str
    elsif self.precision == DateTimePrecision::MONTH
      str = self.to_s(*args).gsub(certain_string,"")
      splits = str.split(" ")
      splits[1].gsub!(/^0+/,"")
      str = splits.join(" ")
      str += " CE" if year < 1000
    elsif self.precision == DateTimePrecision::YEAR
      if year >=1
        str = self.year.to_s
        str += " CE" if year < 1000
      elsif year == 0
        str = "1 BCE"
      else
        str = "#{-year} BCE"
      end
    elsif self.precision == DateTimePrecision::DECADE
      str = "the #{self.year}s"
    else
      bce = false
      year = (self.century/100+1)
      if year <= 0
        year = -(year-2)
        bce = true
      end  
      str = "the #{year.ordinalize} century"
      str += " CE" if year >= 1 && year < 10 && !bce
      str += " BCE" if bce
      str
    end
    str += certain_string unless self.certain?
    str.gsub!("  ", " ") 
    str
  end

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