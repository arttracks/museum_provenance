module MuseumProvenance
  module Transformers
    class PurchaseTransform < Parslet::Transform
      rule(:value => simple(:val), :currency_symbol => simple(:cur)) do |dict| 
        amt = dict[:val].to_s.gsub(",","")
        xamt= amt.gsub("M", "000000")
        {:value => amt, :currency_symbol => dict[:cur]}
      end
    end
  end
end