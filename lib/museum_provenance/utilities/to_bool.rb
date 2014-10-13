
# Ruby built-in representation of strings.
class String
  # Extends [String] for conversion to a boolean.
  # @return [Boolean]
  def to_bool
    return true if self == true || self =~ (/^(true|t|yes|y|1)$/i)
    return false if self == false || self.blank? || self =~ (/^(false|f|no|n|0)$/i)
    raise ArgumentError.new("invalid value for Boolean: \"#{self}\"")
  end
end

# Ruby built-in representation of integers, reopened to add additional functionality.
class Fixnum
  # Extends [Fixnum] for conversion to a boolean.
  # @return [Boolean]
  def to_bool
    return true if self == 1
    return false if self == 0
    raise ArgumentError.new("invalid value for Boolean: \"#{self}\"")
  end
end


# Ruby built-in representation of True, reopened to add additional functionality.
class TrueClass
  # Extends [TrueClass] for conversion to a [Fixnum].
  # @return [1]
  def to_i; 1; end

  # Trival method to return true
  # @return [self]
  def to_bool; self; end
end


# Ruby built-in representation of False, reopened to add additional functionality.
class FalseClass
  # Extends [FalseClass] for conversion to a [Fixnum].
  # @return [0]
  def to_i; 0; end
  # Trival method to return false
  # @return [self]
  def to_bool; self; end
end


# Ruby built-in representation of Nil, reopened to add additional functionality.
class NilClass
  # Extends [NilClass] for conversion to a boolean.
  # @return [false]
  def to_bool; false; end
end