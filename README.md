# MuseumProvenance

`museum_provenance` is a Ruby library developed to help cultural institutions manage and understand the provenance of the objects within their collection.

It does this by parsing semi-structured provenance texts into structured data.

A subproject of the [Art Tracks](http://blog.cmoa.org/tag/art-tracks/) project for the [Carnegie Museum of Art](http://www.cmoa.org) in Pittsburgh, PA.

## Installation

Add this line to your application's Gemfile:

    gem 'museum_provenance'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install museum_provenance

## Usage

    require 'museum_provenance'

    provenance_text = "Artist estate; Michel Monet, son of the artist, Sorel Moussel, Dept. Eure et Loire, 1926; Walter P. Chrysler, Jr., New York, NY, 1950; purchased by Museum, April 1962."

    timeline = MuseumProvenance::Provenance.extract provenance_text

    puts timeline.to_json
 

    {
       "period": [
         {
          "period_certainty": true,
          "party": "Artist estate",
          "party_certainty": true,
          "original_text": "Artist estate",
          "provenance": "Artist estate",
          "parsable": true,
          "direct_transfer": true,
          "footnote": "",
          "primary_owner": true,
          "order": 0,
          "acquisition_time_span": "",
          "deacquisition_time_span": "",
          "latest_possible": -1357063200,
          "latest_definite": -1388512800
        },
        {
          "period_certainty": true,
          "party": "Michel Monet, son of the artist",
          "party_certainty": true,
          "location": "Sorel Moussel, Dept. Eure et Loire",
          "location_certainty": true,
          "botb": -1388512800,
          "botb_certainty": true,
          "botb_precision": 1,
          "eotb": -1357063200,
          "eotb_certainty": true,
          "eotb_precision": 1,
          "original_text": "Michel Monet, son of the artist, Sorel Moussel, Dept. Eure et Loire, 1926",
          "provenance": "Michel Monet, son of the artist, Sorel Moussel, Dept. Eure et Loire, 1926",
          "parsable": true,
          "direct_transfer": true,
          "footnote": "",
          "primary_owner": true,
          "date_string": "1926",
          "order": 1,
          "acquisition_time_span": "1926",
          "deacquisition_time_span": "",
          "earliest_possible": -1388512800,
          "latest_possible": -599680800,
          "earliest_definite": -1357063200,
          "latest_definite": -631130400,
          "timestring": "1926"
        },
        {
          "period_certainty": true,
          "party": "Walter P. Chrysler, Jr.",
          "party_certainty": true,
          "location": "New York, NY",
          "location_certainty": true,
          "botb": -631130400,
          "botb_certainty": true,
          "botb_precision": 1,
          "eotb": -599680800,
          "eotb_certainty": true,
          "eotb_precision": 1,
          "original_text": "Walter P. Chrysler, Jr., New York, NY, 1950",
          "provenance": "Walter P. Chrysler, Jr., New York, NY, 1950",
          "parsable": true,
          "direct_transfer": true,
          "footnote": "",
          "primary_owner": true,
          "date_string": "1950",
          "order": 2,
          "acquisition_time_span": "1950",
          "deacquisition_time_span": "",
          "earliest_possible": -631130400,
          "latest_possible": -242161200,
          "earliest_definite": -599680800,
          "latest_definite": -244663200,
          "timestring": "1950"
        },
        {
          "period_certainty": true,
          "acquisition_method": "Purchase",
          "party": "Museum",
          "party_certainty": true,
          "botb": -244663200,
          "botb_certainty": true,
          "botb_precision": 2,
          "eotb": -242161200,
          "eotb_certainty": true,
          "eotb_precision": 2,
          "original_text": "purchased by Museum, April 1962",
          "provenance": "purchased by Museum, April 1962",
          "parsable": true,
          "footnote": "",
          "primary_owner": true,
          "date_string": "April 1962",
          "order": 3,
          "acquisition_time_span": "April 1962",
          "deacquisition_time_span": "",
          "earliest_possible": -244663200,
          "latest_possible": 1416722400,
          "earliest_definite": -242161200,
          "latest_definite": 1416722400,
          "timestring": "April 1962"
        }
    }

## Contributing

1. Fork it ( https://github.com/cmoa/museum_provenance/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
