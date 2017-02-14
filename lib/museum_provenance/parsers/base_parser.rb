Dir["#{File.dirname(__FILE__)}/*.rb"].sort.each { |f| require(f) }

module MuseumProvenance
  module Parsers
    class BaseParser < Parslet::Parser
    include Parslet
    include ParserHelpers

    def initialize(opts = {})
      @acquisition_methods = opts[:acquisition_methods] || AcquisitionMethod.valid_methods
    end

    # Is the period certain or uncertain?
    rule (:period_certainty)  { ((str_i("Possibly").as(:period_certainty_value)  >> space) | str("").as(:period_certainty_value)).as(:period_certainty)}

    # "agent for owner" or just "owner"
    actor = ActorParser.new
    rule (:actors) do
      (actor.as(:purchasing_agent) >> (comma | space) >> str("for") >> space >> actor.as(:owner)) |
      actor.as(:owner)
    end

    # Where did the transaction take place?
    rule (:transfer_location) do
      str("in") >> space >> PlaceParser.new.as(:transfer_location)
    end

    rule(:period) {(
      period_certainty >> 
      AcquisitionMethodParser.new(@acquisition_methods).maybe >> 
      actors  >>
      ((comma | space) >> NamedEventParser.new).maybe >>
      (comma.maybe >> transfer_location).maybe >>
      (comma.maybe >> DateStringParser.new.as(:timespan)).maybe >> 
      (comma.maybe >> SaleDataParser.new).maybe >>
      (space.maybe >> NotesParser.new).maybe >>
      period_end.as(:direct_transfer))
    }

    rule(:fallback) { ((period_end.absent? >> any).repeat(1,nil).as(:unparsable) >> period_end.as(:direct_transfer)) }


    rule(:provenance) {(period | fallback).repeat(1)}
    root :provenance

    end
  end
end