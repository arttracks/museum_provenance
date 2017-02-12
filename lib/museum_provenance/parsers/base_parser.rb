Dir["#{File.dirname(__FILE__)}/*.rb"].sort.each { |f| require(f) }

module MuseumProvenance
  module Parsers
    class BaseParser < Parslet::Parser
    include Parslet
    include ParserHelpers

    def initialize(opts = {})
      @acquisition_methods = opts[:acquisition_methods] || AcquisitionMethod.valid_methods
    end

    rule (:period_certainty)  { ((str_i("Possibly")  >> space) | str("")).as(:period_certainty)}

    actor = ActorParser.new
    rule (:actors) do
      (actor.as(:custodian) >> str("for") >> actor.as(:owner)) |
      actor.as(:owner)
    end


    rule (:transfer_location) do
      str("in") >> space >> PlaceParser.new.as(:transfer_location)
    end

    rule(:period) {(
      period_certainty >> 
      AcquisitionMethodParser.new(@acquisition_methods).maybe >> 
      actors  >>
      NamedEventParser.new.maybe >>
      transfer_location.maybe >>
      DateStringParser.new.as(:date) >> 
      SaleDataParser.new.maybe >>
      period_end).as(:period) 
    }


    rule(:provenance) {period.repeat(1)}

    root :provenance

    end
  end
end