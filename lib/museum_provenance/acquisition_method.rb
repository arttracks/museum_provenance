module MuseumProvenance
  # AcquisitionMethod is a data structure designed to hold forms of acqusition for lookup.  
  # Each method can hold multiple valid forms, some of which go before the name, and some
  # of which go after the name.
  #
  # It also contains a human-readable definition of the form for display.
  class AcquisitionMethod

    # Signifies that the form's preferred location is before the name.
    Prefix = :prefix
    # Signifies that the form's preferred location is after the name.
    Suffix = :suffix
    
    # Returns a list of valid AcquisitionMethod instances
    #
    # @return [Array<AcquisitionMethod>] A list of all loaded acquisition methods
    def self.valid_methods
      @@all_methods ||= []
    end

    # Finds an instance of {AcquisitionMethod} with a given name.
    #
    # Returns nil if no match is found.
    #
    # @param name [String] a string containing the acquisition method name.
    # @return [AcquisitionMethod] the found acquisition method.  
    def AcquisitionMethod.find_by_name(name)
      @@all_methods.find{|method| method.name == name}
    end

    
    # Finds an instance of {AcquisitionMethod} containing the provided text
    #
    # If multiple forms match, this will return the most explicit form.  
    # Returns nil if no match is found.
    #
    # @param str [String] a string potentially containing a form of acquisition.
    # @return [AcquisitionMethod] the found acquisition method.  
    def AcquisitionMethod.find(str)
      valid_methods = []
      @@all_methods.each do |method|
        method.forms.each do |form|
          valid_methods.push [method,form.downcase] if str.downcase.include? form.downcase
        end
      end
      valid_methods.compact
      return nil if valid_methods.empty?
      valid_methods.sort_by!{|t| t[1].length}.reverse.first[0]
    end

    # Generates Markdown example files for all acquisition methods
    #
    # @param name [String] a name for use in examples.
    # @param location [String] a location for use in examples.
    # @param date [String] a date for use in examples.
    # @return [Array] an array of markdown-formatted strings.  
    def AcquisitionMethod.describe(name="Vincent Price [1911-1993]", location="St. Louis, Missouri", date="July 1969")
       @@all_methods.sort_by{|m| m.name}.collect do |m|
        s = "## #{m.name}  \n"
        s += "\n\n*#{m.definition}*"
        s += "\n\n**Preferred:**   #{m.send(m.preferred_form)}  "
        s += "\n**Other Forms:**  #{m.other_forms.join("; ")}  " unless m.other_forms.empty?
        s += "\n**Example: **    #{[m.attach_to_name(name),location,date].compact.join(", ")}#{["."].sample}  "
        s += "\n\n"
       end
    end

    # @!attribute [r] name
    #   @return [String] the name of the method
    # @!attribute [r] prefix
    #   @return [String] the preferred prefix form of the method
    # @!attribute [r] suffix
    #   @return [String] the preferred suffix form of the method
    # @!attribute [r] definition
    #   @return [String] A human readable definition of the method
    # @!attribute [r] preferred_form
    #   @return [Symbol<AcquisitionMethod::Prefix,AcquisitionMethod::Suffix>] Which form is preferred for this method
       
    attr_reader :name, :prefix, :suffix, :definition, :preferred_form
    
    # Creates a new instance of AttributionMethod.  
    # Note that this will also add it to the Class-level list of Attribution Methods, which can be queried via @AttributionMethod::valid_methods
    def initialize(name, prefix,suffix,definition, preferred_form, synonyms = nil)
      @name, @prefix, @suffix, @definition, @preferred_form, @synonyms = name, prefix,suffix,definition,preferred_form, synonyms
      @@all_methods ||= []
      @@all_methods.push self
    end
    
    # Concatinates the preferred form with a given name.
    # Will properly handle both prefixes and suffixes, which is why we need a method to do this.
    #
    # @param name [String] The name to which you wish to attach the method.
    # @return [String] the given name with the preferred form attached to it.
    # @example For 'Gift of' 
    #   attach_to_name("david")  # -> "Gift of david" 
    def attach_to_name(name)
      if preferred_form == Prefix
        s= [prefix,name].compact.join(" ")
      else
        s = [name,suffix].compact.join(" ")
      end
      s.strip
    end

    # @return [String] The preferred form.
    def preferred
      self.send(preferred_form)
    end

    # @return [Array<String>] A list of all forms of the Method.
    def forms
      [preferred,other_forms].flatten.compact
    end

    # @return [Array<String>] A list of all forms of the Method EXCEPT the preferred form.
    def other_forms
      if preferred_form == Prefix
        [suffix,@synonyms].flatten.compact
      else      
        [prefix,@synonyms].flatten.compact
      end
    end

    # @return [String] Returns the name of the method.    
    def to_s
      name
    end
  end
end