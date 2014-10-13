# MuseumProvenance

A ruby library for converting provenance records for works of art into structured date for museums and other cultural institutions.  

A subproject of the [Art Tracks] project for the Carnegie Museum of Art in Pittsburgh, PA.

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

    puts timeline.to_csv

| period_certainty | acquisition_method | party                           | party_certainty | birth | birth_certainty | death | death_certainty | location                           | location_certainty | botb       | botb_certainty | botb_precision | eotb       | eotb_certainty | eotb_precision | bote | bote_certainty | bote_precision | eote | eote_certainty | eote_precision | original_text                                                             | provenance                                                                | parsable | direct_transfer | stock_number | footnote |
|------------------|--------------------|---------------------------------|-----------------|-------|-----------------|-------|-----------------|------------------------------------|--------------------|------------|----------------|----------------|------------|----------------|----------------|------|----------------|----------------|------|----------------|----------------|---------------------------------------------------------------------------|---------------------------------------------------------------------------|----------|-----------------|--------------|----------|
| true             |                    | Artist estate                   | true            |       |                 |       |                 |                                    |                    |            |                |                |            |                |                |      |                |                |      |                |                | Artist estate                                                             | Artist estate                                                             | true     | true            |              |          |
| true             |                    | Michel Monet, son of the artist | true            |       |                 |       |                 | Sorel Moussel, Dept. Eure et Loire | true               | 1926-01-01 | true           | 1              | 1926-01-01 | true           | 1              |      |                |                |      |                |                | Michel Monet, son of the artist, Sorel Moussel, Dept. Eure et Loire, 1926 | Michel Monet, son of the artist, Sorel Moussel, Dept. Eure et Loire, 1926 | true     | true            |              |          |
| true             |                    | Walter P. Chrysler, Jr.         | true            |       |                 |       |                 | New York, NY                       | true               | 1950-01-01 | true           | 1              | 1950-01-01 | true           | 1              |      |                |                |      |                |                | Walter P. Chrysler, Jr., New York, NY, 1950                               | Walter P. Chrysler, Jr., New York, NY, 1950                               | true     | true            |              |          |
| true             | Purchase           | Museum                          | true            |       |                 |       |                 |                                    |                    | 1962-04-01 | true           | 2              | 1962-04-01 | true           | 2              |      |                |                |      |                |                | purchased by Museum, April 1962                                           | purchased by Museum, April 1962                                           | true     |                 |              |          |

## Contributing

1. Fork it ( https://github.com/cmoa/museum_provenance/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
