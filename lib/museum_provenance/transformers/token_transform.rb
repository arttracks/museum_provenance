module MuseumProvenance
  module Transformers
    class TokenTransform < Parslet::Transform        
      def initialize(tokens)
        super()

        # Replace tokens in parsed periods
        rule(:token => simple(:token), :certainty => simple(:certainty)) do |dict|
          token = tokens.find{|t| t[:token].to_s == dict[:token].to_s}
          {
            token: dict[:token],
            string: token[:string],
            uri: token[:uri],
            certainty: dict[:certainty]
          }
        end

        # Replace tokens in unparsable periods, 
        # while maintaining the transfer directness
        rule(:unparsable => simple(:str), :direct_transfer=>simple(:transfer), :text=> simple(:text)) do |dict|
          str = dict[:str].clone.to_s

          tokens.each {|token| str.gsub!(token[:token], token[:string])}
          {
            :unparsable => str,
            :text => dict[:text],
            :direct_transfer => dict[:transfer]
          }
        end

      end
    end
  end
end