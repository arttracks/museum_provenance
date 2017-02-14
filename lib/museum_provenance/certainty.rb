# Extends nil to support certainty.
class NilClass
  # @return [nil]
  def certainty
    return nil
  end
  alias :certain? :certainty
end

module MuseumProvenance
  
  # Extends a class to allow certainty and uncertaintly to be added to the class.
  # it overrides {#to_s} to add a question mark after the value if the value is uncertain.
  module Certainty

    # # A list of possible words that indicate that a String could be uncertain.
    # CertantyWords = ["?", "possibly", "Possibly", "probably", "Probably", "Likely", "likely", "Potentially","potentially", "Presumably", "presumably", "Said to be", "said to be"]
    # # The string which should be appended if a value is uncertain.
    # CertaintyString = "?"

    # # Sets the certainty of an object.
    # # @param certainty_value [Boolean]
    # # @return [Boolean] the value set.
    # def certainty=(certainty_value)
    #   @certain = !!certainty_value
    # end
    # alias :certain= :certainty=

    # # Gets the certainty of an object.
    # # By default, objects are certain.
    # # @return [Boolean] returns the certainty.
    # def certainty
    #   @certain = true if @certain.nil?
    #   @certain
    # end 
    # alias :certain? :certainty
    # alias :certain :certainty

    # # Adds a question mark to a uncertain object's string representation.
    # # @example
    # #    test = "I am a banana"
    # #    test.certainty = false
    # #    test.to_s # "I am a banana?"
    # def to_s(*args)
    #   str = super(*args)
    #   str += CertaintyString unless self.certain?
    #   str
    # end

    # # Scan a string for {CertantyWords}
    # #   
    # # @param str [String] A string to scan. 
    # # @return [Boolean] returns true if a {CertantyWords} is found in the string.
    # def detect_uncertainty(str)
    #   is_certain = false
    #   CertantyWords.each do |certainty_word|
    #     is_certain = true if str.downcase.include?(certainty_word)
    #   end
    #   return is_certain
    # end

    # # Remove {CertantyWords} from a string.
    # #   
    # # @param str [String] A string to scan. 
    # # @return [String] str with {CertantyWords} removed.
    # def remove_uncertainty(str)
    #   phrase = str
    #   CertantyWords.each do |certainty_word|
    #     phrase = phrase.gsub(certainty_word, "")
    #   end
    #   return phrase.strip
    # end

    # # @return [CertaintyString,""] The appended value if uncertain, otherwise a blank string.
    # def certain_string
    #   self.certain? ? "" : CertaintyString
    # end
  end
end