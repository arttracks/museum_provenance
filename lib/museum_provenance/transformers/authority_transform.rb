
module MuseumProvenance
  module Transformers
    class AuthorityTransform < Parslet::Transform
        def self.reset_counter
          @@counter = 0
        end

        @@counter = 0
        rule(:string => simple(:string), :uri => simple(:uri)) do |dict|
          uri = dict[:uri].to_s.downcase.include?("no record found") ? nil : dict[:uri].to_s
          @@counter +=1
          @@counter = 1 if @@counter > 999999 
          {
            token: "$AUTHORITY_TOKEN_#{@@counter}",
            string: dict[:string].to_s,
            uri: uri
          }
        end
    end
  end
end