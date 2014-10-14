module MuseumProvenance
  
  # {Period} is a representation of a single event within a {Timeline}.
  #
  # It also functions as a linked list, where each period has a {#previous_period} and {#next_period},
  # and periods can be inserted before and after.   
  class Period

    # The string used to indicate uncertainty for an entire period.
    PERIOD_CERTAINTY_STRING = "Possibly"

    prepend Certainty   
    attr_reader  :next_period, :previous_period, :party, :location
    attr_accessor  :acquisition_method, :note, :original_text, :stock_number


    # Create a new party.
    # @todo replace the generic hash with a PeriodOutput.
    # @param _name [String] The party name of the Period
    # @param opts [Hash] A (poorly) used way to initialize the period.
    def initialize(_name = "", opts={})
      @direct_transfer = false
      self.party = _name

      self.location = opts[:location]
      self.note = opts[:note]
      @beginning = opts[:begin]
      @ending = opts[:end]
     end

     # Denormalize the period into a {PeriodOutput}.
     # @return [PeriodOutput] a populated Struct containing the {Period}'s information.
     def generate_output
       o = PeriodOutput.new
       o.period_certainty = self.certainty
       o.acquisition_method = acquisition_method.name if acquisition_method
       o.party = self.party.name
       o.party_certainty =self.party.certainty
       o.death = self.party.death
       o.death_certainty = self.party.death.certainty
       o.birth = self.party.birth
       o.birth_certainty = self.party.birth.certainty
       if location
         o.location = self.location.name
         o.location_certainty = self.location.certainty
       end
       if @beginning
         o.botb = @beginning.earliest_raw
         o.botb_certainty = @beginning.earliest_raw.certainty
         o.botb_precision = @beginning.earliest_raw.precision
         o.eotb = @beginning.latest_raw
         o.eotb_certainty = @beginning.latest_raw.certainty
         o.eotb_precision = @beginning.latest_raw.precision
       end
       if @ending
         o.bote = @ending.earliest_raw
         o.bote_certainty = @ending.earliest_raw.certainty
         o.bote_precision = @ending.earliest_raw.precision
         o.eote = @ending.latest_raw
         o.eote_certainty = @ending.latest_raw.certainty
         o.eote_precision = @ending.latest_raw.precision
       end
       o.original_text = self.original_text
       o.provenance = self.provenance
       o.parsable = self.parsable?
       o.direct_transfer = self.direct_transfer
       o.stock_number = self.stock_number
       o.footnote = self.note.join("; ") if self.note
       return o
     end

     # Denormalize the period into a [Hash]
     # @return [Hash] a hash of the {Period}'s information.
     def to_h
       generate_output.to_h
     end

     # Extract a time phrase out of a string, and use it to set the dates for this period.
     #
     # There's an entire article on the site about the various phrases for this.
     #
     # @param str [String] the string to search for a time reference
     # @param recursion_count [Fixnum] Used to count number of recursions to prevent infinite recursion
     # @return [String] the string with the time reference removed
     def parse_time_string(str, recursion_count = 0)
      raise "Too much recursion" if recursion_count > 10
      tokens = ["on", "before", "by", "as of", "after", "until", "until sometime after", "until at least", "until sometime before", "in", "between", "to at least"]
      found_token = tokens.collect{|t| str.scan(/\b#{t}\b/i).empty? ? nil : t }.compact.sort_by!{|t| t.length}.reverse.first
      #puts "Tokens: '#{found_token}', String: '#{str}'"
        if found_token.nil?
          vals = str.split(",")
          
          current_phrase = []
          last_date = nil
          while vals.count >= 1
            word = vals.pop
            current_phrase.unshift word
            date_phrase = current_phrase.join(",")
            current_date = DateExtractor.find_dates_in_string(date_phrase).first
            if !current_date.nil? && current_date == last_date && current_date.precision == last_date.precision
              vals.push current_phrase.shift
              break
            end
            last_date = current_date
          end
          str = vals.join(",")
          date_string = current_phrase.join(',')
        else
          str, date_string = str.split(found_token)
          date_string.strip! unless date_string.nil?
          str.strip 
        end
       
        case found_token
           when nil, "on"
            self.beginning = TimeSpan.parse(date_string)
           when "before", "by", "as of"
            self.beginning =TimeSpan.new(nil, date_string)
           when "after"
            self.beginning = TimeSpan.new(date_string,nil)
           when "until sometime after", "until at least", "to at least"
            self.ending = TimeSpan.new(date_string,nil)
           when "until"
              self.ending = TimeSpan.new(date_string,date_string)
           when "until sometime before" 
            self.ending = TimeSpan.new(nil,date_string)
           when "in"
            self.beginning = TimeSpan.new(nil,date_string)
            self.ending = TimeSpan.new(date_string,nil)
           when "between"
            dates = date_string.split(" and ")
            self.beginning = TimeSpan.new(dates[0],dates[0])
            self.ending = TimeSpan.new(dates[1],dates[1])
        end
      str.strip!
      str.gsub!(/,$/,"")
      str.strip!
      # recursively run until it can't find another date
      begin
        rerun = parse_time_string(str, recursion_count +1)
      rescue DateError
        return str
      end
      return rerun.strip
    end

    # Generate a textual representation of the timeframe of the period.
    # @return [String]
    def time_string
      if(   @beginning && @ending &&
            !@beginning.latest.nil? && !@ending.earliest.nil? && 
            !@beginning.earliest && !@ending.latest && 
            @beginning.latest_raw == @ending.earliest_raw
        )       
        timeframe = "in #{@beginning.to_s.gsub("by ","")}"
      else
        timeframe = @beginning.to_s || ""
        unless ending.nil?
          timeframe += " until " + @ending.to_s.gsub("after", "at least")
        end
      end
      timeframe = nil if timeframe.empty?
      return timeframe
    end

    # Setter for the {#next_period}.  
    # Will also reset direct transfer to false.
    # @param p [Period] the period directly following this period
    # @return [void]
    def next_period=(p) 
      @next_period = p
      @direct_transfer = false
    end

    # Setter for the {#previous_period}.  
    # Will also reset the previous period's direct transfer to false.
    # @param p [Period] the period directly preceding this period
    # @return [void]
    def previous_period=(p)
      @previous_period = p
      @previous_period.direct_transfer = false if @previous_period
    end

    # Determine if this period is before the provided period
    # @param p [Period] a period to check
    # @return [Boolean] true if this period appears before the provided period
    def is_before? (p)
      current = self.next_period
      while !current.nil?
        return true if current == p
        current = current.next_period
      end
      return false
    end

    # Determine if this period is after the provided period
    # @param p [Period] a period to check
    # @return [Boolean] true if this period appears after the provided period
    def is_after? (p)
      current = self.previous_period
      while !current.nil?
        return true if current == p
        current = current.previous_period
      end
      return false
    end

    # An array of all the periods linked to this period.
    #
    # The returned array will be ordered earliest-to-latest.
    #
    # @return [Array<Period>]
    def siblings
      siblings = [self]
      current = self.previous_period
      while !current.nil?
        siblings.unshift(current)
        current = current.previous_period
      end
      current = self.next_period
      while !current.nil?
        siblings.push(current)
        current = current.next_period
      end
      return siblings
    end

    # Set this period to indicate a direct transfer to the next period.
    #
    # Will return nil if there is not a next period.
    #
    # @param b [Boolean]
    # @return [Boolan, Nil]
    def direct_transfer= (b)
      if @next_period.nil?
        @direct_transfer = nil
      else
        @direct_transfer = b.to_bool
      end
      #if @direct_transfer
        # if @ending && @next_period.beginning
        #   raise DateError, "Date Mismatch between #{@ending} and #{@next_period.beginning}" unless @ending == @next_period.beginning
        # elsif @ending && !@next_period.beginning
        #   @next_period.beginning = @ending
        # elsif @next_period.beginning && !@ending
        #   @ending = @next_period.beginning
        # end
      #end
    end

    # Was this record directly transferred to the following {Period}
    #@return [Boolean, Nil] True if it was transferred directly, false if it wasn't, Nil if is there is no following record.
    def direct_transfer
      @next_period.nil? ? nil : @direct_transfer
    end
    alias :direct_transfer? :direct_transfer
    

    # Was this record directly received from the preceding {Period}
    #@return [Boolean, Nil] True if it was received directly, false if it wasn't, Nil if is there is no preciding record.
    def was_directly_transferred
      @previous_period.nil? ? nil : @previous_period.direct_transfer
    end
    alias :was_directly_transferred? :was_directly_transferred

    # Set the associated party of the Period.
    # @todo Allow this to be a {Party}, not just a string.
    # @todo ALlow removing a party
    # @param _party [String] The name of the party
    # @return [Party] the party
    def party=(_party)
      @party = Party.new(_party) if _party
    end

    # Set the associated location of the Period.
    # @todo ALlow removing a location
    # @todo Allow this to be a {Location}, not just a string.
    # @param _party [String] The name of the location
    # @return [Location] the location
    def location=(_party)
      @location = Location.new(_party) if _party
    end

    ##### PROVENANCE AND FOOTNOTES ######
    
    # Does the record have a footnote
    # @return [Boolean] True if the record has a footnote
    def has_note?
      !(note.nil? || note.empty?)
    end

    # Generate a provenance record for this string.
    # @return [String] the provenance text for this period.
    def provenance
        new_name = @acquisition_method.nil? ? party.name_with_birth_death : @acquisition_method.attach_to_name(party.name_with_birth_death)
        record_cert = self.certainty ? nil : PERIOD_CERTAINTY_STRING
        val = [record_cert, [new_name, @location,time_string,stock_number].compact.join(", ")].compact.join(" ").gsub("  "," ")
        val[0] = val[0].upcase unless was_directly_transferred
        val
    end
    alias :to_s :provenance
   
    # Debug view for showing a single {Period} with footnote.
    # The footnote will always be #1.
    # @todo Handle multiple footnotes within the record
    # @return [String] the provenance with the attached footnote.
    def provenance_with_note
      has_note? ? "#{provenance} [1]. 1. #{note}" : provenance
    end

    # Does this period output provenance that matches the original text used to generate it.
    #
    # This will ignore differences in case and certainty.
    # @param strict [Boolean] don't account for acquisition form method changes, misplaced commas, or different spacing.
    # @return [Boolean] true if the {#original_text} matches the {#provenance}
    def parsable?(strict = false)
      if original_text.nil? 
        true
      else
        ot = original_text.clone
        p = provenance.clone
        Certainty::CertantyWords.each do |w| 
          ot.gsub!(w,"")
          p.gsub!(w,"")
        end

        basically_parsable = (ot.strip.downcase == p.strip.downcase)
        return true if basically_parsable
        return false if strict

        method = AcquisitionMethod.find(ot)
        return false if method.nil?

        method.forms.sort_by!{|t| t.length}.reverse.each do |f|
         new_ot = ot.gsub(/#{f}/i,"")
         if new_ot != ot
          ot = new_ot
          break
         end
        end
        ot = method.attach_to_name(ot)
        complicated_match = (ot.strip.downcase.gsub(" ","").gsub(",","") == p.strip.downcase.gsub(" ","").gsub(",",""))
        return complicated_match
      end
    end
    alias :parsable :parsable?

    # Set the beginning of the period to the value given.
    # @param (see TimeSpan.parse)
    # @raise (see TimeSpan.parse)
    # @return [TimeSpan]
    def beginning=(val)
      @beginning = TimeSpan.parse(val)
    end

    # The {TimeSpan} representing the starting of this period.
    #
    # This will return the raw timespan.
    # @see #botb, #eotb
    # @return [TimeSpan]
    def beginning
      @beginning
    end

    # Set the ending of the period to the value given.
    # @param (see TimeSpan.parse)
    # @raise (see TimeSpan.parse)
    # @return [TimeSpan]
    def ending=(b)
      @ending = TimeSpan.parse(b)
    end

    # The {TimeSpan} representing the completion of this period.
    # This will return the raw timespan.
    # @see #bote, #eote
    # @return [TimeSpan]
    def ending
      @ending
    end

    # The {Date} representing the earliest possible date for the start of this period.
    #
    # This is the last date by which you are certain the work was NOT owned by the relevant party.
    #
    # This best way to think about this date is it is the last date where you
    # know for sure that the period was NOT valid.  For example, if you know
    # that an artwork was owned by Jane in Feb. 2000, and you know that the artwork
    # was owned by Jill in March 2001, for the Jill's period of ownership the
    # {#botb} is Feb. 2000.
    # 
    # @return [Date]
    def botb 
      @beginning.earliest if @beginning
    end
    alias :begin_of_the_begin :botb


    # The {Date} representing the latest possible date for the start of this period.
    #
    # This is the first date by which you are certain the work was owned by the relevant party.
    #
    # This best way to think about this date is it is the first date where you
    # know for sure that the period WAS valid.  For example, if you know
    # that an artwork was owned by Jane in Feb. 2000, and you know that the artwork
    # was owned by Jill in March 2001, for the Jill's period of ownership the
    # {#eotb} is March 2001.  
    # 
    # @return [Date]
    def eotb 
      @beginning.latest if @beginning 
    end
    alias :end_of_the_begin :eotb

    # The {Date} representing the earliest possible date for the end of this period.
    #
    # This is the last date by which you are certain the work was owned by the relevant party.
    #
    # This best way to think about this date is it is the first date where you
    # know for sure that the period WAS valid.  For example, if you know
    # that an artwork was owned by Jane in Feb. 2000, and you know that the artwork
    # was owned by Jill in March 2001, for the Jane's period of ownership the
    # {#bote} is Feb. 2000.  
    # 
    # @return [Date]
    def bote 
      @ending.earliest if @ending
    end
    alias :begin_of_the_end :bote

    # The {Date} representing the latest possible date for the end of this period.
    #
    # This is the first date by which you are certain the work was NOT owned by the relevant party.
    #
    # This best way to think about this date is it is the first date where you
    # know for sure that the period WAS valid.  For example, if you know
    # that an artwork was owned by Jane in Feb. 2000, and you know that the artwork
    # was owned by Jill in March 2001, for the Jane's period of ownership the
    # {#eote} is March 2001.  
    # 
    # @return [Date]
    def eote 
      @ending.latest if @ending 
    end
    alias :end_of_the_end :eote

    # Is this period currently active
    #
    # This is used to determine if a period continues until the present day.
    # A period is defined as ongoing if there is a beginning, no ending, and no next period.
    #
    # @return [Boolean] 
    def is_ongoing?
      next_period.nil? && @ending.nil? && !@beginning.nil?
    end

    # The {TimeSpan} of the longest possible duration of this period
    #
    # @return [TimeSpan, Nil] 
    def max_timespan
      return nil unless (@beginning && @ending) || self.is_ongoing?
      if self.is_ongoing?
        TimeSpan.new(botb,Date.today)
      else
        TimeSpan.new(botb,eote)
      end
    end

    # Find the earliest possible date for this period
    #
    # This differs from {#botb} in that it will traverse the list backwards 
    # looking for a date.  This is to handle periods that are ordered, but without
    # any defined dates.  Will return nil if no date can be found.
    #
    # @return [Date, Nil] The earliest possible date for this period
    def earliest_possible
      return begin_of_the_begin if begin_of_the_begin
      if previous_period
        return previous_period.begin_of_the_end if previous_period.begin_of_the_end
        return previous_period.end_of_the_begin if previous_period.end_of_the_begin
        return previous_period.begin_of_the_begin if previous_period.begin_of_the_begin
        return previous_period.earliest_possible
      end
      return nil
    end

    # Find the latest possible date for this period
    #
    # This differs from {#eote} in that it will traverse the list forwards 
    # looking for a date.  This is to handle periods that are ordered, but without
    # any defined dates.  Will return nil if no date can be found.  Will return today
    # if the period is ongoing.
    #
    # @return [Date, Nil] The latest possible date for this period
    def latest_possible
      return end_of_the_end if end_of_the_end
      return Date.today if is_ongoing?
      if next_period
        return next_period.end_of_the_begin if next_period.end_of_the_begin
        return next_period.begin_of_the_end if next_period.begin_of_the_end
        return next_period.end_of_the_end if next_period.end_of_the_end
        return next_period.latest_possible
      end
      return nil
    end

  end
end