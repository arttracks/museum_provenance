Dir["#{File.dirname(__FILE__)}/parsers/*.rb"].sort.each { |f| require(f)}
Dir["#{File.dirname(__FILE__)}/transformers/*.rb"].sort.each { |f| require(f)}

module MuseumProvenance
  class Parser
    include Parsers
    include Enumerable
    include MuseumProvenance::Transformers
    attr_reader :authorities, :notes, :paragraph, :citations, :original
    def initialize(str)
      @original = str
      split(str)

      if @authorities
        @authorities = AuthorityParser.new.parse(@authorities)
        @authorities = AuthorityTransform.new.apply(@authorities)[:authorities]
        @authorities.each do |auth|
          @paragraph.gsub!(auth[:string],auth[:token])
        end
      end 

      if @notes
        @notes = NoteSectionParser.new.parse(@notes)[:notes]
      end

      if @citations
        @citations = NoteSectionParser.new.parse(@citations)[:notes]
      end

      @paragraph = ParagraphParser.new.parse(@paragraph)

      add_original_text_to_periods

      @paragraph = ParagraphTransform.new.apply(@paragraph)
      @paragraph = TokenTransform.new(@authorities).apply(@paragraph)
      @paragraph = NoteInsertionTransform.new(@notes,@citations).apply(@paragraph)
    end

    def each &block
      @paragraph.each{|member| block.call(member)}
    end

    def [](n)
      @paragraph[n]
    end
    def last
      @paragraph.last
    end

    private

    def add_original_text_to_periods
      return unless @authorities

      fake_original = @original.clone
      
      @authorities.each do |auth|
        fake_original.gsub!(auth[:string],auth[:token])
      end

      prev_offset = 0
      @paragraph.each do |para|
        offset = para[:direct_transfer][:transfer_punctuation].offset
        val = fake_original[prev_offset..offset]
        prev_offset = offset +2

        @authorities.each do |auth|
          val.gsub!(auth[:token],auth[:string])
        end

        para[:text] = val
      end
    end

    def split(str)
      rest, @citations = str.split("\nCitations:\n")
      rest, @authorities = rest.split("\nAuthorities:\n")
      @paragraph, @notes = rest.split("\nNotes:\n")
    end

  end
end