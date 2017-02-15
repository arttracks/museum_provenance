module MuseumProvenance
  module Transformers
    class NoteInsertionTransform < Parslet::Transform        
      def initialize(notes,citations)
        super()
        rule(:footnote_key => simple(:key)) do |dict|
          notes.find{|n| n[:key] == dict[:key]}[:string]
        end
         rule(:citation_key => simple(:key)) do |dict|
          citations.find{|n| n[:key] == dict[:key]}[:string]
        end
      end
    end
  end
end