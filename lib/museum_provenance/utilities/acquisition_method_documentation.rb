require "graphviz"

module MuseumProvenance
  module Utilities
    class AcquisitionMethodDocumentation

      def initialize(methods)
        @methods = methods
      end

      def self.create_documentation(output_directory=".",output_file="acquisition_methods.md")
        root_types = AcquisitionMethod.valid_methods.collect{ |m| m if m.parent.nil?}.compact
        File.open("#{output_directory}/#{output_file}", "w") do |f|
          root_types.each do |root|
            methods = AcquisitionMethod.valid_methods.reject{|m| m.type != root.type}
            viz = AcquisitionMethodDocumentation.new(methods)
            root_filename = "#{root.type}.png"
            filename = "#{output_directory}/#{root_filename}"
            viz.output_graph(filename)
 
            f.puts "![](#{root_filename})"
            f.puts viz.describe
            f.puts "--------------------------------------------------------------------------------"
        end
        end
      end

      def output_graph(filename = "methods.png")
       # Create a new graph
       g = ::GraphViz.new( :G, :type => :digraph, rankdir: "BT")

        nodes = {}
        @methods.each do |method|
          nodes[method.id] = g.add_node(method.name)
        end
    
        @methods.each do |method|
          if method.parent
            n1 = nodes[method.id]
            n2 = nodes[method.parent.id]
            g.add_edges(n1,n2)
          end
        end
       # # Generate output image
       g.output( :png => filename )
      end

      # Generates Markdown example files for provided acquisition methods
      #
      # @param name [String] a name for use in examples.
      # @param location [String] a location for use in examples.
      # @param date [String] a date for use in examples.
      # @return [Array] an array of markdown-formatted strings.  
      def describe(name="Vincent Price [1911-1993]", location="St. Louis, Missouri", date="July 1969")
         @methods.collect do |m|
          s = ""
          s += ("#{m.class_description}\n\n") if m.parent.nil?
          s += "### #{m.name}"
          s += "\n\n**#{m.definition.strip}**"
          s += "\n\n*#{m.explanation.strip}*" if m.explanation
          s += "\n\n**Preferred Form:** #{m.send(m.preferred_form)}  "
          s += "\n**Other Forms:**    #{m.other_forms.join("; ")}  " unless m.other_forms.empty?
          # s += "\n**Base Type:**      #{m.type}  " unless m.parent.nil?
          # s += "\n**Parent Type:**    #{m.parent.name}  " unless m.parent.nil?
          s += "\n\n**Example: **       #{[m.attach_to_name(name),location,date].compact.join(", ")}#{["."].sample}  "
          s += "\n\n"
         end
      end
    end
  end
end