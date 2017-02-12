require_relative "parser_helpers"
module MuseumProvenance
  module Parsers
    class AcquisitionMethodParser < Parslet::Parser
      include Parslet
      include ParserHelpers

      def initialize(acq_methods)
        @acquisition_methods = acq_methods
      end

      def generate_list(magic_word)        
        all_forms = @acquisition_methods.collect do |m| 
          m.forms.find_all{|m| (m =~ /#{Regexp.quote(magic_word)}$/)}.collect{|a| {str: a.gsub(/#{Regexp.quote(magic_word)}$/, "").downcase, id: "acquisition_method_#{m.id}"}}
        end.flatten

        (all_forms.sort_by{|t| t[:str].length}.reverse.inject(false) do |parslet,val| 
          parslet ?  parslet | str_i(val[:str]).as(val[:id]) : str_i(val[:str]).as(val[:id])
        end >> space?).as(:acquisition_method)
      end

      # Magic Words
      rule (:custody_start_by)     { str("by")  >> space }
      rule (:custody_start_to)     { str("to") >> space }
      rule (:custody_start)        {custody_start_by | custody_start_to}

      # Acquisition Method forms
      rule (:acquisition_method_by_list) { generate_list(" by") }
      rule (:acquisition_method_to_list) { generate_list(", to") | generate_list(" to") }
      rule (:acquisition_method) {acquisition_method_by_list | acquisition_method_to_list}
      
      root :acquisition_method
      # # All the different options
      # rule (:acquisition) {
      #   (
      #     (acquisition_method_by_list >> custody_start_by.absent? >> event_location >> custody_start_by) |
      #     (acquisition_method_to_list >> custody_start_to.absent? >> event_location >> custody_start_to) |
      #     (acquisition_methods >> custody_start.absent? >> event_location) |
      #     (acquisition_methods >> custody_start ) |
      #     (acquisition_methods >> ownership_start.present? ) |
      #     acquisition_methods >> comma.maybe
      #   ).maybe
      # }

    end
  end
end