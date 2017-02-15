Dir["#{File.dirname(__FILE__)}/parsers/*.rb"].sort.each { |f| require(f)}
Dir["#{File.dirname(__FILE__)}/transformers/*.rb"].sort.each { |f| require(f)}

module MuseumProvenance
  class Parser
    include Parsers
    include MuseumProvenance::Transformers
    attr_reader :authorities, :notes, :paragraph, :citations
    def initialize(str)
      split(str)
      if @authorities
        @authorities = AuthorityParser.new.parse(@authorities)
        @authorities = AuthorityTransform.new.apply(@authorities)[:authorities]
        @authorities.each do |auth|
          @paragraph.gsub!(auth[:string],auth[:token])
        end
      end 

      @paragraph = ParagraphParser.new.parse(@paragraph)
      @paragraph = ParagraphTransform.new.apply(@paragraph)
      @paragraph = TokenTransform.new(@authorities).apply(@paragraph)
    end



    private

    def split(str)
      rest, @citations = str.split("\nCitations:\n")
      rest, @authorities = rest.split("\nAuthorities:\n")
      @paragraph, @notes = rest.split("\nNotes:\n")
    end

  end
end