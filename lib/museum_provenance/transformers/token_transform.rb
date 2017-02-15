module MuseumProvenance
  module Transformers
    class TokenTransform < Parslet::Transform        
      def initialize(tokens)
        super()
        @tokens = tokens
        rule(:token => simple(:token), :certainty => simple(:certainty)) do |dict|
          token = @tokens.find{|t| t[:token].to_s == dict[:token].to_s}
          {
            token: dict[:token],
            string: token[:string],
            uri: token[:uri],
            certainty: dict[:certainty]
          }
        end
      end
    end
  end
end