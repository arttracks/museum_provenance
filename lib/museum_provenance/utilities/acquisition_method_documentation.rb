require "graphviz"
require 'linkeddata'
require 'rdf/turtle'
require 'rdf/ntriples'
require 'json/ld'


module MuseumProvenance
  module Utilities
    class AcquisitionMethodDocumentation

      def initialize(methods)
        @methods = methods
      end

      def self.create_documentation(output_directory=".", file_type=:png ,output_file="acquisition_methods.md")
        root_types = AcquisitionMethod.valid_methods.collect{ |m| m if m.parent.nil?}.compact
        File.open("#{output_directory}/#{output_file}", "w") do |f|
          root_types.each do |root|
            methods = AcquisitionMethod.valid_methods.reject{|m| m.type != root.type}
            viz = AcquisitionMethodDocumentation.new(methods)
            root_filename = "#{root.type}.#{file_type.to_s}"
            filename = "#{output_directory}/#{root_filename}"
            viz.output_graph(filename, file_type)
 
            f.puts "![](#{root_filename})"
            f.puts viz.describe
            f.puts "--------------------------------------------------------------------------------"
        end
        end
      end

      SKOS_JSON_LD = <<~eos
      {
        "@context": {
          "@language": "en",

          "skos:hasTopConcept":  {"@type": "@id"},
          "rdfs:subClassOf":     {"@type": "@id"},
          "rdfs:domain":         {"@type": "@id"},
          "rdfs:range":          {"@type": "@id"},
          "rdf:type":            {"@type": "@id"},
          "rdfs:subPropertyOf":  {"@type": "@id"}

        },
        "@graph": [
          {
            "@id":  "acq:AcquisitionMethod",
            "rdfs:subClassOf": "skos:Concept",
            "rdf:type": "owl:Class"
          },
          {
            "@id": "acq:prefTerm",
            "@type": ["owl:DatatypeProperty", "owl:FunctionalProperty", "owl:InverseFunctionalProperty"],
            "rdfs:label": "This is the preferred prefix term used to describe the method of acquisition.",
            "rdfs:domain": "acq:AcquisitionMethod",
            "rdfs:range":  "xsd:string",
            "rdfs:subPropertyOf": "acq:terms"
          },
          {
            "@id": "acq:terms",
            "@type": ["owl:DatatypeProperty", "owl:InverseFunctionalProperty"],
            "rdfs:label": "This is the list of prefix terms used to describe the method of acquisition.",
            "rdfs:domain": "acq:AcquisitionMethod",
            "rdfs:range":  "xsd:string" 
          },
          {
            "@id": "acq:transfersCustody",
            "@type": ["owl:DatatypeProperty"],
            "rdfs:label": "This method allows custody transfer.",
            "rdfs:domain": "acq:AcquisitionMethod",
            "rdfs:range":  "xsd:boolean" 
          },

          {
            "@id": "acq:transfersOwnership",
            "@type": ["owl:DatatypeProperty"],
            "rdfs:label": "This method allows ownership transfer.",
            "rdfs:domain": "acq:AcquisitionMethod",
            "rdfs:range":  "xsd:boolean" 
          },
          {
            "@id":  "acq:Prefix",
            "rdfs:subClassOf": "skos:Concept",
            "rdf:type": "owl:Class"
          },  
          {
            "@id":  "acq:Suffix",
            "rdfs:subClassOf": "skos:Concept",
            "rdf:type": "owl:Class"
          }    
        ]
      }
      eos

      def self.create_skos(output_directory=".",output_file="acquisition_methods.ttl",base_uri="http://vocabularies.museumprovenance.org/acquisition/", default_name="Vincent Price")
        
        # Define a set of prefixes
        prefixes = {
          foaf: "http://xmlns.com/foaf/0.1/",
          skos: "http://www.w3.org/2004/02/skos/core#",
          acq:  base_uri,
          rdf:  "http://www.w3.org/1999/02/22-rdf-syntax-ns#",
          rdfs: "http://www.w3.org/2000/01/rdf-schema#",
          owl:  "http://www.w3.org/2002/07/owl#",
          xsd:  "http://www.w3.org/2001/XMLSchema#",
        }

        # load the generic JSON-LD
        input = JSON.parse(SKOS_JSON_LD)
        prefixes.each do |prefix,uri|
          input["@context"][prefix.to_s] = uri
        end
        # puts JSON.pretty_generate input

        graph = RDF::Graph.new << JSON::LD::API.toRdf(input)

        # Define SKOS to make our life simpler
        skos = RDF::StrictVocabulary.new(prefixes[:skos])
        acq = RDF::Vocabulary.new(base_uri)

        top_level = RDF::URI(base_uri)
        graph << [top_level, RDF.type, skos.ConceptScheme]
        graph << [top_level, skos.prefLabel, "Museum Provenance Acquisition Method Ontology"]

        # Calculate all top-level concepts
        root_types = AcquisitionMethod.valid_methods.collect{ |m| m if m.parent.nil?}.compact


        root_types.each do |root|
          methods = AcquisitionMethod.valid_methods.reject{|m| m.type != root.type}
          root_uri = RDF::URI("#{top_level}#{root.id}")
          
          # make all root concepts top-level in SKOS
          graph << [top_level, skos.hasTopConcept, root_uri]

          methods << root

          # Add the properties for each method.
          methods.each do |acq_method|
            method_uri = RDF::URI("#{top_level}#{acq_method.id}")
            graph << [method_uri, RDF.type,        acq.AcquisitionMethod]
            graph << [method_uri, skos.prefLabel,  acq_method.name]
            graph << [method_uri, skos.definition, acq_method.definition]
            graph << [method_uri, skos.scopeNote,  acq_method.explanation] if acq_method.explanation
            graph << [method_uri, skos.example,    acq_method.attach_to_name(default_name)]
            graph << [method_uri, skos.inScheme,   top_level]
            graph << [method_uri, acq.prefTerm,    acq_method.preferred]
            graph << [method_uri, acq.prefForm,    (acq_method.preferred_form == AcquisitionMethod::Prefix ? acq.Prefix : acq.Suffix)]
            acq_method.other_forms.each do |term|
              graph << [method_uri, acq.terms,     term]
            end
            graph << [method_uri, acq.transfersCustody, acq_method.custody_transfer]
            graph << [method_uri, acq.transfersOwnership, acq_method.ownership_transfer]
            if acq_method.parent
              graph << [method_uri, skos.broader, RDF::URI("#{top_level}#{acq_method.parent.id}")] 
            end
          end

        end

        # Generate output
        File.open("#{output_directory}/#{output_file}", "w") do |f|
          f.puts graph.dump(:ttl, prefixes: prefixes)
          # f.puts graph.dump(:ntriples)
        end

      end

      def output_graph(filename = "methods.png", file_type = :png)
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
       g.output( file_type => filename )
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