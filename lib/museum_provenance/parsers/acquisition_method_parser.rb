require_relative "parser_helpers"

module MuseumProvenance
  module Parsers
    class AcquisitionMethodParser < Parslet::Parser
      include Parslet
      include ParserHelpers

      def initialize(acq_methods)
        @acquisition_methods = acq_methods
      end

      def preferred_form
        all_forms = @acquisition_methods.collect do |m| 
          str = String.new(m.preferred)
          str[0] = str[0].upcase if str[0]
          [m.preferred, str]
        end.compact.flatten
        all_forms = all_forms.sort_by{|t| t.length}.reverse

        (all_forms.reduce(false) do |parslet,val| 
          parslet ? parslet | str(val).as(:acquisition_method_string) : str(val).as(:acquisition_method_string)
        end).as(:acquisition_method)
      end

      rule (:acquisition_method) {preferred_form  >> space}
      
      root :acquisition_method


    end
  end
end