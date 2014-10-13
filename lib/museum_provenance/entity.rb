module MuseumProvenance
  # {Entity} is a data structure for holding information about generic entiries used in a {Period}.
  # It is not currently used on it's own, but as a generic structure to be extended by {Party} and {Location}.
  class Entity
    prepend Certainty
    
    # @param name [String] the name of the entity. see {#name=} for more info.
    # @return The name.
    def initialize(name)
      self.name = name
    end

    # @return [String] The name, with the uncertainty signifier appended.  
    def to_s
      self.name
    end

    # Setting the name will detect and remove any indicators of uncertainty.
    # @see MuseumProvenance::Certainty
    # @param _name [String] the desired name of the entity.
    # @return The name.
    def name=(_name) 
      return if _name.nil?
      self.certainty = !detect_uncertainty(_name)
      @name = remove_uncertainty(_name).strip.chomp(",")
    end

    # @return [String] the name of the entity
    def name
      @name
    end
    
    # Compare an entity to another entity.  Equality is based on both name and certainty.
    #
    # @example
    #    jane_1 = Entity.new("Jane")
    #    jane_2 = Entity.new("Jane")
    #    jane_1 == Jane_2 # -> true
    #    
    #    jane_1.certainty = false
    #    jane_1 == Jane_2 # -> false
    #
    # @param other [Entity] The entity to compare
    # @return [Boolean]
    def ==(other)
      self.name == other.name && self.certain? == other.certain?
    end
  end
end   