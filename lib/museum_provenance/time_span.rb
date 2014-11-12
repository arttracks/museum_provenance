require "chronic"
require 'date_time_precision/format/iso8601'

module MuseumProvenance

  # Generic error.  No additional functionality.
  class DateError < StandardError
  end

  # {TimeSpan} describes a period of time with a beginning and an end
  #
  # It's important to note that this is not used for a {Period}— it's 
  # used to hold the fuzziness associated with acquisiton and deacquisition events.
  # It assumes that a {TimeSpan} can have a beginning and an end, but it might not have either.
  # Because of this, it has a earliest and a latest date.
  #
  # It also uses the extensions to {Date} to capture the precision of each of those dates.   
  #
  # @example With only a beginning
  #   span = TimeSpan.new("2014",nil)
  #   span.to_s       # => "after 2014"
  #   span.earliest   # => Wed, 01 Jan 2014
  #   span.latest     # => nil
  #  
  # @example With only a ending
  #   span = TimeSpan.new(nil,"2014")
  #   span.to_s       # => "by 2014"
  #   span.earliest   # => nil
  #   span.latest     # => Wed, 31 Dec 2014 
  #   
  class TimeSpan 

    # Find a TimeSpan within an arbitrary value.
    #
    # It assumes that any date that it finds is both the earliest and the latest date of the timespan—
    # if you need to set them independantly, use {TimeSpan#initialize}.
    #
    # @param val [Date,TimeSpan,Fixnum,String] A value to search for a TimeSpan
    # @return [TimeSpan] The found timespan
    # @raise [DateError] if a date cannot be found within the val
    def TimeSpan.parse(val)
      if val.is_a? Date
        TimeSpan.new(val,val)
      elsif val.is_a? TimeSpan
        val
      elsif val.is_a? Fixnum
        TimeSpan.parse Date.strptime(val.to_s,'%s')
      elsif val.is_a? String
        begin
          found_date = DateExtractor.find_dates_in_string(val).first
          raise DateError, "Invalid date.  Could not parse '#{val}' as a date." if found_date.nil? 
          TimeSpan.parse(found_date)    
        end
      end
    end

    # Create a new TimeSpan from two dates.
    #
    # This will either parse strings or accept dates for both values.
    # Additionally, it will re-order the dates if the two dates come in backwards.
    # To create a timespan without an earliest date, pass [Nil] as the first period.
    #
    # @param _earliest [String,Date, Nil] The earliest date of the TimeSpan
    # @param _latest [String,Date,Nil] The latest date of the TimeSpan
    def initialize(_earliest = nil,_latest = nil)
      if _earliest.is_a? String
        _earliest= DateExtractor.find_dates_in_string(_earliest).first
      end
      if _latest.is_a? String
        _latest = DateExtractor.find_dates_in_string(_latest).first
      end
      
      @earliest = _earliest.nil? || _latest.nil? ? _earliest : [_earliest,_latest].min
      @latest =   (_earliest.nil? ? _latest : [_earliest,_latest].max) unless _latest.nil?
    end
    

    # Generate a textual representation of the TimeSpan
    #
    # @example With only a latest date
    #   span = TimeSpan.new(nil,"2014")
    #   span.to_s       # => "by 2014"
    # @example With only an earliest date
    #   span = TimeSpan.new("2014",nil)
    #   span.to_s       # => "after 2014"
    # @example With both dates the same
    #   span = TimeSpan.new("2014","2014")
    #   span.to_s       # => "2014"
    # @example With both dates, but different
    #   span = TimeSpan.new("2000","2014")
    #   span.to_s       # => "between 2000 and 2014"
    # @return [String] A string representation of the date
    def to_s
      return nil unless self.defined?
      return "#{earliest.smart_to_s(:long)}" if self.precise?
      return "#{@earliest.smart_to_s(:long)}" if self.same?
      if @earliest && @latest
        "between #{@earliest.smart_to_s(:long)} and #{@latest.smart_to_s(:long)}"
      elsif @latest
        "by #{@latest.smart_to_s(:long)}"
      elsif @earliest
        "after #{@earliest.smart_to_s(:long)}"
      else
        return nil
      end
    end

    # Returns the earliest day in the Timespan.
    # Note that this returns a date that is accurate to the day, not the date with the precision set.
    # @example
    #   date = TimeSpan.new("2014")
    #   date.earliest # => Wed, 01 Jan 2014 
    #   date.precision # DateTimePrecision::DAY
    #   
    #   date = TimeSpan.new("October 2014")
    #   date.earliest # => Wed, 01 Oct 2014
    #   date.precision # DateTimePrecision::DAY
    #
    # @see #earliest_raw
    # @see #latest
    # @return [Date] The earliest day in the timespan
    def earliest
      @earliest.earliest if @earliest
    end
    
    # Returns the earliest date.
    # Note that this returns a date that has the precision set, not the earliest day.
    # @example
    #   date = TimeSpan.new(nil,"2014")
    #   date.earliest_raw # => Wed, 01 Jan 2014 
    #   date.precision # DateTimePrecision::YEAR
    #   
    #   date = TimeSpan.new(nil,"October 2014")
    #   date.earliest_raw # => Wed, 01 Oct 2014
    #   date.precision # DateTimePrecision::MONTH
    #
    # @see #earliest
    # @return [Date] The earliest date in the timespan
    def earliest_raw
      @earliest
    end

    # Returns the latest day in the Timespan.
    # Note that this returns a date that is accurate to the day, not a date with the precision set.
    # @example
    #   date = TimeSpan.new(nil,"2014")
    #   date.latest # => Wed, 31 Dec 2014
    #   date.precision # DateTimePrecision::DAY
    #   
    #   date = TimeSpan.new(nil,"October 2014")
    #   date.latest # => Fri, 31 Oct 2014 
    #   date.precision # DateTimePrecision::DAY
    #
    # @see #latest_raw
    # @see #earliest
    # @return [Date] The latest day in the timespan
    def latest
      @latest.latest if @latest
    end

    # Returns the latest date.
    # Note that this returns a date that has the precision set, not the latest day.
    # @example
    #   date = TimeSpan.new(nil,"2014")
    #   date.latest_raw # => Wed, 01 Jan 2014 
    #   date.precision # DateTimePrecision::YEAR
    #   
    #   date = TimeSpan.new(nil,"October 2014")
    #   date.latest_raw # => Wed, 01 Oct 2014
    #   date.precision # DateTimePrecision::MONTH
    #
    # @see #latest
    # @return [Date] The latest date in the timespan
    def latest_raw
      @latest
    end

    # Compare two TimeSpans
    def ==(other)
      other && other.earliest == earliest && other.latest == latest
    end

    # Determine if a TimeSpan's is nil.
    #@return [Boolean] true if the TimeSpan has neither an {#earliest} not a {#latest}
    def nil?
      earliest.nil? && latest.nil?
    end

    # Determine if a TimeSpan's earliest and latest both exist.
    #@return [Boolean] true if the TimeSpan has both an {#earliest} and a {#latest}
    def defined?
      !(@earliest.nil? && @latest.nil?)
    end

    # Determine if a TimeSpan's earliest and latest match.
    #@return [Boolean] true if the TimeSpan's {#earliest} and {#latest} are identical
    def same?
      !!(self.defined? && 
        @earliest && 
        @latest && 
        @earliest.precision == @latest.precision && 
        @earliest.fragments[0..@earliest.precision] == @latest.fragments[0..@latest.precision]
      )
    end

    # Determine if a TimeSpan is accurate to within a day
    #@return [Boolean] true if the date is the {#same? same}, as well as accurate to the day
    def precise?
      self.same? && @earliest.precision >= DateTimePrecision::DAY
    end
  end
end