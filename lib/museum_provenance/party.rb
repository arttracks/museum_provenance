require_relative "entity.rb"
module MuseumProvenance
  # {Party} is a data structure for holding the associated information about the relevant party of a {Period}.  
  # A Party is usually a person or organization that is involved with an artwork.
  # It extends {Entity} with birth and death information, 
  # and is intended be extended to include name lookup and biographical functionality.
  class Party < Entity
    # @!attribute birth
    #   @return [Date] The birth date of the party
    # @!attribute death
    #   @return [Date] The death date of the party
    attr_accessor :birth, :death

    # @example
    #    Party.new("Linda")
    #    linda.birth = Date.new(1975)
    #    linda.name_with_birth_death  # "Linda [1975-]"
    # @return [String] The name of the party with birth and death dates appended.
    def name_with_birth_death
      if birth || death
        self.to_s + " [#{birth.to_s(:long) rescue ""}-#{death.to_s(:long) rescue ""}]"
      else
        self.to_s
      end
    end
  end
end   