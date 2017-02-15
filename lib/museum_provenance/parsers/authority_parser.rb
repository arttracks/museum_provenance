require_relative "parser_helpers"

module MuseumProvenance
  module Parsers
      # 
      # This parser will parse a Authority block, for example:
      # > Salvador Dali:           http://vocab.getty.edu/ulan/500009365
      # > Cyrus L. Sulzberger:     http://viaf.org/viaf/68936177
      # 
      # If it parses, it will return an array of :authorities:
      #
      # * :token           # The name of the entity
      # * :uri             # The URI represented
      #
      # @author [@workergnome]
      # 
    class AuthorityParser < Parslet::Parser

      include ParserHelpers
      include Parslet
     
      rule(:entity_name) {(str(":").absent? >> any).repeat(1).as(:string) >> str(":")}
      rule(:uri) {(str("\n").absent? >> any).repeat(1).as(:uri) >> str("\n").maybe }
      rule(:authority) {str("\n").repeat >> entity_name >> space >> uri}
      rule(:authorities) {authority.repeat.as(:authorities)>> str("\n").repeat}

      root(:authorities)
  
    end
  end
end